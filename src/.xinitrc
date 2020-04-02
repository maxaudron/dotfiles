#!/bin/sh
# $HOME/.screenlayout/default.sh
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

export QT_STYLE_OVERRIDE=GTK+

xset s off && xset -dpms
xset m 0 0

feh --bg-fill ~/.dotfiles/wallpaper/john-towner-blured.png

( ladish_control sload default && cadence-pulse2jack && scream-pulse -i virbr0 ) &

#exec herbstluftwm --locked

exec bspwm
