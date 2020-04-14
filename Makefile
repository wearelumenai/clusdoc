DOCK=docker-compose -p clusapp
DOCKER=$(DOCK) -f deployments/docker-compose.yml
DOCKER_DEV=$(DOCK) -f deployments/docker-compose.dev.yml

all: build docker-build

.PHONY: build
build:
	hugo ${ARGS}

.PHONY: start
start:
	hugo server -p 8004 --renderToDisk ${ARGS}

.PHONY: dev
dev:
	hugo server -p 8004 --renderToDisk -D ${ARGS}

.PHONY: test
test:
	echo "no test"

.PHONY: lint
lint:
	echo "no lint"

.PHONY: docker-cmd
docker-cmd:
	$(DOCKER) ${CMD} ${ARGS}

.PHONY: docker-up
docker-up:
	CMD=up ARGS="${ARGS}" make docker-cmd

.PHONY: docker-build
docker-build:
	CMD=build ARGS="${ARGS}" make docker-cmd

.PHONY: docker-stop
docker-stop:
	CMD=stop ARGS="${ARGS}" make docker-cmd

.PHONY: docker-down
docker-down:
	CMD=down ARGS="${ARGS}" make docker-cmd

.PHONY: docker-logs
docker-logs:
	CMD=logs ARGS="${ARGS}" make docker-cmd

.PHONY: docker-restart
docker-restart:
	CMD=restart ARGS="${ARGS}" make docker-cmd

.PHONY: docker-config
docker-config:
	CMD=config ARGS="${ARGS}" make docker-cmd

.PHONY: docker-tty
docker-tty:
	CMD=exec ARGS="clusdoc /bin/sh" make docker-cmd

.PHONY: docker-dev-cmd
docker-dev-cmd:
	$(DOCKER_DEV) ${CMD} ${ARGS}

.PHONY: docker-dev-up
docker-dev-up:
	CMD=up ARGS="${ARGS}" make docker-dev-cmd

.PHONY: docker-dev-build
docker-dev-build:
	CMD=build ARGS="${ARGS}" make docker-dev-cmd

.PHONY: docker-dev-stop
docker-dev-stop:
	CMD=stop ARGS="${ARGS}" make docker-dev-cmd

.PHONY: docker-dev-down
docker-dev-down:
	CMD=down ARGS="${ARGS}" make docker-dev-cmd

.PHONY: docker-dev-logs
docker-dev-logs:
	CMD=logs ARGS="${ARGS}" make docker-dev-cmd

.PHONY: docker-dev-restart
docker-dev-restart:
	CMD=restart ARGS="${ARGS}" make docker-dev-cmd

.PHONY: docker-dev-config
docker-dev-config:
	CMD=config ARGS="${ARGS}" make docker-dev-cmd

.PHONY: docker-dev-tty
docker-dev-tty:
	CMD=exec ARGS="clusdoc /bin/sh" make docker-dev-cmd
