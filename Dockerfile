# Minecraft PE Server
FROM ubuntu:latest
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
	curl \
        libcurl4 \
        libssl1.0.0 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.1.2.zip -O bedrock-server.zip && \
  unzip bedrock-server.zip -d bedrock-server && \
  rm bedrock-server.zip

# Stage Files
COPY server.properties /server.properties.original
#COPY entrypoint.sh /entrypoint.sh

RUN mkdir /bedrock-server/config && \
    mv /bedrock-server/server.properties /bedrock-server/config && \
    mv /bedrock-server/permissions.json /bedrock-server/config && \
    mv /bedrock-server/whitelist.json /bedrock-server/config && \
    ln -s /bedrock-server/config/server.properties /bedrock-server/server.properties && \
    ln -s /bedrock-server/config/permissions.json /bedrock-server/permissions.json && \
    ln -s /bedrock-server/config/whitelist.json /bedrock-server/whitelist.json

# Setup User
#RUN useradd -d /bedrock-server -s /bin/bash --uid 1000 bedrock
#RUN chmod +x /entrypoint.sh
#RUN chown bedrock:bedrock /entrypoint.sh

# Setup container
EXPOSE 19132/udp

VOLUME /bedrock-server/worlds /bedrock-server/config

# Start Pocketmine
#CMD ["/data/start.sh", "--no-wizard"]
#ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /bedrock-server
ENV LD_LIBRARY_PATH=.
CMD ./bedrock_server
