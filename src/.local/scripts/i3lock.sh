#!/bin/bash
#
# i3lock custom script with added benefits
#
# Image rendering, converting, and pixelization are taken from https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen/. Credits to user `Babel2`.

# Get keyboard layout code
case "$(xset -q | grep LED | awk '{ print $10 }')" in
  "00000000") kb_lang="eng";; # English
  "00000002") kb_lang="eng";;
  "00000003") kb_lang="Eng";; # Caps

  "00001000") kb_lang="bg";; # Other
  "00001002") kb_lang="bg";;
  "00001003") kb_lang="Bg";; # Caps
esac

SCR_WIDTH=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)

# Set joke to be less than the screen width or to the default one
{
  joke=$(curl -s 'https://api.chucknorris.io/jokes/random' | jq -r '.value')
  joke_len=$((${#joke} * 12))

  if [[ "$SCR_WIDTH" -le "$joke_len" ]] || [[ "$joke" -eq "" ]]; then
    joke="Chuck Norris is watching you..."
    joke_len=$((${#joke} * 12))
  fi
}

IMAGE=/tmp/lockscreen.png
TEXT=/tmp/locktext.png
LANG=/tmp/lang.png

# Build lock screen3
scrot $IMAGE
convert $IMAGE -scale 10% -scale 1000% -fill black -colorize 25% $IMAGE
convert -size "$joke_len"x60 xc:#FAFAFA -font Times-Roman -pointsize 24 -fill xc:#3F464D -gravity center -annotate +0+0 "$joke" $TEXT
convert -size 35x30 xc:#3F464D -font Times-Roman -pointsize 12 -fill xc:#FAFAFA -gravity center -annotate +0+0 "$kb_lang" $LANG
convert $IMAGE $TEXT -gravity center -geometry +0+200 -composite $IMAGE
convert $IMAGE $LANG -gravity NorthEast -geometry +0+1 -composite $IMAGE

i3lock -i $IMAGE

