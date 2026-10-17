# eleboucher/opencode-memini-v2

**Manifest ID:** `memini-v2`  
**Source:** `github:eleboucher/opencode-memini-v2`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Repository named by user; verify package entrypoint and V2 API before enabling.

## Agent research result

**Install:** `opencode plugin add @eleboucher/opencode-memini-v2@0.7.36`

**Documented customization:** `base_url`, `namespace`, `recall`, `capture`, `capture_child_sessions`, `recall_limit`, `recall_max_tokens`, `recall_min_score`, `inject_cooldown_ms`, `inject_cooldown_prompts`, `recall_budget_ms`, `timeout_ms`, `fallback_on_error`, `auto_update`

**Recommendation:** Requires a running Memini server; keep MEMINI_API_KEY and HTTPS settings outside Git.

See `research/03-memini-v2.md` for the full evidence report.
