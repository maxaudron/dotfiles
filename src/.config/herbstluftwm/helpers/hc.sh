#!/usr/bin/env bash

hc() {
    herbstclient "$@"
}

function tryExecute {
    file="$1"

    echo "Trying to execute $file"
    cat "$file"
    if [ -f "$file" ] ; then
        source "$file"
    fi
}
