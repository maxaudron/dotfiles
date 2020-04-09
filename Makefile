# Dotfiles bootstrapping
#  Install needed stuff

.PHONY: stow
stow: sync
	mkdir -p $(HOME)/.gnupg $(HOME)/.config $(HOME)/.local/bin
	stow src

.PHONY: sync
sync:
	git pull
	git submodules init
	git submodules update

.PHONY: doom
doom:
	/usr/bin/git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
	~/.emacs.d/bin/doom install

.PHONY: depfedora
depfedora:
	sudo dnf install git stow gnupg2 zsh emacs @development-tools openssl-devel readline-devel

