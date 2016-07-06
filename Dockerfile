# Minecraft PE Server
FROM ubuntu:trusty
MAINTAINER  Tom Gamull <tom.gamull@gmail.com>

# Setup APT
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update, Install Prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
  apt-get install -y vim sudo wget perl gcc g++ make automake libtool autoconf m4 gcc-multilib && \
  apt-get install -y language-pack-en-base software-properties-common python-software-properties && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Stage Files
RUN wget -q -O PocketMine-MP.phar - https://bintray.com/pocketmine/PocketMine/download_file?file_path=PocketMine-MP_1.6dev-27_ef8227a0_API-2.0.0.phar
RUN wget -q -O PHP_7.0.6_x86-64_Linux.tar.gz - https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.6_x86-64_Linux.tar.gz && tar -xvf PHP_7.0.6_x86-64_Linux.tar.gz
COPY server.properties /tmp/server.properties
RUN wget -q -O start.sh - https://raw.githubusercontent.com/PocketMine/PocketMine-MP/master/start.sh
# COPY start.sh /start.sh
RUN chmod 755 /start.sh

# Setup User
RUN useradd -d /data -s /bin/bash --uid 1000 minecraft

# Setup container
EXPOSE 19132
VOLUME ["/data"]
WORKDIR /data

# Start Pocketmine
CMD ["/start.sh"]
