#!/bin/bash -e

cd /tmp

wget -c 'https://download.cdn.viber.com/desktop/Linux/viber.AppImage'
chmod +x viber.AppImage
env QT_QPA_PLATFORM=xcb ./viber.AppImage
