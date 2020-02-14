# Dotfiles bootstrapping
#  Install needed stuff

.PHONY: stow
stow: sync
	mkdir -p $(HOME)/.gnupg
	stow src

.PHONY: sync
sync:
	git pull
	git submodules init
	git submodules update

.PHONY: pyenv
pyenv:
	cd $(HOME)
	curl https://pyenv.run | bash
	pyenv install 3.7.3 &
#	pyenv install 2.7.9 &
	while pgrep -u $UID -x pyenv >/dev/null; do sleep 5; done

.PHONY: doom
doom:
	/usr/bin/git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
	~/.emacs.d/bin/doom install

.PHONY: depfedora
depfedora:
	sudo dnf install git stow gnupg2 zsh emacs @development-tools openssl-devel readline-devel

