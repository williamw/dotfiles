#!/bin/bash

sudo chown -R $USER:$USER ~/.config 2>/dev/null || true

# oh-my-zsh (must run first)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Bootstrap
rm -f ~/.zshrc ~/.zshenv

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$DOTFILES/alacritty" "$HOME/.config/alacritty"
ln -sf "$DOTFILES/gh" "$HOME/.config/gh"
ln -sf "$DOTFILES/git" "$HOME/.config/git"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/zsh" "$HOME/.config/zsh"
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

sudo chsh -s $(which zsh) $USER

# gh cli
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
        && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt-get update \
        && sudo apt-get install -y gh
    fi
fi

# nvim + lazyvim
if ! command -v nvim &> /dev/null; then
    echo "Installing neovim..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install neovim
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update
        sudo apt-get install -y neovim
    fi
fi

# uv
if [ ! -f "$HOME/.local/bin/uv" ]; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# nvm
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    
    # Get latest version and install
    NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

    # Install node/npm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 22
    nvm alias default 22
fi

# Claude Code
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

# Nerd font
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ ! -d "$HOME/.local/share/fonts/FiraCode" ]; then
        echo "Installing FiraCode Nerd Font..."
        curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/getnf -o /tmp/getnf
        chmod +x /tmp/getnf
        /tmp/getnf -i FiraCode
        rm /tmp/getnf
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! ls ~/Library/Fonts/*FiraCode*Nerd* &> /dev/null && ! ls /Library/Fonts/*FiraCode*Nerd* &> /dev/null; then
        echo "Installing FiraCode Nerd Font..."
        brew tap homebrew/cask-fonts
        brew install font-fira-code-nerd-font
    fi
fi

# pnpm

# NOTE: Double-check how the pnpm install script works
#       We don't want it to override the pnpm config we
#       already have in .zshrc
# pnpm config set global-bin-dir "$HOME/.local/share/pnpm"