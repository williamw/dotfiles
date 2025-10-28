#!/bin/bash

# Set zsh as the default shell
sudo chsh -s $(which zsh) $USER

# Tell zsh where to find its config
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

# Shortcut for editing .zshrc (optional):
ln -s ~/.config/zsh/.zshrc ~/.zshrc

exec zsh