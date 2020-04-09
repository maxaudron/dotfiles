#!/usr/bin/env sh

pastor () {
    curl --progress-bar -F "c=@$1" https://c-v.sh/
}

screenshot () {
	maim -s /dev/stdout | curl -s -F c=@- https://c-v.sh | xsel --clipboard
}
