DOCK=docker-compose -p clusapp
DOCKER=$(DOCK) -f deployments/docker-compose.yml
DOCKER_DEV=$(DOCK) -f deployments/docker-compose.dev.yml

all: build docker-build

build:
	hugo ${args}

doc:
	hugo server --renderToDisk ${args}

doc-dev:
	hugo server --renderToDisk -D ${args}

docker:
	$(DOCKER) up ${args}

docker-build:
	$(DOCKER) build ${args}

docker-stop:
	$(DOCKER) Stop ${args}

docker-down:
	$(DOCKER) down ${args}

docker-logs:
	$(DOCKER) logs ${args}

docker-dev:
	$(DOCKER_DEV) up ${args}

docker-dev-build:
	$(DOCKER_DEV) build ${args}

docker-dev-stop:
	$(DOCKER_DEV) Stop ${args}

docker-dev-down:
	$(DOCKER_DEV) down ${args}

docker-dev-logs:
	$(DOCKER_DEV) logs ${args}

.PHONY: build doc doc-dev \
	docker docker-build docker-stop docker-down docker-logs \
	docker-dev docker-dev-build docker-dev-stop docker-dev-down docker-dev-logs
