PY?=python3
PELICAN?=pelican
PELICANOPTS=
S3OPTS=

AWSCLI_PROFILE=codependentcodr

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

S3_BUCKET=www.codependentcodr.com
DOCKER_IMAGE_NAME=codependentcodr
DOCKER_IMAGE_TAGS := $(shell docker images --format '{{.Repository}}:{{.Tag}}' | grep '$(DOCKER_IMAGE_NAME)')

SHA := $(shell git rev-parse --short HEAD)
DEPLOY_TIME := $(shell date -u +"%Y-%m-%dT%H-%M-%SZ_%s%3")
HOST := $(shell hostname)


DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
	S3OPTS += --dryrun
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          start/restart develop_server.sh    '
	@echo '   make stopserver                     stop local server                  '
	@echo '   make s3_upload                      upload the web site via S3         '
	@echo '   make markdownlint                   run markdownlint on content        '
	@echo '   make pylint                         run pylint on content              '
	@echo '   make lint_the_things                run all linters & checks           '
	@echo '   make dockerbuild                    build docker image                 '
	@echo '   make dockerrun                      run a shell in built Docker image  '
	@echo '   make cfinvalidate                   invalidate the CF cache of html    '
	@echo '   make s3cachecontrol                 set cache control on stuff in s3   '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	docker rmi $(DOCKER_IMAGE_TAGS) || true

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
	find output -name .DS_Store | xargs rm

deploy: s3_upload s3cachecontrol tag slackpost

s3_upload: publish lint_the_things
	# don't upload if directory is dirty
	./git-clean-dir.sh
	aws --profile $(AWSCLI_PROFILE) s3 sync $(OUTPUTDIR) s3://$(S3_BUCKET) --delete $(S3OPTS)

tag:
	git tag "$(DEPLOY_TIME)_$(SHA)"
	git push origin $(DEPLOY_TIME)_$(SHA)

lint_the_things: markdownlint pylint

markdownlint: dockerbuild
	docker run --rm -it -w /build/content $(DOCKER_IMAGE_NAME):latest markdownlint .

pylint: dockerbuild
	docker run --rm -it -w /build/python $(DOCKER_IMAGE_NAME):latest pylint *.py

dockerbuild:
	docker build -t $(DOCKER_IMAGE_NAME):latest .

dockerrun: dockerbuild
	docker run -it --rm $(DOCKER_IMAGE_NAME):latest /bin/sh

slackpost:
	curl -X POST --data-urlencode "payload={\"channel\": \"#codependentcodr\", \"username\": \"$(USER)@$(HOST)\", \"text\": \"Deployed $(SHA).\", \"icon_emoji\": \":rocket:\"}" https://hooks.slack.com/services/$(SLACK_TOKEN)

cfinvalidate:
	aws --profile $(AWSCLI_PROFILE) cloudfront create-invalidation --distribution-id ER3YIY14W87BX --paths '/*.html' '/' '/feeds/all.atom.xml'

s3cachecontrol:
	python3 update_cache_control.py

.PHONY: html help clean regenerate serve serve-global devserver stopserver publish s3_upload github
