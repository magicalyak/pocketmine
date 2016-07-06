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
COPY PocketMine-MP.phar /PocketMine-MP.phar
COPY server.properties /tmp/server.properties
RUN wget https://raw.githubusercontent.com/PocketMine/PocketMine-MP/master/start.sh
RUN chmod 755 /start.sh
RUN wget -O PHP.tar.gz https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.6_x86-64_Linux.tar.gz
RUN tar -xf PHP.tar.gz

# Setup User
RUN useradd -d /data -s /bin/bash --uid 1000 minecraft

# Setup container
EXPOSE 19132
VOLUME ["/data"]
WORKDIR /data

# Start Pocketmine
CMD ["/start.sh"]
