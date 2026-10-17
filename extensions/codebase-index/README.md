# open-codebase-index@0.36.3

**Status:** `v2-reviewed`

**Pinned source:** `open-codebase-index@0.36.3`

## Install

```bash
opencode plugin add open-codebase-index@0.36.3
```

## Requirements

- OpenCode V2
- Node >=22.13.0
- Embedding provider: Ollama, OpenAI, Google, or custom endpoint
- Writable .opencode/index/

## Strong defaults

The sibling `options.json` contains conservative defaults. Apply them using the extension's documented config file or environment variables; do not place credentials in this file.

## Managed files

- `.opencode/codebase-index.json`
- `~/.config/opencode/codebase-index.json`
- `.opencode/index/`
- `~/.opencode/global-index/`


## Verification

- index_status or /status
- index_codebase or /index
- codebase_search and codebase_context


This extension is included only because its V2 entrypoint and installation source were independently verified.
