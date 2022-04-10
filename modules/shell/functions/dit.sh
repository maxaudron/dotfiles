#!/usr/bin/env sh

if [ -n "$(which dit)" ]; then
    export DITSH_BASE="$HOME/repo"

    git() {
      if [ "$1" = "clone" ]; then
        command dit $*
      else
        command git $*
      fi
    }
fi
