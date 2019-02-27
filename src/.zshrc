# Setting Editor
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG="en_US.UTF-8"

export PATH="/usr/sbin:$PATH"

# Setup .ssh config and keys
eval $(keychain --quiet --quick --ignore-missing ~/.ssh/*)

# PYENV
export PATH="/home/mmnanz/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)" 

source ~/.antigen/antigen.zsh
# source ~/.antigen/base16-ejected.sh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  # Guess what to install when running an unknown command.
  command-not-found
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  plugdev bobthecow/git-flow-completion
  pip
  git
  z
  gitignore
  cp
  extract
  paulirish/git-open
EOBUNDLES

# Load the theme.
antigen theme https://gitlab.com/ejectedspace/ejected-zsh-theme ejected

# Tell Antigen that you're done.
antigen apply

#------------------------------------------//// # System Information: #------------------------------------------//// 
#clear; echo -e "${yellow}";toilet -f future "Welcome, " $USER@$HOST; echo -ne "${yellow}Today is:\t\t${lightgray}" `date`; echo "" echo -e "${yellow}Kernel Information: \t${lightgray}" `uname -smr` echo -ne "${yellow}";uptime;echo "" echo -e "${yellow}"; cal -3

# Alias
alias cl="clear" 
alias v="nvim"
alias l="exa -al --group-directories-first --git --time-style=long-iso"
alias lt="exa -al --group-directories-first --git --time-style=long-iso -I .git --tree"

source ~/.zshalias

eval $(thefuck --alias)

transfer() {
    curl --progress-bar --upload-file "$1" https://sh.ejected.space/$(basename $1) | tee /dev/null;
  }
alias transfer=transfer

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
