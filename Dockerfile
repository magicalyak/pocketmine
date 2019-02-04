# Minecraft PE Server
FROM phusion/baseimage:0.11
MAINTAINER  Tom Gamull <tom.gamull@gmail.com>

# Secure and init
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

# Update, Install Prerequisites
RUN apt-get -y update && \
    apt-get install -y \
	unzip \
	curl \
        libcurl4 \
        libssl1.0.0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Stage Files
COPY server.properties /server.properties.original
COPY entrypoint.sh /entrypoint.sh
COPY run.sh /run.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /run.sh

# Setup container
EXPOSE 19132/udp

# Start Pocketmine
ENV LD_LIBRARY_PATH=.
ENTRYPOINT ["/bin/bash", "/run.sh"]
