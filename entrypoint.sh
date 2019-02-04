#!/bin/dash

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
    wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.1.2.zip -O /data/bedrock-server.zip && unzip -n bedrock-server.zip && chown -R bedrock:bedrock /data
fi

    echo >&2 "Starting bedrock server...."
    set -e
    pipe=/run/minecraft/pipe.$$

    mkfifo $pipe
    exec 3<> $pipe
    rm $pipe

    <&3 3>&- LD_LIBRARY_PATH=. ./bedrock_server & pid=$!
    exec >&3 3<&-

    trap 'echo stop' INT TERM
    trap : CHLD

    while read -r line; do echo $line; done
    wait $pid
    exit $?

