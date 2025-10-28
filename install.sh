#!/bin/bash

sudo chown -R $USER:$USER ~/.config 2>/dev/null || true

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove conflicting files
rm -f ~/.zshrc ~/.zshenv

# Create symlinks
ln -sf "$DOTFILES/alacritty" "$HOME/.config/alacritty"
ln -sf "$DOTFILES/gh" "$HOME/.config/gh"
ln -sf "$DOTFILES/git" "$HOME/.config/git"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/zsh" "$HOME/.config/zsh"

# Bootstrap zsh
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

# Change shell
sudo chsh -s $(which zsh) $USER

# Nerd fonts
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/getnf -o /tmp/getnf
    chmod +x /tmp/getnf
    /tmp/getnf -i FiraCode
    rm /tmp/getnf
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew tap homebrew/cask-fonts
    brew install font-fira-code-nerd-font
fi

# nvim + lazyvim
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install neovim
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
fi

# uv

# nvm

# pnpm

# NOTE: Double-check how the pnpm install script works
#       We don't want it to override the pnpm config we
#       already have in .zshrc
# pnpm config set global-bin-dir "$HOME/.local/share/pnpm"