export VISUAL="emacsclient -c"
export EDITOR="$VISUAL"
export LANG="en_US.UTF-8"

export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.emacs.d/bin:$PATH:/opt/local/bin"
export GOPATH="$HOME/go/"
export SSH_AUTH_SOCK="/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"

export ZDOTDIR=$HOME/.zsh

eval "$(/opt/homebrew/bin/brew shellenv)"
