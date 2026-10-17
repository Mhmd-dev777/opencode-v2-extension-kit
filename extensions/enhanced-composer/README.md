# opencode2-enhanced-composer

**Manifest ID:** `enhanced-composer`  
**Source:** `opencode2-enhanced-composer@0.1.0`  
**Compatibility status:** `needs-review`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Package requires Node >=26.4.0; treat as environment-sensitive.

## Agent research result

**Install:** `opencode plugin add opencode2-enhanced-composer@0.1.0`

**Documented customization:** `layout`, `appearance`, `overflow.preset`, `refreshHz`, `bytesPerToken`

**Recommendation:** Requires Node >=26.4.0 and OpenCode >=2.0.11; TUI cli.json configuration.

See `research/10-enhanced-composer.md` for the full evidence report.
