# opencode-engram-learning

**Manifest ID:** `engram-learning`  
**Source:** `opencode-engram-learning@1.15.1`  
**Compatibility status:** `needs-review`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

npm metadata declares peer @opencode-ai/plugin ^1.4.3; do not claim V2 compatibility without a port.

## Agent research result

**Install:** `opencode plugin add opencode-engram-learning@1.15.1`

**Documented customization:** `ENGRAM_HOME`, `/learn`, `/review-loop`, `/coach`, `focus`, `visuals`

**Recommendation:** Has a V2 adapter but still declares a V1 peer; runtime-test exact V2.

See `research/13-engram-learning.md` for the full evidence report.
