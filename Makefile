# Dotfiles bootstrapping
#  Install needed stuff

pyenv:
	cd $(HOME)
	curl https://pyenv.run | bash
	pyenv install 3.7.3 &
#	pyenv install 2.7.9 &
	while pgrep -u $UID -x pyenv >/dev/null; do sleep 5; done

spacevim:
	cd $(HOME)
	git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim
	curl -fLo $(HOME)/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

depfedora:
	sudo dnf install git stow gnupg2 zsh neovim @development-tools openssl-devel readline-devel

stow:
	mkdir -p $(HOME)/.gnupg
	cd $(PWD)
	stow src
