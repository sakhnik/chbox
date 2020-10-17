#!/bin/bash -e

url="https://update.code.visualstudio.com/latest/linux-x64/stable"
fname="code.tar.gz"

cd /tmp

if [[ ! -f "$fname" ]]; then
    wget -cO "$fname" "$url"
fi

if [[ ! -d VSCode-linux-x64 ]]; then
    tar -xvf "$fname"
fi

./VSCode-linux-x64/code "$@"
