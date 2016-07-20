# Minecraft PE Server
FROM ubuntu:14.04
MAINTAINER  Tom Gamull <tom.gamull@gmail.com>

# Setup APT
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update, Install Prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
  apt-get install -y vim sudo wget perl gcc g++ make automake libtool autoconf m4 gcc-multilib && \
  apt-get install -y language-pack-en-base software-properties-common python-software-properties curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Stage Files
RUN mkdir /data
RUN cd /data && curl -sL http://get.pocketmine.net/ | bash -s - -r -v development
#RUN mv /data/PocketMine-MP.phar /data/PocketMine-MP-orig.phar
#RUN wget http://jenkins.pocketmine.net/job/PocketMine-MP-Bleeding/48/artifact/PocketMine-MP_1.6dev-48_mcpe-0.12_f9d7e204_API-1.13.0.phar -O /data/PocketMine-MP.phar
COPY server.properties /tmp/server.properties
RUN wget https://raw.githubusercontent.com/PocketMine/PocketMine-MP/master/start.sh -O /data/start.sh
RUN chmod 755 /start.sh
RUN wget -O PHP.tar.gz https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.6_x86-64_Linux.tar.gz
RUN tar -xf PHP.tar.gz
ENV PHP_BINARY /bin/php7/bin/php

# Setup User
RUN useradd -d /data -s /bin/bash --uid 1000 minecraft

# Setup container
EXPOSE 19132
VOLUME /data
WORKDIR /data

# Start Pocketmine
CMD ["./start.sh", "--no-wizard"]
