#!/usr/bin/env sh

podman () {
    if [ "$1" = "bash" ]; then
        shift
        command podman run -it --rm --network host -v "$PWD:/work" --entrypoint $*
    elif [ "$1" = "ip" ]; then
        shift
        podman inspect -f '{{ .NetworkSettings.IPAddress }}' $*
    else
        command podman $*
    fi
}
