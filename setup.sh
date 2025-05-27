#!/bin/bash
# setup symlinks

## home folder
# bash
ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/dotfiles/bash/.bash_profile ~/.bash_profile
# zsh
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/.zshenv ~/.zshenv
# vim
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
# powerlevel10k
ln -sf ~/dotfiles/power10k/.p10k.zsh ~/.p10k.zsh

## .config folder
# kitty terminal emulator
ln -sf ~/dotfiles/kitty ~/.config/
# nvim
ln -sf ~/dotfiles/nvim ~/.config/
# joshuto (not using)
ln -sf ~/dotfiles/joshuto ~/.config/
# RStudio
ln -sf ~/dotfiles/rstudio ~/.config/
# Xournalpp note taking app
ln -sf ~/dotfiles/xournalpp ~/.config/
