#!/bin/bash
#
# i3lock custom script with added benefits
#
# Image rendering, converting, and pixelization are taken from https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen/. Credits to user `Babel2`.

IMAGE=/tmp/lockscreen.png

# Build lock screen3
scrot $IMAGE
convert $IMAGE -scale 10% -scale 1000% -fill black -colorize 25% $IMAGE

i3lock -i $IMAGE

