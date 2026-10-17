# opencode-headroom

**Manifest ID:** `headroom`  
**Source:** `opencode-headroom@0.1.0`  
**Compatibility status:** `needs-review`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

npm metadata declares peer @opencode-ai/plugin *; inspect entrypoint for V2 API.

## Agent research result

**Install:** `BLOCKED: published package is V1-only`

**Documented customization:** `enabled`, `min_tokens_to_compress`, `live_zone_only`, `real_time`, `cache_align`, `verbose`, `ccr_db_path`

**Recommendation:** Requires a real V2 port; do not enable published package.

See `research/14-headroom.md` for the full evidence report.
