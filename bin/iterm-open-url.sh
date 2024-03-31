#!/bin/bash

set -e
set -u

[ -z "${1-}" ] && echo "Usage: $0 <URL>" && exit 1

url="$1"
[[ $url != http* ]] && url="https://$url"
base64_url=$(echo -n "$url" | base64)

printf "\ePtmux;\e\e\e]1337;OpenURL=:%s==\x07\e\\\\" $base64_url
