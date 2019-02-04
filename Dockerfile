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
	curl \
        libcurl4 \
        libssl1.0.0 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Install of bedrock
#RUN  wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.1.2.zip -O bedrock-server.zip && \
RUN  url=$(curl -s https://minecraft.net/en-us/download/server/bedrock/ | grep bin-linux | sed "s/.*href=['\"]\([^'\"]*\)['\"].*/\1/g"); curl $url --output bedrock-server.zip && \
     unzip bedrock-server.zip -d data && \
     rm bedrock-server.zip

# Stage Files
COPY server.properties /server.properties.original

RUN mkdir -p /data/config && \
    mv /data/server.properties /data/config && \
    mv /data/permissions.json /data/config && \
    mv /data/whitelist.json /data/config && \
    ln -s /data/config/server.properties /data/server.properties && \
    ln -s /data/config/permissions.json /data/permissions.json && \
    ln -s /data/config/whitelist.json /data/whitelist.json

# Setup User
#RUN useradd -d /bedrock-server -s /bin/bash --uid 1000 bedrock
#RUN chmod +x /entrypoint.sh
#RUN chown bedrock:bedrock /entrypoint.sh

# Setup container
EXPOSE 19132/udp

# Start Pocketmine
#CMD ["/data/start.sh", "--no-wizard"]
#ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /data
ENV LD_LIBRARY_PATH=.
CMD ./bedrock_server
