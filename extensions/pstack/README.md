# falentio/opencode-pstack

**Manifest ID:** `pstack`  
**Source:** `github:falentio/opencode-pstack`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Repository named by user; verify package entrypoint and V2 API before enabling.

## Agent research result

**Install:** `opencode plugin add @falentio/opencode-pstack@1.1.0`

**Documented customization:** No plugin-specific options verified.

**Recommendation:** No documented plugin-specific options; use native skills/agents for customization.

See `research/12-pstack.md` for the full evidence report.
