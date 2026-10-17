# mega-skillstate

**Manifest ID:** `mega-skillstate`  
**Source:** `github:megablue/mega-skillstate`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Exact public repository resolved; inspect its current package before enabling.

## Agent research result

**Install:** `opencode plugin add 'github:megablue/mega-skillstate#4aa74bd96fbea502e5efcc92994839c01b34c38f'`

**Documented customization:** `enabled`, `min`, `keepRecentTurns`, `collapseOlder`, `protectFirstUserMessage`, `allowSubagentSessions`, `seedFromTools`, `trackTools`, `nudgeWhenStale`, `staleAfter`, `manualCommand`, `debug`, `maxResultChars`, `sigmaCondenseChars`, `sigmaWarnTokens`

**Recommendation:** Pin full SHA; npm package is not published.

See `research/11-mega-skillstate.md` for the full evidence report.
