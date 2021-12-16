#!/bin/bash -e

cd /tmp
wget -c 'https://github.com/mifi/lossless-cut/releases/latest/download/LosslessCut-linux.AppImage'
chmod +x ./LosslessCut-linux.AppImage
./LosslessCut-linux.AppImage
