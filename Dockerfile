FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FREECAD_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=FreeCAD

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/freecad-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    wget \
    python3-pyside2.qtwebchannel \
    python3-pyside2.qtwebengine* && \
  echo "**** add repo for openfoam ****" && \
  curl -s https://dl.openfoam.com/add-debian-repo.sh | sudo bash && \
  apt-get update && \
  apt-get install -y --no-install-recommends openfoam2412-default && \
  echo "**** add testing repo for freecad and paraview + others ****" && \
  echo "deb http://httpredir.debian.org/debian trixie main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get -t trixie install -y --no-install-recommends freecad paraview gmsh && \
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
EXPOSE 3000

VOLUME /config
