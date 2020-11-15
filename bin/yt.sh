#!/bin/bash -x

runVlc()
{
    mapfile -t lines <<END
$1
END
    if [[ "${#lines[@]}" -gt 2 ]]; then
        vlc --video-title "${lines[0]}" --no-video-title-show "${lines[1]}" --input-slave "${lines[2]}"
    else
        vlc --video-title "${lines[0]}" --no-video-title-show "${lines[1]}"
    fi
}

fetchUrls()
{
    for i in 1 2 3; do
        urls="$(youtube-dl -e -g --format="bestvideo[height<=?1080]+bestaudio/best" "$1")"
        if [[ $? -eq 0 ]]; then
            runVlc "$urls"
            break
        fi
    done
}

if [[ $# -gt 0 ]]; then
    fetchUrls "$1"
else
    while read url; do
        fetchUrls "$url"
    done
fi
