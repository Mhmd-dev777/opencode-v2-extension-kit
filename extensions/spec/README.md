# opencode-spec

**Manifest ID:** `spec`  
**Source:** `github:devcxl/opencode-spec`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Exact public repository resolved; inspect its current package before enabling.

## Agent research result

**Install:** `BUILD_REQUIRED: clone pinned commit, npm ci, npm run build, then load ./dist`

**Documented customization:** `directory`, `OPENSPEC_DIR`

**Recommendation:** Published npm artifact is V1; only pinned source master is V2-shaped and must be built.

See `research/07-spec.md` for the full evidence report.
