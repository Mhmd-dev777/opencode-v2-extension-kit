# slkiser/opencode-quota@5.0.3

**Status:** `v2-reviewed`

**Pinned source:** `@slkiser/opencode-quota@5.0.3`

## Install

```bash
opencode plugin add @slkiser/opencode-quota@5.0.3
```

## Requirements

- OpenCode >=2.0.16
- Node ^22.13.0 or >=23.4.0 for CLI
- Provider logins/API keys and network access for live quota data

## Strong defaults

The sibling `options.json` contains conservative defaults. Apply them using the extension's documented config file or environment variables; do not place credentials in this file.

## Managed files

- `opencode.json(c)`
- `opencode-quota/quota-toast.json(c)`
- `$XDG_CACHE_HOME/opencode/quota-export.json (optional)`


## Verification

- /quota_status
- /quota
- npx --yes @slkiser/opencode-quota@5.0.3 status --json


This extension is included only because its V2 entrypoint and installation source were independently verified.
