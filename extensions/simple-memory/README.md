# knikolov/opencode-plugin-simple-memory

**Manifest ID:** `simple-memory`  
**Source:** `github:knikolov/opencode-plugin-simple-memory`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Repository named by user; verify package entrypoint and V2 API before enabling.

## Agent research result

**Install:** `opencode plugin add '@knikolov/opencode-plugin-simple-memory@2.0.0'`

**Documented customization:** `autoLoad`, `autoSave`, `autoHookTimeoutMs`, `contextLimit`, `contextMaxChars`, `contextMinScore`, `autoSaveScope`

**Recommendation:** Uses Bun filesystem APIs; verify runtime and repository identity before production.

See `research/04-simple-memory.md` for the full evidence report.
