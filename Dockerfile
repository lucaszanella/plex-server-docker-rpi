FROM resin/rpi-raspbian:jessie

# Dependencies
RUN apt-get update \
 && apt-get upgrade \
 && apt-get install locales wget ca-certificates -y

# Setup locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
 && locale-gen

# Download/extract Plex ALPINE-ARMV7
ENV PLEX_LINK=https://downloads.plex.tv/plex-media-server/1.10.1.4602-f54242b6b/PlexMediaServer-1.10.1.4602-f54242b6b-arm7.spk 
ENV PLEX_PATH=/opt/plex/Application

RUN mkdir -p ${PLEX_PATH} /tmp/plex \
 && cd ${PLEX_PATH} \
 && wget --no-verbose -O /tmp/plex/plex.tar ${PLEX_LINK} \
 && tar -xvf /tmp/plex/plex.tar -C /tmp/plex \
 && tar -xvf /tmp/plex/package.tgz -C ${PLEX_PATH} \
 && rm -rf /tmp/plex

# Setup volumes
#  - /config holds the server settings
#  - /data is where media should be mounted
VOLUME ["/config", "/data"]

# Plex config environment vars
ENV HOME=/config

# Plex server port
EXPOSE 32400

# Add a line to the Plex start.sh script to remove any
# previous pid file found in the config dir. Plex wont
# start if this file is left over from a previous run.
RUN cp /opt/plex/Application/Resources/start.sh /opt/plex/Application/start.sh \
    && sed -i '2i rm -rf /config/Library/Application\\ Support/Plex\\ Media\\ Server/plexmediaserver.pid' ${PLEX_PATH}/start.sh

WORKDIR ${PLEX_PATH}
CMD ["bash", "start.sh"]
