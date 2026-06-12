# Install Pi instead of Claude Code

## Goal

Remove Claude Code installation from the dotfiles bootstrap and install Pi plus Pi Web Access for both personal and modular profiles.

## Refined problem statement

The bootstrap currently installs Claude Code only for the modular profile. Bill wants the dotfiles to stop installing Claude Code and instead install Pi and Pi Web Access consistently across both supported profiles.

## Chosen approach

Keep the profile-specific Pixi install for the modular profile, remove the Claude Code installer, and add Pi tooling after nvm setup so npm/node are available.

## Key constraints and assumptions

- Pi should be installed globally with `npm install -g --ignore-scripts @earendil-works/pi-coding-agent`.
- Pi Web Access should be installed with `pi install npm:pi-web-access`.
- Both installs should run for personal and modular profiles.
- Existing Claude Code configuration files can remain unless explicitly removed; this task targets installation behavior and docs.

## Likely files affected

- `run_once_before_install-packages.sh.tmpl`
- `README.md`
- `run_once_after_install-agent-tooling.sh.tmpl`

## Grill Bill workflow

Route: simple.

- Challenge: the real issue is bootstrap behavior, not existing Claude settings.
- Cut: avoid unrelated config cleanup.
- Simplify: use existing `install_if_missing` helper and place npm-dependent steps after nvm.
- Fastest validation: inspect diffs and render/check templates enough to confirm command placement.

## Skills required for execution

- verification-before-completion

## Implementation plan

1. Remove the Claude Code installer line from the modular-only cross-platform block.
2. Add Pi and Pi Web Access install checks after nvm installs Node/npm.
3. Update README references so included tools mention Pi instead of Claude Code installation.
4. Adjust agent tooling wording/arguments where Claude Code-specific managed skill sync is no longer wanted.
5. Run verification commands and inspect the resulting diff.

## Verification/testing expectations

- `chezmoi -S ~/dotfiles diff` or equivalent repo diff inspection.
- Template syntax/render check if available.
- `git diff --check`.

## Deferred work / non-goals

- Removing existing `dot_claude/` settings is not included unless requested.
- Applying the dotfiles to the current machine is not included unless requested.

## Execution options

1. Execute inline.
2. Stop after plan.
