# Install pi-mcp-adapter from dotfiles

## Goal
Update the chezmoi dotfiles so future bootstraps install the Pi extension `npm:pi-mcp-adapter` with `pi install npm:pi-mcp-adapter`.

## Refined problem statement
Pi itself and `pi-web-access` are already installed by `run_once_before_install-packages.sh.tmpl`. The missing piece is an idempotent bootstrap step for `pi-mcp-adapter`.

## Chosen approach
Add one `install_if_missing` entry beside the existing Pi extension install.

## Key constraints and assumptions
- Source directory is `~/dotfiles` / `/Users/bill/Developer/dotfiles`.
- Keep the install idempotent by checking `pi list` before running `pi install`.
- Do not disturb unrelated in-progress dotfiles edits.

## Likely files affected
- `run_once_before_install-packages.sh.tmpl`
- Optionally documentation if a concise mention is useful.

## Grill Bill workflow
Route: simple. Challenge: the request is to persist extension installation, not install it only once locally. Cut: no new scripts or profile branching needed. Simplify: mirror the existing Pi Web Access install line. Fastest validating version: edit the template and inspect the diff.

## Skills required for execution
- grill-bill

## Implementation plan
1. Insert an idempotent `install_if_missing "Pi MCP Adapter"` entry after `Pi Web Access`.
2. Verify the diff only touches the intended lines.
3. Do not run a broad `chezmoi apply` unless requested.

## Verification/testing expectations
- Review `git diff -- run_once_before_install-packages.sh.tmpl`.
- Optional local apply command if requested: `chezmoi -S ~/dotfiles apply --force ~/run_once_before_install-packages.sh` or rerun bootstrap flow as appropriate.

## Deferred work / non-goals
- No immediate local extension install unless explicitly requested.
- No broader Pi configuration changes.

## Execution options
Approved for inline execution.
