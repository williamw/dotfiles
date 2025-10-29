# Bill's Dotfiles

These are my personal dotfiles for setting up a consistent development environment across macOS and Linux systems.

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
- **git** - Version control configuration
- **Alacritty** - GPU-accelerated terminal emulator
- **Homebrew** - Package manager for macOS (macOS only)

## Installation

### Standard Installation

Clone this repository to `~/.config` and run the install script:

```bash
git clone <your-repo-url> ~/.config
cd ~/.config
./install.sh
```

The install script will:

1. Install oh-my-zsh
2. Set up shell configuration and symlinks
3. Install all required tools and applications
4. Configure Claude Code with sensible defaults
5. Clean up any hardcoded paths for portability

### Using with Coder RDE Instances

When using this repository with Coder's Remote Development Environment (RDE), the dotfiles can be cloned to a custom location like `~/.config/coderv2/dotfiles`. The install script automatically detects this scenario and creates the appropriate symlinks:

```bash
# In RDE, dotfiles might be at:
~/.config/coderv2/dotfiles/

# The install script will symlink:
~/.config/alacritty -> ~/.config/coderv2/dotfiles/alacritty
~/.config/gh -> ~/.config/coderv2/dotfiles/gh
~/.config/git -> ~/.config/coderv2/dotfiles/git
~/.config/nvim -> ~/.config/coderv2/dotfiles/nvim
~/.config/zsh -> ~/.config/coderv2/dotfiles/zsh
```

Files that need to be in specific locations (like `~/.zshrc` and `~/.claude/settings.json`) are always symlinked regardless of the location this dotfiles repo is cloned into.

## Forking This Repository

If you fork this repository for your own use, make sure to update the following:

### Personal Information in `git/config`

Update your name and email in `git/config`:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

### Other Considerations

- Review the shell aliases and functions in `zsh/.zshrc` to match your preferences
- Modify the Claude Code permissions in `claude/settings.json` if desired
- Ensure no API keys or tokens are committed to the repo

## Path Portability

The install script includes a cleanup step that automatically replaces hardcoded user name paths with `$HOME` variables:

- Converts `/Users/<username>` (macOS) → `$HOME`
- Converts `/home/<username>` (Linux) → `$HOME`

This ensures the dotfiles remain portable across different users and systems. The cleanup:

- Only processes files tracked by git (respects `.gitignore`)
- Works for any username (not hardcoded)
- Handles both macOS and Linux path conventions

## Platform Support

These dotfiles are designed to work on:

- macOS (tested on Apple Silicon only)
- Linux (Ubuntu/Debian-based distributions)

The install script automatically detects the platform and installs the appropriate tools and configurations.

## License

This work has been dedicated to the public domain under CC0 1.0 Universal. You can copy, modify, distribute and use the work, even for commercial purposes, all without asking permission. See the [LICENSE](LICENSE) file for details.

To the extent possible under law, the author has waived all copyright and related rights to this work.
