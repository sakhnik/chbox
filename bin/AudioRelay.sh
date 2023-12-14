#!/bin/bash -e

url=$(curl 'https://api.audiorelay.net/downloads' --compressed -H 'Accept: application/json' | jq -r ".linuxArchive.downloadUrl")
fname=$(basename "$url")

cd /tmp
wget -c "$url"
mkdir -p audiorelay
tar -C audiorelay -xvf "$fname"
./audiorelay/bin/AudioRelay
