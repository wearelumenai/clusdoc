DOCKER=docker-compose -f deployments/docker-compose.yml

all: docker-build build

docker-build:
	$(DOCKER) build ${args}

build:
	hugo

doc:
	hugo server --renderToDisk

doc-drafts:
	hugo server --renderToDisk -D

docker:
	$(DOCKER) up ${args} tlotl-website

docker-drafts:
	$(DOCKER) up ${args} tlotl-website-dev

.PHONY: docker-build build doc doc-drafts docker docker-drafts
