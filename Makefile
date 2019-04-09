GIT_VERSION := $(shell git rev-parse HEAD)

all: | pull build

pull:
	docker pull bearstech/debian:stretch

build:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		-t bearstech/java:latest \
		.
	docker tag bearstech/java:latest bearstech/java:1.8

push:
	docker push bearstech/java:latest
	docker push bearstech/java:1.8

tests:
	@echo 'ok'

down:
	@echo 'ok'
