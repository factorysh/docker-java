
all: | pull build

pull:
	docker pull bearstech/debian:stretch

build: java

java:
	docker build -t bearstech/java:latest .
	docker tag bearstech/java:latest bearstech/java:1.8

push:
	docker push bearstech/java:latest
	docker push bearstech/java:1.8

tests:
	@echo 'ok'
