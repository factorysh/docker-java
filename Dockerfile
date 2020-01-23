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

# generated labels

ARG GIT_VERSION
ARG GIT_DATE
ARG BUILD_DATE

LABEL \
    com.bearstech.image.revision_date=${GIT_DATE} \
    org.opencontainers.image.authors=Bearstech \
    org.opencontainers.image.revision=${GIT_VERSION} \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.url=https://github.com/factorysh/docker-java \
    org.opencontainers.image.source=https://github.com/factorysh/docker-java/blob/${GIT_VERSION}/Dockerfile
