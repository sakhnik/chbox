#!/bin/bash -e

#url="https://update.code.visualstudio.com/latest/linux-x64/stable"
url="https://update.code.visualstudio.com/latest/linux-x64/insider"
fname="code.tar.gz"

cd /tmp

if [[ ! -f "$fname" ]]; then
    wget -cO "$fname" "$url"
fi

if [[ ! -d VSCode-linux-x64 ]]; then
    tar -xvf "$fname"
fi

mkdir -p /tmp/vscode-cpptools
ln -sf /tmp/vscode-cpptools ~/.cache/

./VSCode-linux-x64/code-insiders --ozone-platform=wayland "$@"
