# opencode-chrome-bridge

**Manifest ID:** `chrome-bridge`  
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

**Install:** `BUILD_REQUIRED: clone pinned commit, npm ci, install native host and Chrome extension; configure src/plugin-entry-v2.js`

**Documented customization:** `OPENCODE_CONFIG_DIR`, `XDG_STATE_HOME`, `native node path`

**Recommendation:** Full native messaging and Chrome extension stack; V2 adapter is conditional and root package is V1.

See `research/18-chrome-bridge.md` for the full evidence report.
