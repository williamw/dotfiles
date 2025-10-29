# VS Code Configuration

This directory contains Visual Studio Code settings, keybindings, and extensions for a consistent development environment.

## What's Included

- **settings.json** - Editor preferences, theme, and tool configurations
- **keybindings.json** - Custom keyboard shortcuts (includes Xcode keybindings)
- **extensions.txt** - List of installed extensions (39 curated extensions)

## Theme and Appearance

- **Color Theme**: Monokai Pro (Filter Spectrum) - _Note: This is a paid theme (~$10). The extension will install it, but you may need to purchase a license._
- **Icon Theme**: Monokai Pro (Filter Spectrum) Icons
- **Font**: FiraCode Nerd Font with programming ligatures and icon glyphs enabled
- **Activity Bar**: Top location

## Key Features

### Keybindings

The keybindings.json includes **Xcode-style keybindings** for a familiar macOS development experience:

**View & Navigation:**

- **Cmd+0-4**: Toggle sidebar, Explorer, Search, Source Control, Debug views
- **Shift+Cmd+[/]**: Navigate between editor tabs
- **Ctrl+Cmd+Left/Right**: Navigate back/forward

**Editing:**

- **Alt+Up/Down**: Move lines up/down (custom override)
- **Alt+Cmd+[/]**: Move lines up/down (Xcode style)
- **Alt+Cmd+E**: Change all occurrences
- **Ctrl+Cmd+E**: Rename symbol (custom override)
- **Alt+Cmd+Left/Right**: Fold/unfold code

**Debug & Build:**

- **Cmd+R**: Start/restart debugging
- **Cmd+B**: Run build task
- **Cmd+U**: Run test task

### Editor Settings

- Format on save and paste enabled
- Auto-save on focus change
- Default formatter: Prettier
- Smart commit and auto-fetch for Git

## Extensions Overview

The extensions list includes support for:

- **AI Assistants**: Claude Code
- **Languages**: Python, Mojo, C/C++
- **Tools**: Docker, CMake, Bazel, Jupyter notebooks
- **Remote Development**: Coder, SSH, containers, WSL
- **Utilities**: code spell checker, markdown linting

## Installation

The install script automatically:

1. Creates symlinks for `settings.json` and `keybindings.json` to the appropriate VS Code directory:

   - **macOS**: `~/Library/Application Support/Code/User/`
   - **Linux**: `~/.config/Code/User/`

2. Installs all extensions listed in `extensions.txt` (if `code` CLI is available)

## Curating Extensions

You may want to review and customize `extensions.txt` before using on new machines:

```bash
# Remove extensions you don't need
nano ~/.config/vscode/extensions.txt

# Manually install all extensions
cat ~/.config/vscode/extensions.txt | xargs -L1 code --install-extension
```

## Notes

- Some settings have been removed for portability (API keys, machine-specific paths)
- Remote SSH host mappings are intentionally excluded
- Works with both native VS Code installations and web-based RDE environments
- **Monokai Pro theme**: This is a paid theme. Consider using a free alternative (Monokai Dimmed, One Dark Pro, Night Owl) if you don't have a license
- **Font configuration**: Requires FiraCode Nerd Font installed (handled by install.sh)
- **Xcode-style keybindings**: 27 Xcode-style keybindings are included directly in keybindings.json (no extension needed)
