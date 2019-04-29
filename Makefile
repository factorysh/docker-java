GIT_VERSION := $(shell git rev-parse HEAD)

all: | pull build

pull:
	docker pull bearstech/debian:stretch

build: | build-java build-gradle

build-java:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		-t bearstech/java:latest \
		.
	docker tag bearstech/java:latest bearstech/java:1.8

build-gradle:
	docker build \
		-t bearstech/gradle:latest \
		-f Dockerfile.gradle \
		.
	docker tag bearstech/gradle:latest bearstech/gradle:5

push:
	docker push bearstech/java:latest
	docker push bearstech/java:1.8
	docker push bearstech/gradle:latest
	docker push bearstech/gradle:5

tests:
	@echo 'ok'

down:
	@echo 'ok'
