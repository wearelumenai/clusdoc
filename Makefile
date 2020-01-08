DOCKER=docker-compose -f deployments/docker-compose.yml

all: build docker-build

build:
	hugo ${args}

doc:
	hugo server --renderToDisk ${args}

doc-dev:
	hugo server --renderToDisk -D ${args}

docker-build:
	$(DOCKER) build ${args}

docker:
	$(DOCKER) up tlotl-website ${args}

docker-dev:
	$(DOCKER) up tlotl-website-dev ${args}

.PHONY: build doc doc-dev docker-build docker docker-dev
