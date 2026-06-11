# Fix agent tooling install drift

## Goal

Make `./install.sh` finish cleanly and keep future installs coherent by making `agent-skills` the single source of truth for skill policy while dotfiles only bootstraps and invokes it.

## Refined problem statement

The install itself completes, but the agent-tooling phase has three real issues:

1. Dotfiles installs local skills directly with `npx skills add ... --all`, then immediately invokes `agent-skills` managed sync, so local skill policy exists in two places.
2. `agent-skills` supports curated entries with different upstream folder selectors and installed skill names, but the install path passes selectors to `npx skills add`; this misses renamed macOS skills such as `macos-auto-update`.
3. Dotfiles tries to install the local `gh-wt` extension with `gh extension install /path`, but GitHub CLI requires local extension installs to run as `gh extension install .` from inside the repo.
4. Existing unmanaged global skills create audit removal candidates and should be cleaned explicitly as part of this repair.

The desired skill install shape is:

```text
universal: Cursor
symlink -> Claude Code
```

This is intentional. Cursor and Pi can use `~/.agents/skills`, and Claude Code should be linked from there.

## Chosen approach

Use model B: **`agent-skills` owns all skill policy; dotfiles only invokes it**.

Dotfiles should clone/update `~/Developer/agent-skills`, ensure the basic runtime tools are present, then run the canonical managed sync command from `agent-skills`. Dotfiles should not independently decide which skills to install and should not call `npx skills add ... --all` for the local repo.

Keep `manage-skills sync` doing an audit at the end. The output is useful and caught the current drift.

## Key constraints and assumptions

- Dotfiles source repo is `~/Developer/dotfiles`.
- `agent-skills` repo is `~/Developer/agent-skills`.
- `gh-wt` repo is `~/Developer/gh-wt`.
- Dotfiles should warn and continue if managed skill sync cannot run. A skill sync failure should not make the entire machine bootstrap fail.
- Normal `manage-skills sync` should install/resync managed skills and audit, but should not silently delete unmanaged skills.
- Stale skill cleanup is explicit for this repair.
- Personal profile skipping `assistant-agent` is expected and should remain.
- No rendered web UI files are touched, so `inspect-rendered-ui` is not required.

## Likely files, systems, and processes affected

### `~/Developer/agent-skills`

- `skills/manage-skills/install-skills.py`
  - Fix curated install selection for `selector` + `name` entries.
  - Add or use an explicit prune/removal command if needed.
- `skills/manage-skills/SKILL.md`
  - Update docs if a prune command or behavior changes.
- `skills/manage-skills/skills.yaml`
  - Should remain canonical. No membership change expected unless validation reveals otherwise.

### `~/Developer/dotfiles`

- `run_once_after_install-agent-tooling.sh.tmpl`
  - Remove direct local `npx skills add "$DEV_DIR/agent-skills" --all ...` install.
  - Keep `manage-skills sync --agent cursor --agent claude-code` as the only skill install path.
  - Keep warn-and-continue behavior for sync failures.
  - Fix `gh-wt` local extension install to run from inside the repo with `gh extension install .`.
- Possibly `README.md` and/or `AGENTS.md` only if wording needs to reflect the single-source-of-truth split.

### Local runtime state

- `~/.agents/skills/*`
- `~/.claude/skills/*`
- `~/.agents/.skill-lock.json`
- GitHub CLI extension state for `gh-wt`

## Resolved operational details

- Dotfiles invokes:

```bash
uv run "$DEV_DIR/agent-skills/skills/manage-skills/install-skills.py" sync \
  --agent cursor --agent claude-code
```

- Dotfiles should no longer invoke:

```bash
npx --yes skills add "$DEV_DIR/agent-skills" --all -y -a cursor -a claude-code
```

- `gh-wt` local install should be:

```bash
(cd "$DEV_DIR/gh-wt" && gh extension install .)
```

- Stale unmanaged skills to remove explicitly:

```text
brainstorming
clean-agents-md
find-skills
grill-with-docs
systematic-debugging
using-superpowers
writing-plans
zoom-out
```

Remove matching entries from `~/.agents/skills`, `~/.claude/skills` if present, and `~/.agents/.skill-lock.json` where present.

## Grill Bill workflow for this task

Route: **tenacious**

- Challenge the request: the install did not fully fail; the problem is responsibility drift between dotfiles and `agent-skills`, plus two concrete command bugs.
- Cut unnecessary work: do not change profile behavior, package installation, or unrelated skill membership.
- Simplify the design: `agent-skills` owns skill policy; dotfiles only clones repos and invokes the canonical sync tool.
- Scope the fastest validating version: fix curated skill selection, remove duplicate direct skill install, fix local `gh-wt` install, explicitly prune stale skills, then rerun sync/audit and install.
- Execute only after approval.

## Skills required for execution

- `manage-skills`
- `coding-style`
- `verification-before-completion`
- `git-commit` if committing changes

## Step-by-step implementation plan

1. In `~/Developer/agent-skills`, inspect `skills/manage-skills/install-skills.py` around curated install and audit/prune behavior.
2. Fix curated installs so entries with `selector` + `name` install by actual skill name while validation still checks selector/name against upstream.
3. Add an explicit prune/remove command if the helper does not already have one. It should remove only unmanaged removal candidates or explicitly named skills, and should update the skills CLI lockfile safely.
4. Update `skills/manage-skills/SKILL.md` if the helper gains a new prune command or cleanup workflow.
5. In `~/Developer/dotfiles/run_once_after_install-agent-tooling.sh.tmpl`, remove the direct `npx skills add "$DEV_DIR/agent-skills" --all ...` call.
6. Keep one managed sync call with `--agent cursor --agent claude-code`, with warn-and-continue behavior if `uv` or sync fails.
7. Fix `gh-wt` extension install to run `gh extension install .` from inside `$DEV_DIR/gh-wt`.
8. Explicitly prune the stale unmanaged skills listed above from local runtime state.
9. Run managed sync and audit.
10. Run dotfiles install again to verify the bootstrap output is clean.
11. Optionally commit changes in one or two commits:
    - `agent-skills`: fix managed skill sync/prune behavior
    - `dotfiles`: invoke managed skill sync only and fix gh-wt install

## Verification and testing expectations

Run from `~/Developer/agent-skills` or by absolute path:

```bash
uv run ~/Developer/agent-skills/skills/manage-skills/install-skills.py sync --agent cursor --agent claude-code
uv run ~/Developer/agent-skills/skills/manage-skills/install-skills.py audit --agent cursor --agent claude-code
```

Expected audit end state after explicit cleanup:

```text
missing managed installs: none
removal candidates: none
Claude symlink drift: none
```

Expected skill install shape:

```text
universal: Cursor
symlinked: Claude Code
```

Verify macOS renamed skills are installed:

```bash
ls ~/.agents/skills/macos-auto-update \
   ~/.agents/skills/macos-build \
   ~/.agents/skills/macos-notch-ui \
   ~/.agents/skills/macos-release \
   ~/.agents/skills/macos-settings-ui
```

Verify `gh-wt`:

```bash
gh extension list
gh wt --help
```

Verify dotfiles bootstrap:

```bash
cd ~/Developer/dotfiles
./install.sh
```

Expected dotfiles outcome:

- no broad `Installing to all 71 agents` local skill install
- no missing `macos-*` managed skills
- no stale removal candidates after cleanup
- no Claude symlink drift
- no `gh-wt install failed` message

## Deferred work or non-goals

- Do not add `assistant-agent` to the personal profile.
- Do not change the curated skill pack membership unless validation proves the manifest is wrong.
- Do not remove audit-after-sync.
- Do not auto-delete unmanaged skills during normal dotfiles install.
- Do not change package installation or shell configuration.

## Execution options

1. Execute inline now.
2. Execute with `executing-plans` for checkpointed multi-step work.
3. Stop here.
