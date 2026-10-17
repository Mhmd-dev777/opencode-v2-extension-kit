# opencode-tavily

**Status:** `v2-reviewed`

**Pinned source:** `opencode-tavily@1.0.0`

## Install

```bash
opencode plugin add opencode-tavily@1.0.0
```

## Requirements

- OpenCode V2
- tvly on PATH
- Tavily account and TAVILY_API_KEY or OAuth
- Network access
- Writable .tavily/

## Strong defaults

The sibling `options.json` contains conservative defaults. Apply them using the extension's documented config file or environment variables; do not place credentials in this file.

## Managed files

- `opencode.json(c)`
- `skills/tavily/`
- `.tavily/`
- `tvly executable`


## Verification

- tvly --status
- search with --client-name opencode
- extract/map/crawl smoke tests


This extension is included only because its V2 entrypoint and installation source were independently verified.
