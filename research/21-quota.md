# Research: slkiser/opencode-quota@5.0.3

- Compatibility: **v2-reviewed**
- Pinned artifact: `@slkiser/opencode-quota@5.0.3`
- Install: `opencode plugin add @slkiser/opencode-quota@5.0.3`

## Requirements
- OpenCode >=2.0.16
- Node ^22.13.0 or >=23.4.0 for CLI
- Provider logins/API keys and network access for live quota data

## Customization
- core
- enabledProviders
- quotaProviders
- minIntervalMs
- requestTimeoutMs
- formatStyle
- quotaProjection
- tuiSidebarPanel
- export
- telemetry
- provider overrides

## Files
- `opencode.json(c)`
- `opencode-quota/quota-toast.json(c)`
- `$XDG_CACHE_HOME/opencode/quota-export.json (optional)`

## Verification
- /quota_status
- /quota
- npx --yes @slkiser/opencode-quota@5.0.3 status --json

## Decision
Added to the project because the research agents verified an OpenCode V2 entrypoint and an exact installation source. Runtime credentials and external services remain opt-in.
