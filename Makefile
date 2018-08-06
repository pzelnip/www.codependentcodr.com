PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

SITE_NAME=codependentcodr
USER_NAME=pzelnip
REPO_NAME=$(USER_NAME)/www.codependentcodr.com

SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")
HOST := $(shell hostname)

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	docker images | grep $(SITE_NAME) | awk {'print $3'} | xargs docker rmi

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	$(BASEDIR)/develop_server.sh stop
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

cleanbranches:
	git remote | xargs -n 1 git fetch -v --prune $1
	git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

tag:
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push https://${GH_TOKEN}@github.com/$(REPO_NAME) $(DEPLOY_TIME)_$(SHA)

lint_the_things: markdownlint pylint pydocstyle

pydocstyle:
	docker run --rm -it -w /build $(SITE_NAME):latest pydocstyle .

markdownlint: dockerbuild
	docker run --rm -it -w /build $(SITE_NAME):latest markdownlint -i theme/ .

pylint: dockerbuild
	docker run --rm -it -w /build $(SITE_NAME):latest pylint *.py

dockerbuild:
	docker build -t $(SITE_NAME):latest .

dockerrun: dockerbuild
	docker run -it --rm $(SITE_NAME):latest /bin/sh

dockerpush:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):latest
	docker tag $(SITE_NAME) $(USER_NAME)/$(SITE_NAME):$(SHA)
	docker push $(USER_NAME)/$(SITE_NAME):latest
	docker push $(USER_NAME)/$(SITE_NAME):$(SHA)

slackpost:
	curl -X POST --data-urlencode "payload={\"channel\": \"#$(SITE_NAME)\", \"username\": \"$(USER)@$(HOST)\", \"text\": \"Deployed $(SITE_NAME), $(SHA).  https://www.$(SITE_NAME).com\", \"icon_emoji\": \":rocket:\"}" https://hooks.slack.com/services/$(SLACK_TOKEN)

cfinvalidate:
	aws cloudfront create-invalidation --distribution-id ER3YIY14W87BX --paths '/*.html' '/' '/feeds/all.atom.xml'

s3_upload:
	docker run -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) --rm -it -w /build $(SITE_NAME):latest ./s3_push.sh

safety:
	docker run -it --rm $(SITE_NAME):latest safety check -r requirements.txt --full-report

bandit:
	docker run -it --rm $(SITE_NAME):latest bandit . -r

blackenit:
	docker run -it --rm -v $(shell pwd):/build $(SITE_NAME):latest black .

test: blackenit lint_the_things safety bandit

deploy: dockerbuild s3_upload tag dockerpush slackpost

.PHONY: html clean regenerate devserver stopserver publish s3_upload cleanbranches tag lint_the_things markdownlint pylint dockerbuild dockerrun dockerpush slackpost cfinvalidate test deploy bandit blackenit
