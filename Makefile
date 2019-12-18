all: doc

build:
	hugo

doc:
	hugo server --renderToDisk

doc-drafts:
	hugo server --renderToDisk -D

docker:
	docker-compose -f deployments/docker-compose.yml up --build

docker-drafts:
	docker-compose -f deployments/docker-compose.dev.yml up
