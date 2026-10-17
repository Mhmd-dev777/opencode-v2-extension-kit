# opencode-todolist

**Manifest ID:** `todolist`  
**Source:** `opencode-todolist@0.6.1`  
**Compatibility status:** `v2-reviewed`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

npm package metadata declares @opencode/plugin >=2.0.0.

## Agent research result

**Install:** `opencode plugin add opencode-todolist@0.6.1`

**Documented customization:** `auto-todos.json`, `priority`, `always`, `match`, `order`, `deduplicate`, `/todo-settings`

**Recommendation:** Use auto-todos.json and /todo-settings; package exposes no generic plugin options schema.

See `research/06-todolist.md` for the full evidence report.
