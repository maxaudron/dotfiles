#!/usr/bin/env sh

pastor () {
    curl --progress-bar -F "c=@$1" https://c-v.sh/
}

screenshot () {
	scrot -s -e 'curl -s -F c=@${f} https://c-v.sh; rm $f'
}
