
all: | pull build

pull:
	docker pull bearstech/debian:stretch

build: java

java:
	docker build -t bearstech/java:latest .

push:
	docker push bearstech/java:latest

tests:
	@echo 'ok'
