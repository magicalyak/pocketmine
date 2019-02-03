#!/bin/bash

mkdir -p /data/worlds
cd /bedrock

if ! [ -e server.properties ]; then
    echo >&2 "[WARN] server.properties is not found in $(pwd). Copying from the original assets."
    cp -p ../server.properties.original server.properties
    chown bedrock:bedrock server.properties
fi

echo "[INFO] Updating to the latest API release."
#Get ZIP File (note the hardcode URL)
if ! [ -f bedrock-server.zip ]; then
    echo >&2 "Downloading bedrock server files"
    wget $BEDROCK_DOWNLOAD_ZIP -O /data/bedrock-server.zip && unzip -n bedrock-server.zip && chown -R bedrock:bedrock /data
fi

if [ -f "bedrock_server" ]; then
    echo >&2 "Starting bedrock server...."
    LD_LIBRARY_PATH=. ./bedrock_server
else
    echo >&2 "Server software not downloaded or unpacked!"
fi

