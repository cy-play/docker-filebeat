FROM alpine:3.4

MAINTAINER Mourad Maatoug <mr.maatoug@gmail.com>

ENV FILEBEAT_VERSION 1.0.1
ENV GLIBC_VERSION 2.23-r3

# Installing Glibc
RUN apk --update add --virtual setup-tool ca-certificates curl wget && \
    curl -s -o /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk && \
    apk add glibc-$GLIBC_VERSION.apk && \
    rm glibc-$GLIBC_VERSION.apk && \
    apk del setup-tool

WORKDIR /filebeat

# Installing Filebeat and SHA1 Checking
RUN apk --update add --virtual setup-tool wget && \
  wget -q http://download.elastic.co/beats/filebeat/filebeat-${FILEBEAT_VERSION}-x86_64.tar.gz && \
  wget -q http://download.elastic.co/beats/filebeat/filebeat-${FILEBEAT_VERSION}-x86_64.tar.gz.sha1.txt && \
  sha1sum -c filebeat-${FILEBEAT_VERSION}-x86_64.tar.gz.sha1.txt && \
  tar xzf filebeat-${FILEBEAT_VERSION}-x86_64.tar.gz && \
  mv filebeat-${FILEBEAT_VERSION}-x86_64/* /filebeat && \
  rm -rf filebeat-${FILEBEAT_VERSION}-x86_64* && \
	apk del setup-tool

COPY filebeat.yml /filebeat/config

ENTRYPOINT ["/filebeat/filebeat", "-e", "-c", "/filebeat/config/filebeat.yml"]
