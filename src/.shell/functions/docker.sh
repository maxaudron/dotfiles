#!/usr/bin/env sh

docker () {
    if [ "$1" = "bash" ]; then
        shift
        command docker run -it --rm --network host -v "$PWD:/work" --entrypoint $*
    elif [ "$1" = "ip" ]; then
        shift
        docker inspect -f '{{ .NetworkSettings.IPAddress }}' $*
    else
        command docker $*
    fi
}
