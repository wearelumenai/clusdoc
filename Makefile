DOCK=docker-compose -p clusapp
DOCKER=$(DOCK) -f deployments/docker-compose.yml
DOCKER_DEV=$(DOCK) -f deployments/docker-compose.dev.yml

all: build docker-build

.PHONY: build
build:
	hugo ${args}

.PHONY: start
start:
	hugo server -p 8004 --renderToDisk ${args}

.PHONY: dev
dev:
	hugo server -p 8004 --renderToDisk -D ${args}

.PHONY: test
test:
	echo "no test"

.PHONY: lint
lint:
	echo "no lint"

.PHONY: docker-cmd
docker-cmd:
	$(DOCKER) ${cmd} ${args}

.PHONY: docker-up
docker-up:
	cmd=up args="${args}" make docker-cmd

.PHONY: docker-build
docker-build:
	cmd=build args="${args}" make docker-cmd

.PHONY: docker-stop
docker-stop:
	cmd=stop args="${args}" make docker-cmd

.PHONY: docker-down
docker-down:
	cmd=down args="${args}" make docker-cmd

.PHONY: docker-logs
docker-logs:
	cmd=logs args="${args}" make docker-cmd

.PHONY: docker-restart
docker-restart:
	cmd=restart args="${args}" make docker-cmd

.PHONY: docker-config
docker-config:
	cmd=config args="${args}" make docker-cmd

.PHONY: docker-tty
docker-tty:
	cmd=exec args="clusdoc /bin/sh" make docker-cmd

.PHONY: docker-dev-cmd
docker-dev-cmd:
	$(DOCKER_DEV) ${cmd} ${args}

.PHONY: docker-dev-up
docker-dev-up:
	cmd=up args="${args}" make docker-dev-cmd

.PHONY: docker-dev-build
docker-dev-build:
	cmd=build args="${args}" make docker-dev-cmd

.PHONY: docker-dev-stop
docker-dev-stop:
	cmd=stop args="${args}" make docker-dev-cmd

.PHONY: docker-dev-down
docker-dev-down:
	cmd=down args="${args}" make docker-dev-cmd

.PHONY: docker-dev-logs
docker-dev-logs:
	cmd=logs args="${args}" make docker-dev-cmd

.PHONY: docker-dev-restart
docker-dev-restart:
	cmd=restart args="${args}" make docker-dev-cmd

.PHONY: docker-dev-config
docker-dev-config:
	cmd=config args="${args}" make docker-dev-cmd

.PHONY: docker-dev-tty
docker-dev-tty:
	cmd=exec args="clusdoc /bin/sh" make docker-dev-cmd
