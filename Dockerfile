# Minecraft PE Server
FROM fusion/baseimage:0.9.19
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
RUN cd /data && curl -sL http://get.pocketmine.net/ | bash -s - -r -v development
COPY server.properties /tmp/server.properties
RUN wget https://raw.githubusercontent.com/PocketMine/PocketMine-MP/master/start.sh -O /data/start.sh
RUN chmod 755 /data/start.sh
RUN wget -O /data/PHP.tar.gz https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.6_x86-64_Linux.tar.gz
RUN tar -xf PHP.tar.gz /data

# Setup User
RUN useradd -d /data -s /bin/bash --uid 1000 minecraft

# Setup container
EXPOSE 19132
VOLUME /data
WORKDIR /data

# Start Pocketmine
CMD ["./start.sh", "--no-wizard"]
