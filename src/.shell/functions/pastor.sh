#!/usr/bin/env sh

pastor () {
    curl --progress-bar -F "c=@$1" https://c-v.sh/
}

screenshot () {
	scrot -s -e 'curl --upload-file $f https://c-v.sh; rm $f' | xclip -selection clipboard
}
