#!/bin/bash -x

runVlc()
{
    urls="$1"
    if [[ $(echo "$urls" | wc -l) -gt 1 ]]; then
        vurl="$(echo "$urls" | head -1)"
        aurl="$(echo "$urls" | head -2 | tail -1)"
        vlc "$vurl" --input-slave "$aurl"
    else
        vlc "$urls"
    fi
}

fetchUrls()
{
    for i in 1 2 3; do
        urls="$(youtube-dl --format="bestvideo[height<=?1080]+bestaudio/best" -g "$1")"
        if [[ $? -eq 0 ]]; then
            runVlc "$urls"
            break
        fi
    done
}

while read url; do
    fetchUrls "$url"
done
