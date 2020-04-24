#!/bin/bash

# Configure full natural scrolling in the touchpad
# XFCE4 stock setting only allows that in the GUI applications
# on the vertical axis.
xinput set-prop "Elan Touchpad" "Scroll X Out Scale" -0.1
xinput set-prop "Elan Touchpad" "Scroll Y Out Scale" -0.1

# Allow Arch accessing pulseaudio
sudo machinectl shell root@arch /usr/bin/mkdir -p /run/user/host/pulse
sudo machinectl bind arch /run/user/$UID/pulse /run/user/host/pulse

i3
