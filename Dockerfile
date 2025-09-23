# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SPOTUBE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Spotube

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/spotube-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  if [ -z ${SPOTUBE_VERSION+x} ]; then \
    SPOTUBE_VERSION=$(curl -sX GET "https://api.github.com/repos/KRTirtho/spotube/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/spotube.deb -L \
    "https://github.com/KRTirtho/spotube/releases/download/${SPOTUBE_VERSION}/Spotube-linux-x86_64.deb" && \
  apt install -y --no-install-recommends \
    /tmp/spotube.deb && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
