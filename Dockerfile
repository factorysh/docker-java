FROM bearstech/debian:stretch

ENV DEBIAN_FRONTEND noninteractive

ARG jdkjre=jre
# we need openjdk
RUN set -eux \
    &&  apt-get update \
    &&  apt-get install -y --no-install-recommends \
                    openjdk-8-${jdkjre}-headless \
    &&  apt-get clean \
    &&  rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ARG GIT_VERSION
LABEL com.bearstech.source.java=https://github.com/factorysh/docker-java/commit/${GIT_VERSION}

