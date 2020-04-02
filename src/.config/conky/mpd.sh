#!/usr/bin/env bash

#!/bin/zsh
 
mpd() {
    for i in $(seq 0 44); do
        a=$(cat /home/elen/nowplaying | cut -d "~" -f 1 | tr -d '[:punct:]')
        c=$(cat /home/elen/nowplaying | cut -d "~" -f 2 | tr -d '[:punct:]')
        printf -v pad %45s
        if [[ "$a" == "paused  045   000000 0" ]] || [[ "$a" == "volume100   repeat off   random off   single off   consume off" ]]; then
            a="STOPPED"$pad
            echo ${a:$i:1}
        else
            a=$a:u$pad
            b=$pad
            c=$c:u$pad
            echo ${a:$i:1}${b:$i:1}${c:$i:1}
        fi
    done
}
mp
