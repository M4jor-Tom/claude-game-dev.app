# claude-game-dev.app

Runs [Claude Code](https://claude.com/product/claude-code) against the
[`claude-game-dev`](https://github.com/M4jor-Tom/claude-game-dev) profile — the
ontology-first game development config — and supplies every CLI that profile's
skills shell out to.

```bash
nix run github:M4jor-Tom/claude-game-dev.app
```

On first run it clones the profile to `~/.claude-game-dev`, submodules included:
that profile's `skills/` are 69 symlinks into `vendor/`, so the clone has to be
recursive. On later runs it fast-forwards the clone and updates the submodules,
but only when the tree is clean — local edits are never clobbered — and only
when `origin` still points at this profile's own repo, so pointing
`CLAUDE_GAME_DEV_DIR` at a fork or an unrelated checkout gets no pulls.

This app is a convenience, not a requirement. The profile works on its own:

```bash
CLAUDE_CONFIG_DIR=~/.claude-game-dev claude
```

It is also usable as a project's `.claude/` submodule — see the profile's own
README.

## What it ships

`claude-code git gh glab nodejs bun pnpm ripgrep fd jq yq-go uv python3 sqlite
curl chromium imagemagick rtk graphify markitdown pandoc poppler-utils yt-dlp`

The same closure as `claude-power-dev.app`, from the same `package.nix`.
`nixpkgs#claude-code` already sets `DISABLE_AUTOUPDATER=1`,
`DISABLE_INSTALLATION_CHECKS=1` and `USE_BUILTIN_RIPGREP=0`, defaults
`FORCE_AUTOUPDATE_PLUGINS=1`, and puts `ripgrep`, `procps`, `bubblewrap` and
`socat` on Claude Code's own PATH. The flake allows unfree packages for its own
nixpkgs, because `claude-code` is unfree — without that, `nix run` would fail
before building anything.

## Not shipped

The engine toolchains this profile's skills drive — `godot`, `dotnet`, `love`,
`butler`, `steamcmd` — are per-project, not per-profile. Put them in the game
repo's own devShell.

## Plugins on a fresh clone

The profile declares its marketplaces in `settings.json`
(`extraKnownMarketplaces`) and its plugins in `enabledPlugins`. Claude Code
clones a declared-but-missing marketplace and downloads its enabled plugins in
the background *after* the session starts, so on a brand-new machine log in
first and the plugins follow. `claude plugin marketplace update` forces it.
