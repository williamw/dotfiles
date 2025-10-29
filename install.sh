#!/bin/bash

sudo chown -R $USER:$USER ~/.config 2>/dev/null || true

# oh-my-zsh (must run first)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "☁️Downloading oh-my-zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✓ oh-my-zsh is already installed."
fi

# Bootstrap
echo "🔧Configuring shell..."
rm -f ~/.zshrc ~/.zshenv

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Only create symlinks if dotfiles are not already in ~/.config
# (e.g., when cloned to ~/.config/coderv2/dotfiles in RDE)
if [ "$DOTFILES" != "$HOME/.config" ]; then
    ln -sf "$DOTFILES/alacritty" "$HOME/.config/alacritty"
    ln -sf "$DOTFILES/gh" "$HOME/.config/gh"
    ln -sf "$DOTFILES/git" "$HOME/.config/git"
    ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
    ln -sf "$DOTFILES/zsh" "$HOME/.config/zsh"
fi

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

sudo chsh -s $(which zsh) $USER

# Claude Code
if ! command -v claude &> /dev/null; then
    echo "☁️Downloading Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "✓ Claude Code is already installed."
fi

# Claude Code config
echo "🔧Configuring Claude Code..."
rm -f ~/.claude/settings.json
ln -sf "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"

# uv
if [ ! -f "$HOME/.local/bin/uv" ]; then
    echo "☁️Downloading uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "✓ uv is already installed."
fi

# nvm
if [ ! -d "$HOME/.nvm" ]; then
    echo "☁️Downloading nvm..."
    
    # Get latest version and install
    NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

    # Install node/npm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 22
    nvm alias default 22
else
    echo "✓ nvm is already installed."
fi

# Nerd font
FONT_DIR=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DIR="$HOME/Library/Fonts/FiraCode"
else
    FONT_DIR="$HOME/.local/share/fonts/FiraCode"
fi

if [ ! -d "$FONT_DIR" ]; then
    echo "☁️Downloading FiraCode Nerd Font..."
    curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/getnf -o /tmp/getnf
    chmod +x /tmp/getnf
    /tmp/getnf -i FiraCode
    rm /tmp/getnf
else
    echo "✓ FiraCode font is already installed."
fi

# pnpm
if ! command -v pnpm &> /dev/null; then
    echo "☁️Downloading pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    echo "✓ pnpm is already installed."
fi

# Homebrew (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        echo "☁️Downloading Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "✓ Homebrew is already installed."
    fi
fi

# gh cli
if ! command -v gh &> /dev/null; then
    echo "☁️Downloading GitHub CLI..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
        && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt-get update \
        && sudo apt-get install -y gh
    fi
else
    echo "✓ GitHub CLI is already installed."
fi

# nvim + lazyvim
if ! command -v nvim &> /dev/null; then
    echo "☁️Downloading neovim..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install neovim
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update
        sudo apt-get install -y neovim
    fi
else
    echo "✓ Neovim is already installed."
fi

# Detect VS Code config directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
else
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
fi

# Only configure if VS Code config directory exists
if [ -d "$VSCODE_CONFIG_DIR" ]; then
    echo "🔧Configuring VS Code..."
    
    # Symlink settings and keybindings if dotfiles are not already in ~/.config
    if [ "$DOTFILES" != "$HOME/.config" ]; then
        ln -sf "$DOTFILES/vscode" "$HOME/.config/vscode"
    fi

    ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

    # Install extensions if code CLI is available
    if command -v code &> /dev/null; then
        echo "📦Installing VS Code extensions..."
        cat "$DOTFILES/vscode/extensions.txt" | xargs -L1 code --install-extension
    else
        echo "⚠️ VS Code CLI not found. Skipping extension installation."
        echo "   Run 'cat ~/.config/vscode/extensions.txt | xargs -L1 code --install-extension' later."
    fi
else
    echo "⚠️Skipping VS Code configuration."
fi

# Cleanup: Replace hardcoded user paths with $HOME for portability
echo "🧹Cleaning up hardcoded paths..."

cd "$DOTFILES"
git ls-files | while IFS= read -r file; do
  if [ -f "$file" ]; then
    # Handles macOS / Linux sed differences
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' -E 's|$HOME/]+|\$HOME|g; s|$HOME/]+|\$HOME|g' "$file" 2>/dev/null
    else
      sed -i -E 's|$HOME/]+|\$HOME|g; s|$HOME/]+|\$HOME|g' "$file" 2>/dev/null
    fi
  fi
done

echo "🕺Done setting up dotfiles!"