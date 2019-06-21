source ~/.antigen/antigen.zsh

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
#antigen theme https://gitlab.com/ejectedspace/ejected-zsh-theme ejected
antigen theme romkatv/powerlevel10k
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh dir vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator host)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='236'
POWERLEVEL9K_DIR_HOME_BACKGROUND='236'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='236'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='002'
POWERLEVEL9K_DIR_HOME_FOREGROUND='002'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='002'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='002'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='235'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='002'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='235'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='002'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='235'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='002'
POWERLEVEL9K_HOST_LOCAL_BACKGROUND='236'
POWERLEVEL9K_HOST_LOCAL_FOREGROUND='002'
POWERLEVEL9K_HOST_REMOTE_BACKGROUND='003'
POWERLEVEL9K_HOST_REMOTE_FOREGROUND='232'
POWERLEVEL9K_STATUS_OK_BACKGROUND='235'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='001'

#Icon config
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=$'%K{white}%k'
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=$' %F{002}\uf101%f '

POWERLEVEL9K_VCS_GIT_ICON=$'\uf1d2 '
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=$'\uf113 '
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=$'\uf296 '
POWERLEVEL9K_VCS_BRANCH_ICON=$' '
POWERLEVEL9K_VCS_STAGED_ICON=$'\uf633'
POWERLEVEL9K_VCS_UNSTAGED_ICON=$'\uf62f'
POWERLEVEL9K_VCS_UNTRACKED_ICON=$'\uf659'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$'\uf175'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$'\uf176'

POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''
#POWERLEVEL9K_STATUS_OK_ICON='\UF2B0'
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=' '
#POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\UE0BA'
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=' '


# Tell Antigen that you're done.
antigen apply

###############################################################################
# Settings
export VISUAL=nvim
export EDITOR="$VISUAL"
export LANG="en_US.UTF-8"
export PATH="/usr/sbin:$HOME/go/bin:/nix/var/nix/profiles/per-user/$USER/profile/bin/:$HOME/.linuxbrew/bin:$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go/"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

setopt share_history # Share history between multiple shells

###############################################################################
# PYENV - Load only if pyenv is installed
if [ -d $HOME/.pyenv ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
fi


###############################################################################
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
alias hie="hie-wrapper"
alias kc="kubectl"

###############################################################################
# Functions
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

if [[ -f $HOME/.local/bin/dit.sh ]]; then
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
fi

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


