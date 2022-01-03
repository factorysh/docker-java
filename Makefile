
include Makefile.lint
include Makefile.build_args

GOSS_VERSION := 0.3.16
GRADLE_VERSION := 7.3.3
CLOJURE_VERSION := 1.10.2.774

all: | pull build

pull:
	docker pull bearstech/debian:stretch

build: | build-java build-dev build-gradle build-clojure

build-dev: build-java-dev-1.8 build-java-dev-11

build-java: build-java-1.8 build-java-11

build-java-1.8:
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		--build-arg jdkjre=jre \
		-t bearstech/java:1.8 \
		.
	docker tag bearstech/java:1.8 bearstech/java:8

build-java-dev-1.8:
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		--build-arg jdkjre=jdk \
		-t bearstech/java-dev:1.8 \
		.
	docker tag bearstech/java-dev:1.8 bearstech/java-jdk:1.8
	docker tag bearstech/java-dev:1.8 bearstech/java-dev:8
	docker tag bearstech/java-dev:1.8 bearstech/java-jdk:8

build-java-11:
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		--build-arg jdkjre=jre \
		-t bearstech/java:11 \
		-f Dockerfile.11 \
		.
	docker tag bearstech/java:11 bearstech/java:latest

build-java-dev-11:
	 docker build \
		$(DOCKER_BUILD_ARGS) \
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
		$(DOCKER_BUILD_ARGS) \
		--build-arg java_version=1.8 \
		--build-arg GRADLE_VERSION=${GRADLE_VERSION} \
		-t bearstech/java-gradle:8 \
		-f Dockerfile.gradle \
		.

build-gradle-11:
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		--build-arg java_version=11 \
		--build-arg GRADLE_VERSION=${GRADLE_VERSION} \
		-t bearstech/java-gradle:11 \
		-f Dockerfile.gradle \
		.
	docker tag bearstech/java-gradle:11 bearstech/java-gradle:latest

build-clojure:
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		--build-arg java_version=11 \
		--build-arg VERSION=${CLOJURE_VERSION} \
		-t bearstech/java-clojure-dev:11 \
		-f Dockerfile.clojure \
		.
	docker tag bearstech/java-clojure-dev:11 bearstech/java-clojure-dev:latest

push:
	docker push bearstech/java:1.8
	docker push bearstech/java:8
	docker push bearstech/java:11
	docker push bearstech/java:latest
	docker push bearstech/java-jdk:1.8
	docker push bearstech/java-jdk:8
	docker push bearstech/java-jdk:11
	docker push bearstech/java-jdk:latest
	docker push bearstech/java-dev:1.8
	docker push bearstech/java-dev:8
	docker push bearstech/java-dev:11
	docker push bearstech/java-dev:latest
	docker push bearstech/java-gradle:11
	docker push bearstech/java-gradle:8
	docker push bearstech/java-gradle:latest
	docker push bearstech/java-clojure-dev:11
	docker push bearstech/java-clojure-dev:latest

bin:
	mkdir -p bin

bin/goss: bin
	curl -o bin/goss -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64
	chmod +x bin/goss

tests-java: bin/goss
	for version in 8 11; do \
		for a in java:$$version java-jdk:$$version java-gradle:$$version ; do \
			echo "testing $$a"; \
			docker run --rm \
			-v `pwd`/bin/goss:/usr/local/bin/goss:ro \
			-v `pwd`/tests:/tests:ro \
			-w /tests \
			bearstech/$$a \
			goss --vars=vars_$${version}.yml -g java.yml validate; \
		done ; \
	done

tests-gradle: bin/goss
	for version in 8 11; do \
		docker run --rm \
		-v `pwd`/bin/goss:/usr/local/bin/goss:ro \
		-v `pwd`/tests:/tests:ro \
		-w /tests \
		bearstech/java-gradle:$$version \
		goss -g gradle.yml validate; \
	done

tests: tests-java tests-gradle

down:
	@echo 'ok'
