#!/bin/bash

if [ ! -f /data/bedrock_server ]; then
	echo "Extracting server..."
	unzip -o /opt/bedrock_server.zip -d /data
	mkdir /data/config && \
    mv /data/server.properties /data/config && \
    mv /data/permissions.json /data/config && \
    mv /data/whitelist.json /data/config && \
    ln -s /data/config/server.properties /data/server.properties && \
    ln -s /data/config/permissions.json /data/permissions.json && \
    ln -s /data/config/whitelist.json /data/whitelist.json
fi

cd /data
LD_LIBRARY_PATH=. ./bedrock_server
