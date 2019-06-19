FROM ubuntu:19.04

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common zsh git sudo stow gnupg2 unzip atool curl
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN apt-get install -y build-essential python3-pip
RUN cd $HOME; curl https://pyenv.run | bash
RUN cd $HOME; git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
RUN cd $HOME; pyenv install 3.7.7; pyenv virtualenv 3.7.7 neovim3
RUN cd $HOME; wget https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip; aunpack exa-linux-x86_64-0.8.0.zip; mkdir -p .local/bin; mv exa-linux-x86_64 .local/bin/exa
RUN cd $HOME; wget https://github.com/neovim/neovim/releases/download/v0.3.7/nvim-linux64.tar.gz; aunpack nvim-linux64.tar.gz; mv nvim-linux64/bin/* $HOME/.local/bin/; mv nvim-linux64/share $HOME/.local/
RUN cd $HOME; git clone https://github.com/liuchengxu/space-vim.git $HOME/.space-vim; curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; ln -s $HOME/.space-vim/init.vim $HOME/.config/nvim/init.vim
RUN cd $HOME; git clone https://gitlab.com/audron/dotfiles.git ~/dotfiles; cd dotfiles; stow src
RUN cd $HOME; gpg2 --recv ED5D5FB37EA77458

CMD ["/bin/zsh"]
