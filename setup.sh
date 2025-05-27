#!/bin/bash
## clone powerlevel10k GitHub repo
# Define the target directory
TARGET_DIR="$HOME/dotfiles/powerlevel10k"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
  # Directory does not exist, so clone the repo
  git clone https://github.com/romkatv/powerlevel10k.git "$TARGET_DIR"
  echo "Powerlevel10k cloned into $TARGET_DIR"
else
  echo "Powerlevel10k already exists at $TARGET_DIR"
fi

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
ln -sf ~/dotfiles/p10k/.p10k.zsh ~/.p10k.zsh

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
# yazi terminal file manager
ln -sf ~/dotfiles/yazi ~/.config/
# zellij terminal multiplexer
ln -sf ~/dotfiles/zellij ~/.config/
# zed
ln -sf ~/dotfiles/zed ~/.config/
