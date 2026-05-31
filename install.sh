#!/bin/bash
set -euo pipefail

# Thin bootstrapper: installs chezmoi and applies dotfiles.
# All package installation logic lives in run_once_before_install-packages.sh.tmpl

DOTFILES_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v chezmoi &>/dev/null; then
    echo "☁️ Installing chezmoi..."
    sh -c "$(curl -fsSL get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "⚙️ Applying dotfiles with chezmoi..."
DOTFILES_PROFILE="${DOTFILES_PROFILE:-personal}"
case "$DOTFILES_PROFILE" in
    personal|modular) ;;
    *)
        echo "Unsupported DOTFILES_PROFILE: $DOTFILES_PROFILE" >&2
        echo "Expected one of: personal, modular" >&2
        exit 1
        ;;
esac
chezmoi init --apply --source="$DOTFILES_REPO" --override-data "{\"profile\":\"$DOTFILES_PROFILE\"}"

echo "🔥 Done setting up dotfiles!"
