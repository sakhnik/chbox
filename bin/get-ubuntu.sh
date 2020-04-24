#!/bin/bash

rootfs=/tmp/bionic

mount -o remount,suid,dev /tmp
debootstrap --variant=buildd --arch=amd64 bionic $rootfs http://archive.ubuntu.com/ubuntu

cat >$rootfs/test.sh <<END
sed -i '/main$/ s/$/ universe/' /etc/apt/sources.list
apt update
apt install -y curl vim checkinstall
END
chmod +x $rootfs/test.sh

systemd-nspawn -D $rootfs /test.sh
