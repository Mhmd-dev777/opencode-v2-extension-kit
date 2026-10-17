# opencode-tasks

**Manifest ID:** `tasks`  
**Source:** `opencode-tasks@1.0.0`  
**Compatibility status:** `v2-reviewed`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

npm package metadata declares @opencode/plugin ^2.0.29.

## Agent research result

**Install:** `opencode plugin add opencode-tasks@1.0.0 && bunx opencode-tasks@1.0.0 --install`

**Documented customization:** `schedule`, `cwd`, `description`, `session_name`, `model`, `agent`, `timeout`, `permission`, `enabled`

**Recommendation:** Requires OpenCode >=2.0.29 and Bun; scheduler install is separate from plugin add.

See `research/15-tasks.md` for the full evidence report.
