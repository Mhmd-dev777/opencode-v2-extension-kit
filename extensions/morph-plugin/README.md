# opencode-morph-plugin

**Manifest ID:** `morph-plugin`  
**Source:** `UNRESOLVED`  
**Compatibility status:** `unresolved`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

No authoritative package/repository source was found; intentionally blocked.

## Agent research result

**Install:** `BLOCKED: scoped package is V1 API despite version 2`

**Documented customization:** `MORPH_API_KEY`, `MORPH_COMPACT`, `MORPH_EDIT`, `MORPH_WARPGREP`, `MORPH_WARPGREP_GITHUB`, `MORPH_COMPACT_RATIO`, `MORPH_COMPACT_PRESERVE_RECENT`

**Recommendation:** Requires a real V2 port; keep API key in environment only.

See `research/20-morph-plugin.md` for the full evidence report.
