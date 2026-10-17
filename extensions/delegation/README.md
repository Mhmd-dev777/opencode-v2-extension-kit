# opencode-delegation

**Manifest ID:** `delegation`  
**Source:** `opencode-delegation@0.1.2`  
**Compatibility status:** `needs-review`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

npm package metadata has no public repository field and declares @opencode-ai/plugin; inspect before V2 use.

## Agent research result

**Install:** `BLOCKED: published package uses V1 API`

**Documented customization:** `agent.worker.model`, `agent.worker.steps`, `skills.paths`

**Recommendation:** Requires a real V2 port before use.

See `research/19-delegation.md` for the full evidence report.
