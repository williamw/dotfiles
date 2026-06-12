# Dotfiles repo — chezmoi

This is a chezmoi-managed dotfiles repository.

## Chezmoi usage

- The source directory is `~/Developer/dotfiles`, **not** the default `~/.local/share/chezmoi`. The local chezmoi config should set `sourceDir = "/Users/bill/Developer/dotfiles"`; if you need to be explicit, pass `-S ~/Developer/dotfiles`:
  ```bash
  chezmoi -S ~/Developer/dotfiles diff
  chezmoi -S ~/Developer/dotfiles apply ~/.claude/settings.json
  ```
- Profiles are persisted in the local chezmoi config under `[data] profile`. Supported values are `personal` and `modular`; first install defaults to `personal` unless `DOTFILES_PROFILE=modular` is set.
- If a target file was modified outside chezmoi, apply will prompt interactively (which fails in non-TTY contexts). Use `--force` to overwrite:
  ```bash
  chezmoi -S ~/Developer/dotfiles apply --force ~/.claude/settings.json
  ```
- Target specific files when possible. A bare `chezmoi apply` can touch many files at once, so keep applies scoped unless you intentionally want every managed file updated.

## File conventions

- `.chezmoiignore` lists repo files that chezmoi should not install (e.g. `AGENTS.md`, `README.md`, `install.sh`).
- Templates (`.tmpl` suffix) use Go templating. Shared secrets should be optional so missing 1Password access does not prevent dotfiles from applying.

## Agent tooling

- `run_once_after_install-agent-tooling.sh.tmpl` clones `williamw/agent-skills` and `williamw/gh-wt` into `~/Developer` on both profiles, clones `williamw/assistant-agent` to `~/Developer/assistant-agent` on the Modular profile only, prints a reminder to open that repo and run its setup flow from the docs, installs local skills via `npx skills`, syncs the curated third-party pack via `skills/manage-skills/install-skills.py`, and installs the `gh wt` extension from its local clone. Idempotent; public repos; explicit personal-profile skip note for `assistant-agent`.

## Claude Code permissions

- Global permissions live in `dot_claude/settings.json` (installed to `~/.claude/settings.json` for the Modular profile only). Only read-only tools and commands are allowed globally.
- Edit/Write permissions are granted per-project via `.claude/settings.local.json`.
