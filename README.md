# Bill's Dotfiles

These are my personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/), for setting up a consistent development environment across macOS and Linux systems.

## What's Included

This repository configures the following tools and applications:

- **oh-my-zsh** - Framework for managing Zsh configuration
- **zsh** - Shell configuration with custom prompt and aliases
- **Claude Code** - AI coding assistant CLI from Anthropic
- **uv** - Fast Python package installer and resolver
- **nvm** - Node Version Manager for managing Node.js versions
- **pnpm** - Fast, disk space efficient package manager for Node.js
- **FiraCode Nerd Font** - Monospaced font with programming ligatures and icons
- **Neovim** - Hyperextensible Vim-based text editor
- **GitHub CLI (gh)** - GitHub's official command line tool
- **Alacritty** - GPU-accelerated terminal emulator
- **Homebrew** - Package manager for macOS (macOS only)

## Installation

Clone this repository and run the bootstrapper:

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The bootstrapper installs chezmoi (if needed) and runs `chezmoi init --apply`, which:

1. Installs all required tools and applications via the `run_once_before_install-packages.sh.tmpl` script (skipping anything already present)
2. Deploys all configuration files to their correct locations
3. Sets zsh as the default shell

## How It Works

This repo is a [chezmoi](https://www.chezmoi.io/) source directory. Files use chezmoi naming conventions:

- `dot_config/` → `~/.config/` (alacritty, gh, nvim, zsh, karabiner)
- `dot_claude/` → `~/.claude/` (Claude Code settings)
- `dot_zshenv` → `~/.zshenv` (sets ZDOTDIR)
- `symlink_dot_zshrc` → `~/.zshrc` (symlink to `.config/zsh/.zshrc`)
- `max/` → `~/max/` (MAX/Modular project workspace)
- `run_once_before_install-packages.sh.tmpl` → package installation (runs once)

Karabiner configuration is automatically skipped on non-macOS systems.

## Forking This Repository

If you fork this repository for your own use, make sure to update the following:

- Review the shell aliases and functions in `dot_config/zsh/dot_zshrc` to match your preferences
- Modify the Claude Code permissions in `dot_claude/settings.json` if desired
- Ensure no API keys or tokens are committed to the repo

## Platform Support

These dotfiles are designed to work on:

- macOS (tested on Apple Silicon only)
- Linux (Ubuntu/Debian-based distributions)

Platform-specific packages are handled via chezmoi templates in the `run_once_before_install-packages.sh.tmpl` script.

## License

This work has been dedicated to the public domain under CC0 1.0 Universal. You can copy, modify, distribute and use the work, even for commercial purposes, all without asking permission. See the [LICENSE](LICENSE) file for details.

To the extent possible under law, the author has waived all copyright and related rights to this work.
