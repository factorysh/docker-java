GIT_VERSION := $(shell git rev-parse HEAD)

all: | pull build

pull:
	docker pull bearstech/debian:stretch

build: | build-java build-gradle

build-java: build-java-1.8 build-java-11

build-java-1.8:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		-t bearstech/java:latest \
		.
	docker tag bearstech/java:latest bearstech/java:1.8

build-java-11:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		-t bearstech/java:11 \
		-f Dockerfile.11 \
		.

build-gradle: build-gradle-1.8 build-gradle-11

build-gradle-1.8:
	docker build \
		--build-arg java_version=1.8 \
		-t bearstech/java-gradle:latest \
		-f Dockerfile.gradle \
		.
	docker tag bearstech/java-gradle:latest bearstech/java-gradle:5

build-gradle-11:
	docker build \
		--build-arg java_version=11 \
		-t bearstech/java-gradle:11 \
		-f Dockerfile.gradle \
		.

push:
	docker push bearstech/java:latest
	docker push bearstech/java:1.8
	docker push bearstech/java-gradle:latest
	docker push bearstech/java-gradle:5

tests:
	@echo 'ok'

down:
	@echo 'ok'
