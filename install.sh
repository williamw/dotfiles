#!/bin/bash

mkdir -p ~/.config
sudo chown -R $USER:$USER ~/.config 2>/dev/null || true

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

# 1Password CLI
if ! command -v op &> /dev/null; then
    echo "☁️Downloading 1Password CLI..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install --cask 1password-cli
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
        sudo tee /etc/apt/sources.list.d/1password.list

        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
        sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

        sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

        sudo apt-get update && sudo apt-get install -y 1password-cli
    fi
else
    echo "✓ 1Password CLI is already installed."
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

# Pixi
if ! command -v pixi &> /dev/null; then
    echo "☁️Downloading Pixi..."
    curl -fsSL https://pixi.sh/install.sh | sh
else
    echo "✓ Pixi is already installed."
fi

# Claude Code
if ! command -v claude &> /dev/null; then
    echo "☁️Downloading Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "✓ Claude Code is already installed."
fi

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

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "☁️Downloading oh-my-zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✓ oh-my-zsh is already installed."
fi

# Bootstrap
echo "⚙️Configuring shell..."
rm -f ~/.zshrc ~/.zshenv

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Only create symlinks if dotfiles are not already in ~/.config
# (e.g., when cloned to ~/.config/coderv2/dotfiles in RDE)
if [ "$DOTFILES" != "$HOME/.config" ]; then
    ln -sf "$DOTFILES/alacritty" "$HOME/.config/alacritty"
    ln -sf "$DOTFILES/gh" "$HOME/.config/gh"
    ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
    ln -sf "$DOTFILES/zsh" "$HOME/.config/zsh"
fi

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv

sudo chsh -s $(which zsh) $USER

# MAX
if [ ! -d "$HOME/max" ]; then
    echo "🧠Copying MAX project..."
    cp -r "$DOTFILES/max" $HOME
else
    echo "✓ MAX is already set up."
fi

# Claude Code config
echo "⚙️Configuring Claude Code..."
rm -f ~/.claude/settings.json
ln -sf "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"

# Detect VS Code config directory
# Check multiple possible locations in order of preference
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS paths
    if [ -d "$HOME/Library/Application Support/Code/User" ]; then
        VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
    elif [ -d "$HOME/.local/share/code-server/User" ]; then
        VSCODE_CONFIG_DIR="$HOME/.local/share/code-server/User"
    fi
else
    # Linux paths - check in order: desktop VS Code, code-server, then create for code-server if it exists
    if [ -d "$HOME/.config/Code/User" ]; then
        VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
    elif [ -d "$HOME/.local/share/code-server/User" ]; then
        VSCODE_CONFIG_DIR="$HOME/.local/share/code-server/User"
    elif [ -d "$HOME/.local/share/code-server" ]; then
        # code-server exists but User dir not yet created - create it
        mkdir -p "$HOME/.local/share/code-server/User"
        VSCODE_CONFIG_DIR="$HOME/.local/share/code-server/User"
    fi
fi

# Only configure if VS Code config directory exists or was created
if [ -n "$VSCODE_CONFIG_DIR" ] && [ -d "$VSCODE_CONFIG_DIR" ]; then
    echo "⚙️Configuring VS Code..."
    echo "   Using config directory: $VSCODE_CONFIG_DIR"

    # Symlink settings and keybindings if dotfiles are not already in ~/.config
    if [ "$DOTFILES" != "$HOME/.config" ]; then
        ln -sf "$DOTFILES/vscode" "$HOME/.config/vscode"
    fi

    ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

    # Install extensions if code CLI is available
    CODE_CLI=""
    if command -v code &> /dev/null; then
        CODE_CLI="code"
    elif command -v code-server &> /dev/null; then
        CODE_CLI="code-server"
    elif [ -x "/tmp/code-server/bin/code-server" ]; then
        CODE_CLI="/tmp/code-server/bin/code-server"
    fi

    if [ -n "$CODE_CLI" ]; then
        echo "📦Installing VS Code extensions..."

        failed_extensions=()
        new_extensions=0

        while IFS= read -r extension; do
            [ -z "$extension" ] && continue

            # Run install command, capturing output
            output=$($CODE_CLI --install-extension "$extension" 2>&1)
            exit_code=$?

            # Check if it's a new installation (not "already installed")
            if ! echo "$output" | grep -q "already installed"; then
                echo "   ✓ Installed $extension"
                ((new_extensions++))
            fi

            # Track failures (non-zero exit that's not a crash)
            if [ $exit_code -ne 0 ] && ! echo "$output" | grep -q "FATAL ERROR\|Abort trap"; then
                failed_extensions+=("$extension")
            fi

            # Add small delay to prevent race conditions
            sleep 0.2
        done < "$DOTFILES/vscode/extensions.txt"

        # Summary
        if [ "$new_extensions" -gt 0 ]; then
            echo "   Installed $new_extensions new extension(s)"
        else
            echo "   All extensions already installed"
        fi

        if [ ${#failed_extensions[@]} -gt 0 ]; then
            echo "⚠️ Failed to install: ${failed_extensions[*]}"
        fi
    else
        echo "⚠️ VS Code CLI not found. Skipping extension installation."
        echo "   Run 'cat ~/.config/vscode/extensions.txt | xargs -L1 code --install-extension' later."
    fi
else
    echo "⚠️Skipping VS Code configuration (no VS Code installation detected)."
fi

# Cleanup: Remove any symlinks within the repo (none should exist)
find "$DOTFILES" -type l -not -path "$DOTFILES/.git/*" -delete 2>/dev/null

echo "🔥Done setting up dotfiles!"
