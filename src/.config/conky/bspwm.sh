#!/usr/bin/env bash

workspaces() {
    for i in {2..11}; do
        SPACE=$(bspc wm --get-status | cut -d ":" -f $i)
        if [ "${SPACE:0:1}" == 'O' ] || [ "${SPACE:0:1}" == "F" ]; then
            echo "${SPACE:1}¤"
        elif [ "${SPACE:0:1}" == 'o' ]; then
            echo "${SPACE:1}-"
        elif [ "${SPACE:0:1}" == 'u' ]; then
            echo "${SPACE:1}═"
        elif [ "${SPACE:0:1}" == 'U' ]; then
            echo "${SPACE:1}*"
        else
            echo "${SPACE:1} "
        fi
    done
}

workspaces
