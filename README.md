# Bill's Dotfiles

These are my personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/), for setting up a consistent development environment across macOS and Linux systems.

## What's Included

This repository configures the following tools and applications:

- **oh-my-zsh** - Framework for managing Zsh configuration
- **zsh** - Shell configuration with custom prompt and aliases
- **Claude Code** - AI coding assistant CLI from Anthropic (Modular profile only)
- **uv** - Fast Python package installer and resolver
- **nvm** - Node Version Manager for managing Node.js versions
- **pnpm** - Fast, disk space efficient package manager for Node.js
- **FiraCode Nerd Font** - Monospaced font with programming ligatures and icons
- **Neovim** - Hyperextensible Vim-based text editor
- **GitHub CLI (gh)** - GitHub's official command line tool
- **Ghostty** - Fast GPU-accelerated terminal emulator
- **Homebrew** - Package manager for macOS (macOS only)
- **Secrets Management** - 1Password integration via chezmoi for injecting API tokens and credentials
- **Pixi** - Package manager for Modular/MAX environments (Modular profile only)
- **Agent skills** - AI agent skills + the `assistant` starter from [`williamw/agent-skills`](https://github.com/williamw/agent-skills) (installed globally via `npx skills`)
- **gh wt** - bare-git worktree CLI extension from [`williamw/gh-wt`](https://github.com/williamw/gh-wt)

## Installation

Clone this repository and run the bootstrapper:

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The bootstrapper installs chezmoi (if needed) and runs `chezmoi init --apply` with the `personal` profile by default. To install the Modular profile:

```bash
DOTFILES_PROFILE=modular ./install.sh
```

The bootstrapper then:

1. Installs required tools and applications for the selected profile via the `run_once_before_install-packages.sh.tmpl` script (skipping anything already present)
2. Deploys all configuration files to their correct locations
3. Sets zsh as the default shell

## How It Works

This repo is a [chezmoi](https://www.chezmoi.io/) source directory. Files use chezmoi naming conventions:

- `dot_config/` → `~/.config/` (ghostty, gh, nvim, zsh, karabiner)
- `dot_claude/` → `~/.claude/` (Claude Code settings; Modular profile only)
- `dot_zshenv` → `~/.zshenv` (sets ZDOTDIR)
- `symlink_dot_zshrc` → `~/.zshrc` (symlink to `.config/zsh/.zshrc`)
- `dot_config/zsh/dot_zshrc.tmpl` → `~/.config/zsh/.zshrc` (zsh configuration with optional 1Password-backed secrets)
- `max/` → `~/max/` (MAX/Modular project workspace; Modular profile only)
- `run_once_before_install-packages.sh.tmpl` → package installation (runs once)
- `.chezmoi.toml.tmpl` → generated local chezmoi config with persisted profile data

Shared secrets are loaded opportunistically from 1Password at shell startup when available, but missing 1Password access should not prevent chezmoi from applying dotfiles.

**Note:** This repo lives at `~/dotfiles`, not the chezmoi default (`~/.local/share/chezmoi`). When running chezmoi commands manually, pass `-S ~/dotfiles`:

```bash
chezmoi -S ~/dotfiles diff
chezmoi -S ~/dotfiles apply ~/.config/ghostty/config
```

The `install.sh` bootstrapper handles this automatically via `chezmoi init --apply`.

Karabiner configuration is automatically skipped on non-macOS systems.

## Agent tooling

A `run_once_after_install-agent-tooling.sh` step bootstraps the agent toolkit
(both profiles):

- Clones [`williamw/agent-skills`](https://github.com/williamw/agent-skills) and
  [`williamw/gh-wt`](https://github.com/williamw/gh-wt) into `~/Developer`.
- Installs your own skills from the local `agent-skills` clone via `npx skills`.
- Installs the third-party favorites declared in `agent-skills`'
  `skills/favorite-skills/favorites.yaml`.
- Installs the `gh wt` extension from the local `gh-wt` clone.

All target repos are public, so the step runs without GitHub authentication. It
is idempotent: clones fast-forward on re-run and installs are safe to repeat.

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
