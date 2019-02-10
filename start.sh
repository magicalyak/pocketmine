#!/bin/bash

if [ ! -f /data/bedrock_server ]; then
	echo "Extracting server..."
	unzip -o /opt/bedrock_server.zip -d /data
fi

cd /data
LD_LIBRARY_PATH=. ./bedrock_server
