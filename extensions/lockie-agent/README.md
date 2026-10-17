# oh-y-lockie-agent

**Manifest ID:** `lockie-agent`  
**Source:** `oh-y-lockie-agent@2.0.1`  
**Compatibility status:** `needs-review`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

npm package resolved, but repository and V2 API details are not exposed in metadata.

## Agent research result

**Install:** `opencode plugin add oh-y-lockie-agent@2.0.1`

**Documented customization:** `telemetry`, `agent.<name>.model`, `agent.<name>.disable`, `mcp.<name>.enabled`, `updateCheck.enabled`, `updateCheck.intervalHours`, `target.chip`, `target.family`

**Recommendation:** Set telemetry=false explicitly and audit default MCP/network access.

See `research/08-lockie-agent.md` for the full evidence report.
