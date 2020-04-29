#!/bin/sh

# Load Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Enable GKT themes in QT
export QT_STYLE_OVERRIDE=gtk2
export LIBVIRT_DEFAULT_URI="qemu:///system"

$HOME/.screenlayout/default.sh

# Set's the default cursor to a pointer
xsetroot -cursor_name left_ptr &

# Disables display power management system, display timeout
# and mouse acceleration
xset s off && xset -dpms
xset m 0 0

# Set Background
feh --bg-fill ~/.dotfiles/wallpaper/john-towner-blured.png

# Start jack by loading a ladish studio, start the cadence pulseaudio bridge,
# and start the scream pulseaudio client to receive audio from the windows VM
( ladish_control sload default \
  && cadence-pulse2jack \
  && scream-pulse -i virbr0 ) &


# Start bspwm
exec bspwm
