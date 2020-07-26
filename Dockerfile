# Minecraft PE Server
FROM phusion/baseimage:bionic-1.0.0

LABEL maintainer="Tom Gamull <tom.gamull@gmail.com>"
LABEL build_date="2020-07-26"

ARG BDS_Version=latest
ENV VERSION=$BDS_Version

# Secure and init
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
#CMD ["/sbin/my_init"]

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
RUN  if [ "$VERSION" = "latest" ] ; then \
        LATEST_VERSION=$( \
            curl -v --silent  https://www.minecraft.net/en-us/download/server/bedrock/ 2>&1 | \
            grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' | \
            sed 's#.*/bedrock-server-##' | sed 's/.zip//') && \
        export VERSION=$LATEST_VERSION && \
        echo "Setting VERSION to $LATEST_VERSION" ; \
    else echo "Using VERSION of $VERSION"; \
    fi && \
    curl https://minecraft.azureedge.net/bin-linux/bedrock-server-${VERSION}.zip --output bedrock-server.zip && \
    unzip bedrock-server.zip -d bedrock-server && \
    rm bedrock-server.zip
#RUN wget -O /opt/bedrock_server.zip $(wget -q -O - https://minecraft.net/en-us/download/server/bedrock/ | xmllint --html --xpath '/html/body/main/div/div/div[2]/div/div[1]/div[2]/div[2]/div/a' - 2>/dev/null | grep -zoP '<a[^<][^<]*href="\K[^"]+')
RUN mkdir /data/config && \
    mv /data/server.properties /data/config && \
    mv /data/permissions.json /data/config && \
    mv /data/whitelist.json /data/config && \
    ln -s /data/config/server.properties /data/server.properties && \
    ln -s /data/config/permissions.json /data/permissions.json && \
    ln -s /data/config/whitelist.json /data/whitelist.json

ADD start.sh /opt/start.sh
RUN chown -R minecraft:minecraft /data && chmod +x /opt/start.sh

USER minecraft:minecraft
RUN cd /data

VOLUME /data/worlds /data/config
WORKDIR /data

# Setup container
EXPOSE 19132/udp

# Start Pocketmine
CMD ["/opt/start.sh"]
