GIT_VERSION := $(shell git rev-parse HEAD)

all: | pull build

pull:
	docker pull bearstech/debian:stretch

build: | build-java build-dev build-gradle

build-dev: build-java-dev-1.8 build-java-dev-11

build-java: build-java-1.8 build-java-11

build-java-1.8:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg jdkjre=jre \
		-t bearstech/java:1.8 \
		.
	docker tag bearstech/java:1.8 bearstech/java:8

build-java-dev-1.8:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg jdkjre=jdk \
		-t bearstech/java-dev:1.8 \
		.
	docker tag bearstech/java-dev:1.8 bearstech/java-jdk:1.8
	docker tag bearstech/java-dev:1.8 bearstech/java-dev:8
	docker tag bearstech/java-dev:1.8 bearstech/java-jdk:8

build-java-11:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg jdkjre=jre \
		-t bearstech/java:11 \
		-f Dockerfile.11 \
		.
	docker tag bearstech/java:11 bearstech/java:latest

build-java-dev-11:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg jdkjre=jdk \
		-t bearstech/java-dev:11 \
		-f Dockerfile.11 \
		.
	docker tag bearstech/java-dev:11 bearstech/java-dev:latest
	docker tag bearstech/java-dev:11 bearstech/java-jdk:latest
	docker tag bearstech/java-dev:11 bearstech/java-jdk:11

build-gradle: build-gradle-1.8 build-gradle-11

build-gradle-1.8:
	docker build \
		--build-arg java_version=1.8 \
		-t bearstech/java-gradle:8 \
		-f Dockerfile.gradle \
		.

build-gradle-11:
	docker build \
		--build-arg java_version=11 \
		-t bearstech/java-gradle:11 \
		-f Dockerfile.gradle \
		.
	docker tag bearstech/java-gradle:11 bearstech/java-gradle:latest

push:
	docker push bearstech/java:latest
	docker push bearstech/java:1.8
	docker push bearstech/java-gradle:latest
	docker push bearstech/java-gradle:5

tests:
	@echo 'ok'

down:
	@echo 'ok'
