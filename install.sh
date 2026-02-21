#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Helpers ---

install_if_missing() {
    local name="$1" check="$2"
    shift 2

    if eval "$check"; then
        echo "✓ $name is already installed."
        return
    fi

    echo "☁️ Downloading $name..."
    "$@"
}

is_mac()   { [[ "$OSTYPE" == "darwin"* ]]; }
is_linux() { [[ "$OSTYPE" == "linux-gnu"* ]]; }

# --- Package Installs ---

mkdir -p ~/.config
sudo chown -R "$USER:$USER" ~/.config 2>/dev/null || true

if is_mac; then
    install_if_missing "Homebrew" "command -v brew &>/dev/null" \
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

install_if_missing "GitHub CLI" "command -v gh &>/dev/null" bash -c '
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    else
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update && sudo apt-get install -y gh
    fi
'

install_if_missing "1Password CLI" "command -v op &>/dev/null" bash -c '
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install --cask 1password-cli
    else
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
'

install_if_missing "Neovim" "command -v nvim &>/dev/null" bash -c '
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install neovim
    else
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update && sudo apt-get install -y neovim
    fi
'

install_if_missing "Pixi"       "command -v pixi &>/dev/null"         bash -c 'curl -fsSL https://pixi.sh/install.sh | sh'
install_if_missing "Claude Code" "command -v claude &>/dev/null"      bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
install_if_missing "uv"         "test -f \$HOME/.local/bin/uv"       bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
install_if_missing "pnpm"       "command -v pnpm &>/dev/null"        bash -c 'curl -fsSL https://get.pnpm.io/install.sh | sh -'

install_if_missing "nvm" "test -d \$HOME/.nvm" bash -c '
    NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep "\"tag_name\"" | sed -E "s/.*\"([^\"]+)\".*/\1/")
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install 22
    nvm alias default 22
'

install_if_missing "FiraCode Nerd Font" "bash -c '
    if [[ \"\$OSTYPE\" == \"darwin\"* ]]; then
        test -d \"\$HOME/Library/Fonts/FiraCode\"
    else
        test -d \"\$HOME/.local/share/fonts/FiraCode\"
    fi
'" bash -c '
    curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/getnf -o /tmp/getnf
    chmod +x /tmp/getnf
    /tmp/getnf -i FiraCode
    rm /tmp/getnf
'

install_if_missing "Bazelisk" "command -v bazel &>/dev/null" bash -c '
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install bazelisk
    else
        BAZELISK_URL=$(curl -s https://api.github.com/repos/bazelbuild/bazelisk/releases/latest | grep -o "\"browser_download_url\": \"[^\"]*bazelisk-linux-amd64\"" | sed "s/\"browser_download_url\": \"//;s/\"$//")
        [ -n "$BAZELISK_URL" ] && sudo curl -fsSL -o /usr/local/bin/bazel "$BAZELISK_URL" && sudo chmod +x /usr/local/bin/bazel
    fi
'

install_if_missing "Buildifier" "command -v buildifier &>/dev/null" bash -c '
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install buildifier
    else
        BUILDIFIER_URL=$(curl -s https://api.github.com/repos/bazelbuild/buildtools/releases/latest | grep -o "\"browser_download_url\": \"[^\"]*buildifier-linux-amd64\"" | grep -v ".sha256" | sed "s/\"browser_download_url\": \"//;s/\"$//")
        [ -n "$BUILDIFIER_URL" ] && sudo curl -fsSL -o /usr/local/bin/buildifier "$BUILDIFIER_URL" && sudo chmod +x /usr/local/bin/buildifier
    fi
'

install_if_missing "oh-my-zsh" "test -d \$HOME/.oh-my-zsh" bash -c \
    'RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

# --- Configuration ---

echo "⚙️ Configuring shell..."
rm -f ~/.zshrc ~/.zshenv

# MAX
if [ ! -d "$HOME/max" ]; then
    echo "🧠 Copying MAX project..."
    cp -r "$DOTFILES/max" "$HOME"
else
    echo "⚙️ Updating MAX configuration files..."
fi
cp -f "$DOTFILES/max/pixi.toml" "$HOME/max/pixi.toml"
cp -f "$DOTFILES/max/activation.sh" "$HOME/max/activation.sh"

# Symlinks (only needed when dotfiles aren't already at ~/.config)
if [ "$DOTFILES" != "$HOME/.config" ]; then
    ln -sf "$DOTFILES/alacritty" "$HOME/.config/alacritty"
    ln -sf "$DOTFILES/gh" "$HOME/.config/gh"
    ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
    ln -sf "$DOTFILES/zsh" "$HOME/.config/zsh"
fi

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
echo 'export ZDOTDIR="$HOME/.config/zsh"' > ~/.zshenv
sudo chsh -s "$(which zsh)" "$USER"

# Claude Code
echo "⚙️ Configuring Claude Code..."
rm -f ~/.claude/settings.json
ln -sf "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"

# Cleanup: Ensure dotfiles repo matches origin exactly
echo "🛀 Running dotfiles post-install cleanup..."
git -C "$DOTFILES" fetch origin
git -C "$DOTFILES" reset --hard origin/main
git -C "$DOTFILES" clean -fd

echo "🔥 Done setting up dotfiles!"
