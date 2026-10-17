# opencode-timeline-viewer

**Manifest ID:** `timeline-viewer`  
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

**Install:** `BLOCKED: no authoritative npm or Git source found`

**Documented customization:** No plugin-specific options verified.

**Recommendation:** User must provide an exact official repository or package.

See `research/16-timeline-viewer.md` for the full evidence report.
