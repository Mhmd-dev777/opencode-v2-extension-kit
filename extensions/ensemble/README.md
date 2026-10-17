# hueyexe/opencode-ensemble@0.18.0

**Status:** `v2-reviewed`

**Pinned source:** `@hueyexe/opencode-ensemble@0.18.0`

## Install

```bash
opencode plugin add @hueyexe/opencode-ensemble@0.18.0
```

## Requirements

- OpenCode V2
- Node >=24 or Bun >=1.0
- Writable ~/.config/opencode/ensemble.db
- Git for worktree agents

## Strong defaults

The sibling `options.json` contains conservative defaults. Apply them using the extension's documented config file or environment variables; do not place credentials in this file.

## Managed files

- `~/.config/opencode/ensemble.json`
- `<project>/.opencode/ensemble.json`
- `~/.config/opencode/ensemble.db`
- `~/.local/share/opencode/worktree/`


## Verification

- /api/health on localhost:4747 if enabled
- team_create/team_spawn with worktree:false
- database rehydration after restart


This extension is included only because its V2 entrypoint and installation source were independently verified.
