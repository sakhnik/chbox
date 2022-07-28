#!/bin/bash -e

cd /tmp
wget -c 'https://github.com/mifi/lossless-cut/releases/latest/download/LosslessCut-linux-x86_64.AppImage'
chmod +x ./LosslessCut-linux-x86_64.AppImage
./LosslessCut-linux-x86_64.AppImage
