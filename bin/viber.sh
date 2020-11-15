#!/bin/bash -e

cd /tmp

wget -c 'https://download.cdn.viber.com/desktop/Linux/viber.AppImage'
chmod +x viber.AppImage
./viber.AppImage
