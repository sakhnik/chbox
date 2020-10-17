#!/bin/bash -ex

while read url; do
    mpv "$url"
done

#urls="$(youtube-dl --format="bestvideo[height<=?1080]+bestaudio/best" -g "$1")"
#if [[ $(echo "$urls" | wc -l) -gt 1 ]]; then
#    vurl="$(echo "$urls" | head -1)"
#    aurl="$(echo "$urls" | head -2 | tail -1)"
#    vlc "$vurl" --input-slave "$aurl"
#else
#    vlc "$urls"
#fi
