#!/bin/bash -ex


pserver=/tmp/pulse-host/$USER
machine=$(basename ${BASH_SOURCE[0]})
machine=${machine%.sh}

if ! (machinectl -q shell $USER@$machine /bin/mount | grep -q $pserver); then
    # Allow Arch accessing pulseaudio
    machinectl -q shell $USER@$machine /bin/mkdir -p $pserver
    machinectl bind --read-only $machine /run/user/$UID/pulse $pserver
fi

# Allow local connections from the container to the host X11 server
xhost +local: || true

machinectl -q shell \
    --setenv=DISPLAY=$DISPLAY \
    --setenv=PULSE_SERVER=unix:$pserver/native \
    $USER@$machine "$@"
