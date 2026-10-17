# OpenCode v2 runtime verification

Verified in Sandbox on 2026-10-18 with OpenCode `v2.0.32`.

## Tested safe profile

The following ten entries installed successfully through the real `opencode plugin add` command and were loaded by a real `opencode serve` process:

- `@brycehamrick/opencode-hindsight@0.2.2`
- `@eleboucher/opencode-memini-v2@0.7.36`
- `@knikolov/opencode-plugin-simple-memory@2.0.0`
- `opencode-todolist@0.6.1`
- `oh-y-lockie-agent@2.0.1`
- `opencode-shell-magazine@0.1.4`
- `opencode2-enhanced-composer@0.1.0`
- `github:megablue/mega-skillstate#4aa74bd96fbea502e5efcc92994839c01b34c38f`
- `@falentio/opencode-pstack@1.1.0`
- `opencode-tasks@1.0.0`

A real `opencode run --server ... --format json` request returned `OK`, with no plugin load crash or V2 API exception. The server logs confirmed Hindsight initialization and Lockie MCP registration.

## External dependency warning

Hindsight initialized correctly but its remote recall calls returned `API key required` because `HINDSIGHT_API_TOKEN` was not provided. This is an expected service credential requirement, not an OpenCode V2 plugin loader failure. Memini likewise requires a reachable Memini server for memory operations. The installer does not fabricate credentials and keeps these extensions enabled only when the user chooses the relevant profile.

## Blocked entries

The following remain deliberately non-installable and are not in the safe profile:

- `claude-memory`, `headroom`, `delegation`, and `morph-plugin`: published artifacts are V1 implementations and need a real V2 port.
- `timeline-viewer` and `server-image`: no authoritative exact package/repository was found.
- `spec`: only a pinned unreleased V2 source checkout was verified; the published package is V1.
- `chrome-bridge`: conditional native integration, not part of the safe profile.
- `dynamic-context-pruning` and `engram-learning`: V2-shaped code exists, but packaging/peer metadata needs target-host validation.

The installer rejects blocked, unresolved, and build-required entries instead of silently installing incompatible packages.

## Cleanup verification

The complete managed uninstall was executed after the runtime test. Both isolated files ended with empty plugin arrays:

```json
{"plugins": []}
```

The managed state file was removed. OpenCode's shared package cache is intentionally not deleted by the script because it is shared between OpenCode projects and versions.
