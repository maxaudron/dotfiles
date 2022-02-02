#!/bin/zsh

if [ ! -f "/tmp/audron-first-login" ]; then
  touch /tmp/audron-first-login
  ~/.local/bin/start-sway
fi

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
