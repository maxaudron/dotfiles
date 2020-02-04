#!/usr/bin/env sh

pastor () {
    curl --progress-bar -F "c=@$1" https://p.cocaine.farm/
}
