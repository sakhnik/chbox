#!/bin/bash

cmd=$(basename "${BASH_SOURCE[0]}")

if [[ "$(systemd-detect-virt)" == none ]]; then
    sudo machinectl shell sakhnik@arch /usr/bin/$cmd
else
    /usr/bin/$cmd
fi
