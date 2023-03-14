#!/usr/bin/env sh

pastor () {
    curl --progress-bar -F "c=@$1" https://c-v.sh/
}

screenshot () {
	grim -g "$(slurp)" - | curl -s -F c=@- https://c-v.sh | wl-copy
}
