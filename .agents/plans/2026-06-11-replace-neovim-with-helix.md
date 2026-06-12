# Replace Neovim with Helix

## Goal

Make Helix (`hx`) the editor owned by this dotfiles repo, using the `monokai_pro_spectrum` theme, and stop installing/configuring Neovim.

## Refined problem statement

The request is not to purge Neovim from every existing machine. The goal is to change the dotfiles source of truth so new or reapplied installs use Helix as the default editor and no longer deploy the Neovim/LazyVim configuration.

## Chosen approach

Use option B: replace editor ownership.

- Remove the managed Neovim config from the repo.
- Add a minimal managed Helix config.
- Install Helix instead of Neovim in the bootstrap package script.
- Point shell and GitHub CLI editor settings at `hx`.
- Update repo documentation/context to describe Helix as the neutral app config.

Do not uninstall Neovim from machines automatically.

## Key constraints and assumptions

- This is a chezmoi source repo at `/Users/bill/Developer/dotfiles`; commands should use `chezmoi -S ~/dotfiles` when applying.
- Keep applies scoped. Do not run a bare `chezmoi apply` unless explicitly requested.
- Existing target files may require `--force` if they were modified outside chezmoi.
- Neovim package removal is intentionally out of scope.
- The current installer has a macOS branch and a generic non-macOS branch that assumes apt-style Linux.

## Linux install path research

Official Helix docs recommend using the OS package manager where possible and list these relevant Linux options:

- Debian 13 and newer: `sudo apt install hx`
- Ubuntu/Mint and older Debian: install the `.deb` package from the Helix GitHub release page
- Ubuntu PPA option: `ppa:maveonair/helix-editor`, then `sudo apt install helix`
- Fedora/RHEL: `sudo dnf install helix`
- Arch: package is available in `extra` as `helix`
- Other portable options exist, including Flatpak, Snap, AppImage, prebuilt binaries, and building from source

For this repo's current apt-oriented Linux branch, the least disruptive replacement for the old Neovim PPA block is:

```bash
install_if_missing "Helix" "command -v hx &>/dev/null" bash -c '
    sudo add-apt-repository -y ppa:maveonair/helix-editor
    sudo apt-get update && sudo apt-get install -y helix
'
```

Rationale: it matches the existing script style, supports Ubuntu/Mint-like systems better than assuming Debian 13's `hx` package, and results in the expected command name `hx`.

Caveat: the PPA is documented as third-party by Helix. If we want only official release artifacts, the alternative is to script GitHub release `.deb` download/install, but that is more brittle than the existing installer style.

## Likely files/systems/processes affected

- `dot_config/nvim/` — remove from repo
- `dot_config/helix/config.toml` — add Helix theme config
- `run_once_before_install-packages.sh.tmpl` — replace Neovim install steps with Helix install steps
- `dot_config/zsh/dot_zshrc.tmpl` — set editor variables to `hx`
- `dot_config/gh/config.yml` — set `editor: hx`
- `README.md` — replace Neovim docs with Helix docs
- `CONTEXT.md` — replace Neovim neutral-app reference with Helix

## Resolved operational details

- Repository path: `/Users/bill/Developer/dotfiles`
- Target Helix config path after chezmoi apply: `~/.config/helix/config.toml`
- Chezmoi source file path: `dot_config/helix/config.toml`
- Theme: `monokai_pro_spectrum`
- Command: `hx`
- macOS install: `brew install helix`
- Linux apt-style install: Helix third-party PPA `ppa:maveonair/helix-editor`, installing package `helix`

## Grill Bill workflow for this task

Route: `simple`.

- Challenge the request: avoid destructive machine-level uninstall; change dotfiles ownership instead.
- Cut unnecessary work: do not migrate Neovim plugins/keymaps or remove already-installed packages.
- Simplify the design: add one Helix config file with one theme setting.
- Scope fastest validating version: update install/config/docs and verify with ripgrep plus chezmoi diff.
- Execute only after approval.

## Skills required for execution

- `coding-style`
- `verification-before-completion`

Use `git-commit` only if the user asks to commit.

## Step-by-step implementation plan

1. Remove `dot_config/nvim/` from the repo.
2. Create `dot_config/helix/config.toml`:
   ```toml
   theme = "monokai_pro_spectrum"
   ```
3. In `run_once_before_install-packages.sh.tmpl`:
   - macOS: replace Neovim install check with Helix check/install.
   - Linux: replace the Neovim PPA block with the Helix PPA block above.
4. In `dot_config/zsh/dot_zshrc.tmpl`:
   - change `EDITOR` from `nvim` to `hx`.
   - add or update `VISUAL` to `hx` if appropriate.
5. In `dot_config/gh/config.yml`, change `editor: nvim` to `editor: hx`.
6. Update `README.md` to list Helix and map `dot_config/helix` rather than `dot_config/nvim`.
7. Update `CONTEXT.md` to call Helix a neutral app config instead of Neovim.
8. Search for remaining Neovim references and decide whether any are historical/vendor files that should remain.

## Verification/testing expectations

Run:

```bash
rg -n "neovim|Neovim|nvim" . --glob '!*.git/**'
rg -n "helix|Helix|hx|EDITOR|VISUAL" README.md CONTEXT.md run_once_before_install-packages.sh.tmpl dot_config
chezmoi -S ~/dotfiles diff ~/.config/helix/config.toml ~/.config/zsh/.zshrc ~/.config/gh/config.yml
```

Optionally apply scoped files after reviewing the diff:

```bash
chezmoi -S ~/dotfiles apply ~/.config/helix/config.toml ~/.config/zsh/.zshrc ~/.config/gh/config.yml
```

## Deferred work or non-goals

- Do not uninstall Neovim from existing machines.
- Do not port Neovim/LazyVim customizations to Helix beyond the theme.
- Do not add language server installation yet.
- Do not broaden Linux distro support beyond the current installer shape unless requested.

## Execution options

1. Execute inline now.
2. Execute with `executing-plans` if this grows beyond the scoped replacement.
3. Stop here.
