#!/usr/bin/env sh

if [ -f "$HOME/.local/bin/dit.sh" ]; then
    git() {
      if [ "$1" = "clone" ]; then
        command "$HOME/.local/bin/dit.sh" $*
      else
        command git $*
      fi
    }
    
    export DITSH_URL=gitlab.com
    export DITSH_BASE=$HOME/repo
    export DITSH_SSH=true
fi
