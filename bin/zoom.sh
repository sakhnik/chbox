#!/bin/bash -e

cd /tmp

wget -c 'https://zoom.us/client/latest/zoom_x86_64.pkg.tar.xz'
tar -xvf zoom_x86_64.pkg.tar.xz

/tmp/opt/zoom/ZoomLauncher
