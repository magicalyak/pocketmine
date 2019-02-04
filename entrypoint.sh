#!/bin/bash

mkdir -p /data/worlds
cd /data

if ! [ -e server.properties ]; then
    echo >&2 "[WARN] server.properties is not found in $(pwd). Copying from the original assets."
    cp -p ../server.properties.original server.properties
    chown bedrock:bedrock server.properties
fi

echo "[INFO] Updating to the latest API release."

#Get ZIP File (note the hardcode URL)
if ! [ -f bedrock-server.zip ]; then
    echo >&2 "Downloading bedrock server files"
    url=$(curl -s https://minecraft.net/en-us/download/server/bedrock/ | grep bin-linux | sed "s/.*href=['\"]\([^'\"]*\)['\"].*/\1/g"); curl $url --output bedrock-server.zip
    unzip -n bedrock-server.zip
fi

#LD_LIBRARY_PATH=. ./bedrock_server
bash
