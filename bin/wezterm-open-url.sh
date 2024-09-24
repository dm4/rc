#!/bin/bash

set -e
set -u

[ -z "${1-}" ] && echo "Usage: $0 <URL>" && exit 1

url="$1"
[[ $url != http* ]] && url="https://$url"
base64_url=$(echo -n "$url" | base64)

if [[ -z "${TMUX-}" ]] ; then
    printf "\e]1337;SetUserVar=open-url=%s\x07" "$base64_url"
else
    # <https://github.com/tmux/tmux/wiki/FAQ#what-is-the-passthrough-escape-sequence-and-how-do-i-use-it>
    # Note that you ALSO need to add "set -g allow-passthrough on" to your tmux.conf
    printf "\ePtmux;\e\e]1337;SetUserVar=open-url=%s\x07\e\\" "$base64_url"
fi
