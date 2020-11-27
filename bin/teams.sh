#!/bin/bash -e

cd /tmp

if [[ ! -x ./usr/bin/teams ]]; then
    url="https://teams.microsoft.com/downloads/desktopurl?env=production&plat=linux&arch=x64&download=true&linuxArchiveType=rpm"
    wget -c "$url" -O teams.rpm
    rpmextract.sh ./teams.rpm
fi

./usr/bin/teams

