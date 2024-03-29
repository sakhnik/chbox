#!/bin/zsh -e

mkdir -p /tmp/gopass
cd /tmp/gopass

if [[ ! -x gopass ]]; then
    assets_url=$(curl -Ls 'https://github.com/gopasspw/gopass/releases/latest' | \
        grep -Po -m 1 'https://.+?expanded_assets/[^"]+')
    url=$(curl -Ls "$assets_url" | \
        grep -Po -m 1 '(?<=href=").+?linux-amd64.tar.gz')
    wget -qc "http://github.com$url"

    fname=$(basename $url)
    tar -xf $fname

    # Copy to a known location that may work together with my dotfiles.
    # Alternatively, could just source zsh.completion into current shell.
    cp zsh.completion $ZPLUG_REPOS/zsh-users/zsh-completions/src/_gopass
fi

./gopass "$@"
