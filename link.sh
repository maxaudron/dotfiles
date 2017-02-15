#!/bin/bash

dotdir=~/dotfiles/

ln -s $dotdir.zshrc ~/.zshrc
ln -s $dotdir.config/i3 ~/.config/i3
ln -s $dotdir.config/polybar ~/.config/polybar
ln -s $dotdir.config/vim ~/.config/vim
ln -s $dotdir.config/ranger ~/.config/ranger
ln -s $dotdir.config/rofi ~/.config/rofi
ln -s $dotdir.Xresources ~/.Xresources
ln -s $dotdir.Xresources.d ~/.Xresources.d

echo "Done linking configs"
