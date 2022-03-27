#!/bin/zsh

export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.emacs.d/bin:$PATH:/opt/local/bin"

# Load host specific setup
[ -f "$HOME/.zsh/specifics/$(hostname -f).zsh" ] && source "$HOME/.zsh/specifics/$(hostname -f).zsh"

export KUBECONFIG="$HOME/.kube/config:$(for i in $(find "$HOME/.kube/configs/" -iname '*.yaml') ; do echo -n ":$i"; done | cut -c 2-)"

# Load Shell theme
source $HOME/.zsh/powerlevel.zsh

source $HOME/.zsh/lib/completion.zsh
source $HOME/.zsh/plugins/zdharma/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/plugins/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

source $HOME/.zsh/history.zsh
source $HOME/.zsh/keybinds.zsh

# Load shell aliases
source $HOME/.shell/alias.sh

# Load shell functions
source $HOME/.shell/functions.sh

# Set colors for ls directories and files
if which dircolors >/dev/null; then
  eval $(dircolors -b)
else
  export CLICOLOR=YES
fi

# Initialize zsh and bash autocomplete
fpath=($HOME/.zsh/plugins/zsh-users/zsh-completions/src $fpath)
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit

source "$HOME/.zsh/fzf.zsh"
