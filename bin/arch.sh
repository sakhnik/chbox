#!/bin/bash -ex


PSERVER=/tmp/pulse-host/$USER

if ! (machinectl -q shell $USER@arch /usr/bin/mount | grep -q $PSERVER); then
    # Allow Arch accessing pulseaudio
    machinectl -q shell $USER@arch /usr/bin/mkdir -p $PSERVER
    machinectl bind --read-only arch /run/user/$UID/pulse $PSERVER
fi

machinectl -q shell \
    --setenv=DISPLAY=$DISPLAY \
    --setenv=PULSE_SERVER=unix:$PSERVER/native \
    $USER@arch "$@"
