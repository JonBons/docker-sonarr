FROM lsiobase/mono:xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN apt-get update && apt-get install -y \
    software-properties-common

RUN \
 echo "**** add sonarr repository ****" && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > \
	/etc/apt/sources.list.d/sonarr.list && \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	nzbdrone && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# Install ffmpeg
RUN add-apt-repository ppa:jonathonf/ffmpeg-3
RUN \
  apt-get update && \
  apt-get install -y ffmpeg git python-pip openssl python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev && \
  pip install requests && \
  pip install requests[security] && \
  pip install requests-cache && \
  pip install babelfish && \
  pip install 'guessit<2' && \
  pip install 'subliminal<2' && \
  pip install stevedore && \
  pip install python-dateutil && \
  pip install qtfaststart && \
  git clone git://github.com/mdhiggins/sickbeard_mp4_automator.git /sickbeard_mp4_automator/ && \ 
  touch /sickbeard_mp4_automator/info.log && \
  chmod a+rwx -R /sickbeard_mp4_automator && \
  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
    


# add local files
COPY root/ /

# ports and volumes
EXPOSE 8989
VOLUME /config /downloads /tv
