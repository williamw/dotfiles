#!/bin/bash

# PLACEHOLDER
# This file will be used to install tools

# nvim + lazyvim
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install neovim
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y neovim
fi

# uv

# nvm

# pnpm

# NOTE: Double-check how the pnpm install script works
#       We don't want it to override the pnpm config we
#       already have in .zshrc
# pnpm config set global-bin-dir "$HOME/.local/share/pnpm"