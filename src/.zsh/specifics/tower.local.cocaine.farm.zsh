#!/bin/zsh

if [ ! -f "/tmp/audron-first-login" ]; then
  touch /tmp/audron-first-login
  ~/.local/bin/start-sway
fi

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
