#!/usr/bin/env sh

# VIM
if command -v nvim 2>/dev/null 1>/dev/null; then
    alias v="nvim"
elif command -v vim 2>/dev/null 1>/dev/null; then
    alias v="vim"
else
    alias v="vi"
fi

# LS
if command -v exa 2>/dev/null 1>/dev/null; then
    alias l="exa -al --git --group-directories-first --time-style=long-iso"
    alias lg="exa -al --group-directories-first --git --time-style=long-iso"
    alias l.="exa -al --git --group-directories-first --time-style=long-iso -F -I '[!^.]*'"
    alias lt="exa -al --git --group-directories-first --time-style=long-iso -I .git --tree"
else
    alias l="ls -al --color=always --group-directories-first"
fi

# TERRAFORM
alias tf="terraform"
alias tfi="terraform init -upgrade"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"

# GIT
alias ga="git add"
alias gc="git commit -v"
alias glg="git glog"
alias gp="git push"

# SYSTEMCTL
alias sys="systemctl"
alias sysu="systemctl --user"

# MISC
alias cl="clear"
alias kc="kubectl"
alias nmpc="ncmpcpp"
alias ec="emacsclient -nc"
alias hi="ack --passthru"

alias kc-network-toolbox="kubectl run tmp-network-toolbox --rm -i --tty --image nicolaka/netshoot -- /bin/bash"

function podman() {
  if [[ "$1" == "shell" ]]; then
    shift 1
    command podman run -it --rm -v "$PWD:/work" $@
  else
    command podman "$@"
  fi
}

function rollout() {
	if [ "$1" = "test" ]; then
		shift 1
		ssh $@ "sudo su; exit"
	elif [ "$1" = "bump" ]; then
		shift 1
		awk -i inplace '/clara-standard/ && !/version=/ {print "clara-standard version=\"v3.1\""; next} {print $0}' "./Dependencies"
		git add ./Dependencies
		git commit -m "pin clara-standard to version v3.1"
		git push
	else
		INVENTORY=$1
		shift 1
		ansible-playbook -i $INVENTORY ~/repo/git.eu.clara.net/***REMOVED***/all-engulfing-test-setup/ansible/playbooks/sssd_upgrade.yaml --extra-vars "deprecation_warnings=False ansible_user=clarabot ansible_ssh_common_args='-J compliance'" $@

	fi
# ansible_ssh_common_args='-J compliance'
}

export DITSH_URL=gitlab.com
export DITSH_BASE=$HOME/repo
