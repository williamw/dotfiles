# Modular-only shared MCP config

## Goal
Install a shared MCP config at `~/.config/mcp/mcp.json` for the Modular profile only, containing Linear and Notion MCP servers. Slack is out of scope.

## Refined problem statement
Pi's MCP adapter can read `~/.config/mcp/mcp.json` automatically. The dotfiles repo should manage that file, but only on machines using the `modular` chezmoi profile. The personal profile should not receive this MCP config.

## Chosen approach
Add `dot_config/mcp/mcp.json` with Linear and Notion remote MCP endpoints, and add `.config/mcp` to the existing non-modular block in `.chezmoiignore`.

## Key constraints and assumptions
- Source directory is `~/dotfiles` / `/Users/bill/Developer/dotfiles`.
- Chezmoi source naming maps `dot_config/mcp/mcp.json` to `~/.config/mcp/mcp.json`.
- The existing profile mechanism uses `[data] profile` with values `personal` and `modular`.
- No secrets or Slack configuration should be committed.

## Likely files/systems/processes affected
- `.chezmoiignore`
- `dot_config/mcp/mcp.json`
- Target path after apply: `~/.config/mcp/mcp.json`

## Resolved operational details
- Linear MCP endpoint: `https://mcp.linear.app/mcp`
- Notion MCP endpoint: `https://mcp.notion.com/mcp`
- Modular-only gate: ignore `.config/mcp` when `profile != "modular"`.
- Apply command, scoped: `chezmoi -S ~/dotfiles apply ~/.config/mcp/mcp.json`

## Grill Bill workflow for this task
Route: simple. Challenge: the real need is a shared MCP config for Pi and other MCP clients, not a Slack integration. Cut: Slack and token handling are removed; no template is needed. Simplify: use static JSON and the repo's existing profile ignore block. Fastest validating version: add one config file, update one ignore block, inspect the diff, and optionally run a scoped chezmoi diff/apply.

## Skills required for execution
- grill-bill
- coding-style
- verification-before-completion

## Step-by-step implementation plan
1. Add `.config/mcp` to the existing non-modular ignore block in `.chezmoiignore`.
2. Create `dot_config/mcp/mcp.json` containing only Linear and Notion MCP servers.
3. Inspect the git diff to confirm only intended changes.
4. Optionally run scoped chezmoi diff/apply for `~/.config/mcp/mcp.json`.

## Verification/testing expectations
- Run `git diff -- .chezmoiignore dot_config/mcp/mcp.json`.
- Optionally run `chezmoi -S ~/dotfiles diff ~/.config/mcp/mcp.json` under the current profile.
- Do not run a broad `chezmoi apply`.

## Deferred work or non-goals
- Slack MCP/API integration is explicitly out of scope.
- No OAuth login or MCP server authentication during this change.
- No changes to assistant-agent.

## Execution options
Approved for inline execution.
