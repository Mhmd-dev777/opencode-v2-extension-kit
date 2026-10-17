# opencode-shell-magazine

**Manifest ID:** `shell-magazine`  
**Source:** `opencode-shell-magazine@0.1.4`  
**Compatibility status:** `needs-review`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

TUI plugin; package peer dependencies target OpenTUI and should be tested in the exact V2 build.

## Agent research result

**Install:** `opencode plugin add opencode-shell-magazine@0.1.4`

**Documented customization:** `max entries`, `order`, `time format`, `show cwd`, `show exit code`, `show subagents`, `footer indicator`, `border`, `notification threshold`, `historyDirectory`

**Recommendation:** TUI-only; customize through its slash-command settings rather than invented JSON keys.

See `research/09-shell-magazine.md` for the full evidence report.
