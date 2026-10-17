# brycehamrick/opencode-v2-hindsight

**Manifest ID:** `hindsight`  
**Source:** `github:brycehamrick/opencode-v2-hindsight`  
**Compatibility status:** `unverified`

## Customization surface

Edit [`options.json`](./options.json) to define only options documented by the upstream package. The default `options` object is intentionally empty. Add environment variables under `environment` only as variable names or safe non-secret values; keep tokens outside Git. Add permission rules under `permissions` only after reviewing the OpenCode permission model.

This extension is enabled by default only when its manifest status is `v2-reviewed`. For other statuses, use an explicit review profile and run the installer with `--allow-risky`.

## Verification

Before changing this extension to `v2-reviewed`, verify its package entrypoint, peer dependencies, OpenCode v2 API usage, tools, hooks, commands, cleanup behavior, and persisted state in a clean project.

## Upstream note

Repository named by user; verify package entrypoint and V2 API before enabling.

## Agent research result

**Install:** `opencode plugin add @brycehamrick/opencode-hindsight@0.2.2`

**Documented customization:** `dynamicBankId`, `dynamicBankGranularity`, `retainMode`, `stripSecrets`, `stripBase64`, `recallBudget`, `recallContextTurns`, `coreMemoryMaxTokens`, `perMessageRecallMaxTokens`, `compactionRecallMaxTokens`, `debug`

**Recommendation:** Use environment variables for HINDSIGHT_API_TOKEN; prefer dynamicBankId with agent/gitProject isolation.

See `research/01-hindsight.md` for the full evidence report.
