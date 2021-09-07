#!/bin/sh

# Load Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Enable GKT themes in QT
export QT_STYLE_OVERRIDE=gtk2
export LIBVIRT_DEFAULT_URI="qemu:///system"

$HOME/.screenlayout/default.sh

# Set's the default cursor to a pointer
xsetroot -cursor_name left_ptr &
setxkbmap -option compose:rctrl
numlockx on

# Disables display power management system, display timeout
# and mouse acceleration
xset s off && xset -dpms
xset m 0 0

# Set Background
hsetroot -solid '#292929'

# $HOME/.local/bin/start-audio-setup.sh &

emacs --fg-daemon &

# redshift -l 50.110924:8.682127 -t 5600:2600 -b 1.0:0.75 &

# export LD_PRELOAD=/usr/local/lib/camlink/camlink.so

# Start bspwm
exec bspwm
