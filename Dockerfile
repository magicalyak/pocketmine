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
        wget \
        libxml2-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /data && \
    groupadd -g 1000 minecraft && \
    useradd -u 1000 -g 1000 -r minecraft

# Stage Files
RUN wget -O /opt/bedrock_server.zip $(wget -q -O - https://minecraft.net/en-us/download/server/bedrock/ | xmllint --html --xpath '/html/body/main/div/div/div[2]/div/div[1]/div[2]/div[2]/div/a' - 2>/dev/null | grep -zoP '<a[^<][^<]*href="\K[^"]+')
ADD start.sh /opt/start.sh
RUN chown -R minecraft:minecraft /data && chmod +x /opt/start.sh

USER minecraft:minecraft
RUN cd /data

VOLUME /data
WORKDIR /data

# Setup container
EXPOSE 19132/udp

# Start Pocketmine
CMD ["/opt/start.sh"]
