# Minecraft Bedrock Server
# Using Debian slim for minimal size with glibc compatibility
# Using official Debian image from Docker Hub
FROM --platform=linux/amd64 debian:12-slim

LABEL maintainer="Tom Gamull <tom.gamull@gmail.com>"
LABEL build_date="2025-09-19"

ARG BDS_Version=latest
ENV VERSION=$BDS_Version

# Install prerequisites and create user
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    unzip \
    curl \
    wget \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /data && \
    groupadd -g 1000 minecraft && \
    useradd -u 1000 -g 1000 -r -d /data minecraft

# Stage Files - Download Bedrock Server
# Using wget with retry logic for better reliability
RUN if [ "$VERSION" = "latest" ] ; then \
        echo "Downloading latest Bedrock server (v1.21.51.02)..." && \
        wget --tries=3 --timeout=30 -O bedrock-server.zip \
            "https://minecraft.azureedge.net/bin-linux/bedrock-server-1.21.51.02.zip" 2>/dev/null || \
        wget --tries=3 --timeout=30 -O bedrock-server.zip \
            "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-1.21.51.02.zip" 2>/dev/null || \
        (echo "Failed to download from primary sources, using HTTP fallback..." && \
         wget --tries=3 --timeout=30 -O bedrock-server.zip \
            "http://minecraft.azureedge.net/bin-linux/bedrock-server-1.21.51.02.zip") ; \
    else \
        echo "Using specified VERSION: $VERSION" && \
        wget --tries=3 --timeout=30 -O bedrock-server.zip \
            "https://minecraft.azureedge.net/bin-linux/bedrock-server-${VERSION}.zip" ; \
    fi && \
    echo "Download complete, verifying file..." && \
    ls -lh bedrock-server.zip

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
