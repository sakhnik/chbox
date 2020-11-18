#!/bin/bash

declare -A last
seen=""

add_seen()
{
    seen="$(echo "${seen}" | tail -${#last[@]})
$1"
}

was_seen()
{
    echo "$seen" | grep -qF "$1"
}

for sel in clipboard primary; do
    url="$(xclip -o -selection ${sel} 2>/dev/null)"
    if [[ $? -eq 0 ]]; then
        last["$sel"]="$url"
    fi
done

while true; do
    for sel in ${!last[@]}; do
        url="$(xclip -o -selection ${sel})"
        if [[ "$url" != "${last["$sel"]}" && "$url" =~ https://www.youtube.com/watch.* ]]; then
            if ! was_seen "$url"; then
                yt.sh "$url"
                last["$sel"]="$url"
                add_seen "$url"
            fi
        fi
    done
    sleep 1
done
