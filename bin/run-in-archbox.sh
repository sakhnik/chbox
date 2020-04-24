#!/bin/bash

cmd=$(basename "${BASH_SOURCE[0]}")

if [[ "$(uname -n)" == archbox ]]; then
    /usr/bin/$cmd
else
    sudo machinectl shell sakhnik@arch /usr/bin/$cmd
fi
