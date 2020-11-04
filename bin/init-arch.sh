#!/bin/bash -e

sudo machinectl start arch

sleep 1
# Allow Arch accessing pulseaudio
sudo machinectl shell root@arch /usr/bin/mkdir -p /run/user/host/pulse
sudo machinectl bind arch /run/user/$UID/pulse /run/user/host/pulse

sudo machinectl login arch
