# opencode-dynamic-context-pruning

**Manifest ID:** `dynamic-context-pruning`  
**Source:** `github:Tarquinen/opencode-dynamic-context-pruning`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Publicly referenced repository; verify current branch/package entrypoint.

## Agent research result

**Install:** `opencode plugin add @tarquinen/opencode-dcp@3.2.0`

**Documented customization:** `enabled`, `autoUpdate`, `pruneNotification`, `compress.mode`, `compress.permission`, `protectedTools`, `protectedFilePatterns`, `strategies.deduplication.enabled`, `strategies.purgeErrors.enabled`, `turnProtection.turns`, `manualMode.enabled`

**Recommendation:** Package contains a real V2 entrypoint but declares a V1-oriented peer; test exact host.

See `research/02-dynamic-context-pruning.md` for the full evidence report.
