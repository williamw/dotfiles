#!/bin/bash
set -euo pipefail

# Thin bootstrapper: installs chezmoi and applies dotfiles.
# All package installation logic lives in run_once_before_install-packages.sh.tmpl

DOTFILES_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v chezmoi &>/dev/null; then
    echo "☁️ Installing chezmoi..."
    sh -c "$(curl -fsSL get.chezmoi.io)"
fi

echo "⚙️ Applying dotfiles with chezmoi..."
chezmoi init --apply --source="$DOTFILES_REPO"

echo "🔥 Done setting up dotfiles!"
