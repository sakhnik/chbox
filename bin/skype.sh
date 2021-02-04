#!/bin/bash -e

cd /tmp

if [[ ! -x ./usr/bin/skypeforlinux ]]; then
    curl -LO https://go.skype.com/skypeforlinux-64.rpm
    rpmextract.sh ./skypeforlinux-64.rpm
fi

./usr/bin/skypeforlinux
