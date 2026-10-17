# opencode-supermemory@2.0.17

**Status:** `v2-reviewed`

**Pinned source:** `opencode-supermemory@2.0.17`

## Install

```bash
bunx opencode-supermemory@2.0.17 install --no-tui
```

## Requirements

- OpenCode V2 plugin API
- Bun for bunx installer
- SUPERMEMORY_API_KEY or login
- Network access to api.supermemory.ai

## Strong defaults

The sibling `options.json` contains conservative defaults. Apply them using the extension's documented config file or environment variables; do not place credentials in this file.

## Managed files

- `opencode.json(c)`
- `supermemory.json(c)`
- `~/.supermemory-opencode/credentials.json`
- `~/.config/opencode/commands/`
- `.opencode-supermemory.log`


## Verification

- supermemory status
- inspect v2 plugin registered log
- safe remember then recall in a new session


This extension is included only because its V2 entrypoint and installation source were independently verified.
