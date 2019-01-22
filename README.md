# dotfiles
---
### Install
```
git clone --branch work --single-branch https://gitlab.com/audron/dotfiles ~/.dotfiles
cd ~/.dotfiles
stow src
```


### NVIM
there need to be a python 3 environment set in init.vim `let g:python3_host_prog` that has the neovim package installed.

```
pyenv install 3.6.6 # or whatever latest python3 version you want
pyenv virtualenv 3.6.6 neovim3
```

then run `:PlugClean` and then `:PlugInstall` to have a fresh install of all plugins

You should also use a nerd font to have all icons properly displayed

refer to [completor.vim](https://github.com/maralla/completor.vim) and [ale](https://github.com/w0rp/ale) for completion plugins

Install ctags to get a tagbar
`sudo apt install exuberant-ctags`
