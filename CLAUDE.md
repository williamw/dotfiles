# Dotfiles repo — chezmoi

This is a chezmoi-managed dotfiles repository.

## Chezmoi usage

- The source directory is `~/dotfiles`, **not** the default `~/.local/share/chezmoi`. Always pass `-S ~/dotfiles` to chezmoi commands:
  ```bash
  chezmoi -S ~/dotfiles diff
  chezmoi -S ~/dotfiles apply ~/.claude/settings.json
  ```
- If a target file was modified outside chezmoi, apply will prompt interactively (which fails in non-TTY contexts). Use `--force` to overwrite:
  ```bash
  chezmoi -S ~/dotfiles apply --force ~/.claude/settings.json
  ```
- Target specific files when possible. A bare `chezmoi apply` processes all templates, including ones that depend on 1Password (e.g. `dot_config/zsh/dot_zshrc.tmpl` uses `onepasswordRead`), which will fail without an active 1Password session.

## File conventions

- `.chezmoiignore` lists repo files that chezmoi should not install (e.g. `CLAUDE.md`, `README.md`, `install.sh`).
- Templates (`.tmpl` suffix) use Go templating. Secrets are injected via 1Password integration.

## Claude Code permissions

- Global permissions live in `dot_claude/settings.json` (installed to `~/.claude/settings.json`). Only read-only tools and commands are allowed globally.
- Edit/Write permissions are granted per-project via `.claude/settings.local.json`.
