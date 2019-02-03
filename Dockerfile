# Minecraft PE Server
FROM phusion/baseimage:0.11
MAINTAINER  Tom Gamull <tom.gamull@gmail.com>

# Secure and init
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

# Update, Install Prerequisites
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get -y update && \
  apt-get install -y \
	unzip \
	wget \
	libtool \
	autoconf && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Stage Files
COPY server.properties /server.properties.original
COPY entrypoint.sh /entrypoint.sh

# Setup User
RUN useradd -d /data -s /bin/bash --uid 1000 bedrock
RUN chmod +x /entrypoint.sh
RUN chown bedrock:bedrock /entrypoint.sh

# Setup container
EXPOSE 19132/udp

# Start Pocketmine
#CMD ["/data/start.sh", "--no-wizard"]
ENTRYPOINT ["/entrypoint.sh"]
