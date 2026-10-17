# Research-backed compatibility summary

The 26 requested extensions were researched independently. Each report in `research/` records the authoritative source, exact install target, OpenCode V2 entrypoint evidence, peer dependencies, documented settings, requirements, verification steps, and warnings.

The installer now uses the following policy:

- `v2-reviewed`: directly installable by the safe profile with an exact npm version or pinned Git commit.
- `needs-review`: source contains V2 evidence but packaging or peer metadata still targets an older API; requires `--allow-risky`.
- `v2-source-unreleased`: V2 source exists but the published package is V1 or absent; build from the pinned commit manually.
- `v2-conditional`: V2 adapter exists but the package also contains V1 code or depends on a native integration; follow the per-extension build guide.
- `v1-blocked`: published artifact is a V1 implementation and must not be enabled in OpenCode V2.
- `unresolved`: no authoritative exact package or repository source was found.

The current safe profile includes the extensions with a V2-shaped entrypoint and a reproducible source/version. It includes the six newly verified extensions (`quota`, `codebase-index`, `supermemory`, `ensemble`, `tavily`, and `notifier`). It intentionally does not include `dynamic-context-pruning`, `engram-learning`, or the source-only/conditional integrations until their exact target-host runtime tests are completed. It never includes V1-blocked or unresolved entries.

## Strong customization model

Each extension has `extensions/<id>/options.json`, `profile.json`, and `README.md`. The options file contains only keys supported by the research report. The renderer creates `config/generated/opencode-v2-extensions.jsonc` in the official OpenCode V2 `plugins` format. Secrets remain environment-only.

Use:

```bash
./bin/opencode-v2-extensions list-profiles
./bin/opencode-v2-extensions render --profile safe
./bin/opencode-v2-extensions render --profile memory --allow-risky
./bin/opencode-v2-extensions install --profile productivity --dry-run
```

Build-required items are never passed blindly to `opencode plugin add`. Their per-extension README contains the pinned checkout and build procedure. V1-blocked items contain a porting plan based on the official OpenCode migration guide, but the script will not claim that the port already exists.
