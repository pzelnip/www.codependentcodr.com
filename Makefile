PY?=python3
PELICAN?=pelican
PELICANOPTS=

AWSCLI_PROFILE=codependentcodr

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

DOCKER_IMAGE_NAME=codependentcodr

SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s")
HOST := $(shell hostname)

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

serve-global:
ifdef SERVER
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 $(SERVER)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 0.0.0.0
endif

devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	$(BASEDIR)/develop_server.sh stop
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

s3_upload:
	docker run -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) --rm -it -w /build $(DOCKER_IMAGE_NAME):latest ./s3_push.sh

cleanbranches:
	git remote | xargs -n 1 git fetch -v --prune $1
	git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

tag:
	git remote add travis https://${GH_TOKEN}@github.com/pzelnip/www.codependentcodr.com
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push travis $(DEPLOY_TIME)_$(SHA)

lint_the_things: markdownlint pylint

markdownlint: dockerbuild
	docker run --rm -it -w /build $(DOCKER_IMAGE_NAME):latest markdownlint -i theme/ .

pylint: dockerbuild
	docker run --rm -it -w /build $(DOCKER_IMAGE_NAME):latest pylint *.py

dockerbuild:
	docker build -t $(DOCKER_IMAGE_NAME):latest .

dockerrun: dockerbuild
	docker run -it --rm $(DOCKER_IMAGE_NAME):latest /bin/sh

slackpost:
	curl -X POST --data-urlencode "payload={\"channel\": \"#codependentcodr\", \"username\": \"$(USER)@$(HOST)\", \"text\": \"Deployed $(SHA).\", \"icon_emoji\": \":rocket:\"}" https://hooks.slack.com/services/$(SLACK_TOKEN)

cfinvalidate:
	aws --profile $(AWSCLI_PROFILE) cloudfront create-invalidation --distribution-id ER3YIY14W87BX --paths '/*.html' '/' '/feeds/all.atom.xml'

s3cachecontrol:
	echo "Cache control disabled until it's fixed"
	#python3 update_cache_control.py

dockerpush:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker tag $(DOCKER_IMAGE_NAME) pzelnip/$(DOCKER_IMAGE_NAME):latest
	docker tag $(DOCKER_IMAGE_NAME) pzelnip/$(DOCKER_IMAGE_NAME):$(SHA)
	docker push pzelnip/$(DOCKER_IMAGE_NAME):latest
	docker push pzelnip/$(DOCKER_IMAGE_NAME):$(SHA)

.PHONY: html help clean regenerate serve serve-global devserver stopserver publish s3_upload github

prebuild: dockerbuild

test: lint_the_things

deploy: s3_upload tag dockerpush slackpost

travis: prebuild test deploy
