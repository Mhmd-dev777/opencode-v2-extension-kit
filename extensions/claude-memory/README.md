# lansya/opencode-plugin-claude-memory

**Manifest ID:** `claude-memory`  
**Source:** `github:lansya/opencode-plugin-claude-memory`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Repository named by user; verify package entrypoint and V2 API before enabling.

## Agent research result

**Install:** `BLOCKED: published candidate targets OpenCode V1`

**Documented customization:** `once`, `debug`

**Recommendation:** Do not install on V2; requires a real port to @opencode/plugin.

See `research/05-claude-memory.md` for the full evidence report.
