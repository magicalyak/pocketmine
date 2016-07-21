# Minecraft PE Server
FROM phusion/baseimage:0.9.19
MAINTAINER  Tom Gamull <tom.gamull@gmail.com>

# Secure and init
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

# Update, Install Prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
  apt-get install -y vim sudo wget perl gcc g++ make automake libtool autoconf m4 gcc-multilib && \
  apt-get install -y language-pack-en-base software-properties-common python-software-properties && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Stage Files
RUN mkdir -p /data
RUN cd /data
RUN wget https://bintray.com/pocketmine/PocketMine/download_file?file_path=PocketMine-MP_1.6dev-27_ef8227a0_API-2.0.0.phar -O /data/PocketMine-MP.phar 
COPY server.properties /data/server.properties
RUN wget https://raw.githubusercontent.com/PocketMine/PocketMine-MP/master/start.sh -O /data/start.sh
RUN chmod 755 /data/start.sh
RUN wget -O /data/PHP.tar.gz https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.6_x86-64_Linux.tar.gz
RUN tar -xf /data/PHP.tar.gz -C /data
ENV PHP_BINARY /data/bin/php7/bin/php

# Setup User
RUN useradd -d /data -s /bin/bash --uid 1000 minecraft
RUN chown -R minecraft:minecraft /data

# Setup container
EXPOSE 19132
WORKDIR /data

# Start Pocketmine
CMD ["/data/start.sh", "--no-wizard"]
