#!/bin/bash

declare -A last

for sel in primary secondary; do
    last["$sel"]="$(xclip -o -selection ${sel})"
done

while true; do
    for sel in primary secondary; do
        url="$(xclip -o -selection ${sel})"
        if [[ "$url" != "${last["$sel"]}" && "$url" =~ https://www.youtube.com/watch.* ]]; then
            yt.sh "$url"
            last["$sel"]="$url"
        fi
    done
    sleep 1
done
