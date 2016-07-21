#!/bin/bash

mkdir -p /data
cd /data

if ! [ -e server.properties ]; then
    echo >&2 "[WARN] server.properties is not found in $(pwd). Copying from the original assets."
    cp -p ../server.properties.original server.properties
    chown minecraft:minecraft server.properties
fi

echo "[INFO] Updating to the latest 1.6dev and 2.0.0 API release."
#Get PHAR File (note the hardcode URL)
if ! [ -e PocketMine-MP.phar ]; then
    rm -f PocketMine-MP.phar
fi

wget https://bintray.com/pocketmine/PocketMine/download_file?file_path=PocketMine-MP_1.6dev-27_ef8227a0_API-2.0.0.phar -O /data/PocketMine-MP.phar
wget https://raw.githubusercontent.com/PocketMine/PocketMine-MP/master/start.sh -O /data/start.sh
chmod 755 /data/start.sh
wget -O /data/PHP.tar.gz https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.6_x86-64_Linux.tar.gz
tar -xf /data/PHP.tar.gz -C /data

chown -R minecraft:minecraft /data

/data/start.sh --no-wizard
