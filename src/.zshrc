# Setting Editor
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG="en_US.UTF-8"

export PATH="/usr/sbin:$HOME/go/bin:/nix/var/nix/profiles/per-user/mmnanz/profile/bin/:$HOME/.linuxbrew/bin:$PATH"
export GOPATH="$HOME/go/"

# PYENV
pyenv() {
  eval "$(command pyenv init -)"
  eval "$(command pyenv virtualenv-init -)"
  pyenv "$@"
}
export PATH="/home/mmnanz/.pyenv/bin:$PATH"

source ~/.antigen/antigen.zsh
# source ~/.antigen/base16-ejected.sh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
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

# Alias
alias cl="clear"
alias v="nvim"
alias l="exa -al --group-directories-first --git --time-style=long-iso"
alias l.="exa -al --group-directories-first --git --time-style=long-iso -F -I '[!^.]*'"
alias lt="exa -al --group-directories-first --git --time-style=long-iso -I .git --tree"
alias lab="lab-wrap"
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan -var-file=$HOME/.terraform.d/vsphere_auth.tfvars"
alias tfa="terraform apply -var-file=$HOME/.terraform.d/vsphere_auth.tfvars"
alias tfd="terraform destroy -var-file=$HOME/.terraform.d/vsphere_auth.tfvars"
alias gpg="gpg2"
#alias ssh="-t -- /bin/sh -c 'tmux has-session && exec tmux attach || exec tmux'"
alias hie="hie-wrapper"
alias kc="kubectl"

#export PAGER=/usr/bin/vimpager
#alias less=$PAGER
#alias zless=$PAGER

eval "$(lab completion zsh)"

transfer(){ 
  if [ $# -eq 0 ];then 
    echo "No arguments specified.
          Usage:
          transfer <file|directory>
          ... | transfer <file_name>" >&2;
    return 1;
  fi;
  if tty -s;then 
    file="$1";
    file_name=$(basename "$file");
    if [ ! -e "$file" ];then 
      echo "$file: No such file or directory">&2;
      return 1;
    fi;
    if [ -d "$file" ];then 
      file_name="$file_name.zip" ,; (cd "$file"&&zip -r -q - .) | curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null,;
    else
      cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;
    fi;
  else 
    file_name=$1;
    curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;
  fi;
}

alias transfer=transfer

function git() {
  if [[ "$1" == "clone" ]]; then
    command $HOME/.local/bin/dit.sh "$@"
  else
    command git "$@"
  fi
}

export DITSH_URL=gitlab.com
export DITSH_BASE=$HOME/repo
export DITSH_SSH=true

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

