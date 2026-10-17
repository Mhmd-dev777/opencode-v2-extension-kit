# `opencode-dynamic-context-pruning` — OpenCode V2 Extension Research

**Research status: verified with an important packaging caveat.** The requested repository resolves to the public project at `Tarquinen/opencode-dynamic-context-pruning`; its current package is published as `@tarquinen/opencode-dcp`. The repository's canonical package/repository links now use the `Opencode-DCP` GitHub owner, but the package name remains `@tarquinen/opencode-dcp`.[1] [2]

## Identity and safe installation

The unscoped string `opencode-dynamic-context-pruning` is a GitHub repository/project name, not the published package name shown by the repository README and npm metadata. The npm registry endpoint for the unscoped name did not return package metadata, so it should not be used as an install target. Do not guess an unscoped npm package from the project name.

The **safe, reproducible install specification** is the exact npm package version:

```text
@tarquinen/opencode-dcp@3.2.0
```

Use the current OpenCode V2 CLI command documented by OpenCode and the repository, but pin the version rather than using the repository's unpinned `@latest` example:

```sh
opencode plugin add @tarquinen/opencode-dcp@3.2.0
```

The equivalent V2 configuration entry is:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": ["@tarquinen/opencode-dcp@3.2.0"]
}
```

The repository README documents `opencode plugin add @tarquinen/opencode-dcp@latest`; OpenCode V2 documents the same `plugin add` syntax and states that exact npm versions remain pinned. Therefore, the exact `3.2.0` command above is safer for a manifest/kit than `@latest`. The npm web page currently displays a different legacy-looking form (`opencode plugin @tarquinen/opencode-dcp@latest --global`); prefer the official V2 documentation and the repository README's `plugin add` form.[1] [3] [4]

## Published versions and package metadata

Verified npm metadata for the official package currently reports:

- Package: `@tarquinen/opencode-dcp`.
- `latest`: **3.2.0**.
- A `beta` dist-tag exists at **3.2.8-beta0**; it is not the safe stable target.
- The repository `package.json` also reports version **3.2.0**.
- Package format is ESM: `"type": "module"`.
- Main entrypoint: `./dist/index.js`; declaration entrypoint: `./dist/index.d.ts`.
- Published exports include `.`, `./server`, and `./tui`.
- The 3.2.0 npm artifact has a provenance/attestation record and points to repository commit `d637981555a18c3992472268a0657a948925d5fa`.[2] [4]

There is another npm package, `@keakon/opencode-dcp@1.2.8`, whose metadata also points at the same historical repository. It is a separate package identity with an older API/dependency line (`@opencode-ai/plugin >=0.13.7`), and is not the safe target for this V2 manifest. The evidence-backed canonical current target is `@tarquinen/opencode-dcp@3.2.0`.[5]

## Is a real V2 plugin entrypoint present?

**Yes, the source contains a real V2 entrypoint, but the published peer-dependency declaration is V1-oriented.** This is a dual V1/V2 package rather than a V2-only package.

Evidence in the current repository:

1. `index.ts` imports the V1 `Plugin` type from `@opencode-ai/plugin`, imports `setup` from `./lib/v2`, and default-exports an object with a stable ID plus both functions:

   ```ts
   export default { id: "opencode-dcp", setup, server }
   ```

2. `lib/v2/index.ts` imports the V2 `Plugin` type from `@opencode/plugin` and defines `setup(ctx: Plugin.Context)`. It uses V2 context APIs including `ctx.model.transform`, `ctx.session.hook`, `ctx.rpc.register`, and V2 session/model context data.

3. OpenCode's official V2 documentation says V2 reads a default export's `id` and `setup()`; when one package supports both generations, V1 calls `server()` and V2 ignores `server()`. DCP's export shape matches that documented dual-entrypoint pattern.[6] [7] [8]

### V1/V2 indicator check

- **V1 indicators present:** `@opencode-ai/plugin` is a peer dependency; `index.ts` has a V1-style `server` function; `lib/v2/index.ts` has a runtime import of `tool` from `@opencode-ai/plugin`.
- **V2 indicators present:** the default export has `id` and `setup`; `lib/v2/index.ts` imports the V2 `@opencode/plugin` type and uses V2 context hooks/transforms.
- **Packaging caveat:** `package.json` declares only `@opencode-ai/plugin >=1.18.29` as a peer dependency. `@opencode/plugin ^2.0.4` appears only in `devDependencies`, not `dependencies` or `peerDependencies`. This differs from the official V2 publishing example, which recommends a compatible `@opencode/plugin` dependency. The V2 implementation is real and identifiable in source, but exact-host installation must be tested rather than inferred solely from package metadata.[2] [6] [7]

## Peer dependencies, dependencies, and runtime requirements

### Peer dependency

The current repository and npm 3.2.0 metadata both declare:

```text
@opencode-ai/plugin >=1.18.29
```

There is **no declared `@opencode/plugin` peer dependency** in the published 3.2.0 metadata.[2]

### Runtime dependencies

The published package declares these runtime dependencies:

```text
@anthropic-ai/tokenizer ^0.0.4
@opencode-ai/sdk ^1.4.3
@opentui/core ^0.4.5
@opentui/solid ^0.4.5
jsonc-parser ^3.3.1
solid-js ^1.9.12
```

The package also publishes TUI-related material (`./tui`), so the OpenTUI dependencies are part of the package's supported surface.[2]

### Runtime/environment facts and limits of the evidence

- No `engines` field is declared in the current repository `package.json` or npm 3.2.0 metadata. **No minimum Node.js version is authoritatively specified.**
- The package is ESM and is compiled with TypeScript target `ES2022`, module `ESNext`, and bundler module resolution. This is a packaging/build fact, not proof of a standalone Node runtime requirement.[9]
- The contributor guide says development uses Node.js/npm and that the V1/V2 sandbox exercises both hosts. It does not establish a production Node minimum. OpenCode's own runtime/plugin loader should be treated as the runtime requirement.[10]
- The official V2 docs require package plugins to use versions compatible with the OpenCode release being targeted and recommend testing the installed package, not only a workspace-linked copy.[6]

## Documented configuration options

DCP reads its own JSONC/JSON file, not the main plugin list. Search order is documented as global `~/.config/opencode/dcp.jsonc` (or `dcp.json`), `$OPENCODE_CONFIG_DIR/dcp.jsonc` (or `dcp.json`) when set, then project `.opencode/dcp.jsonc` (or `dcp.json`). Later/project settings override earlier ones. Restart OpenCode after changes.[1] [11]

The repository README and `dcp.schema.json` document these options:

- Top level: `$schema`, `enabled` (default `true`), `autoUpdate` (default `true` for npm-installed DCP), `debug` (default `false`), `pruneNotification` (`off|minimal|detailed`, default `detailed`), and `pruneNotificationType` (`chat|toast`, default `chat`).
- `commands.enabled` (default `true`) and `commands.protectedTools` (additional tool names or glob patterns protected from command-driven pruning).
- `manualMode.enabled` (default `false`) and `manualMode.automaticStrategies` (default `true`); manual mode makes compression tools explicit while automatic deduplication/error-purge can remain active.
- `turnProtection.enabled` (default `false`) and `turnProtection.turns` (default `4`).
- `experimental.allowSubAgents` (default `false`) and `experimental.customPrompts` (default `false).
- `protectedFilePatterns`: glob patterns for file operations that must be protected.
- `compress.mode`: `range` (default) or experimental `message`.
- `compress.permission`: `allow` (default), `ask`, or `deny`; `deny` disables the compression tool.
- `compress.showCompression` (default `false`).
- `compress.summaryBuffer` (default `true`).
- `compress.maxContextLimit` (default `100000`) and `compress.minContextLimit` (default `50000`); each accepts a number or a percentage string such as `80%`.
- `compress.modelMaxLimits` and `compress.modelMinLimits`: optional per-`providerID/modelID` overrides that take precedence over global limits.
- `compress.nudgeFrequency` (default `5`), `compress.iterationNudgeThreshold` (default `15`), and `compress.nudgeForce` (`strong|soft`, default `soft`).
- `compress.protectedTools`, `compress.protectTags` (default `false`, preserves `<protect>...</protect>` text), and `compress.protectUserMessages` (default `false`).
- `strategies.deduplication.enabled` (default `true`) and `strategies.deduplication.protectedTools`.
- `strategies.purgeErrors.enabled` (default `true`), `strategies.purgeErrors.turns` (default `4`), and `strategies.purgeErrors.protectedTools`.

All protected-tool arrays accept additional tool names; the schema documents glob wildcards (`*` and `?`) for the relevant arrays. Built-in protected tools include core task/skill/todo tools, compression, batching, planning, and write/edit tools. The exact built-in list is host/version-sensitive, so user overrides should add protection rather than replace assumptions.[1] [11]

DCP also documents these user-facing commands:

- `/dcp` opens the DCP panel with context, statistics, and manual-mode controls.
- `/dcp-compress [focus]` requests one compression pass, optionally focused by supplied text.

When `experimental.customPrompts` is enabled, the documented override prompt names are `system`, `compress-range`, `compress-message`, `context-limit-nudge`, `turn-nudge`, and `iteration-nudge`. Defaults are written under `~/.config/opencode/dcp-prompts/defaults/`; matching override files can be edited as plain text.[1]

## Strongest evidence-based customization plan

1. **Pin the plugin first.** Use `@tarquinen/opencode-dcp@3.2.0`, not `@latest` or the beta tag, and record the exact OpenCode V2 build used for validation. The exact pin avoids silent package drift; OpenCode says exact npm versions remain pinned.[2] [3]
2. **Create a project-local `dcp.jsonc` only after a baseline run.** Start with defaults, run a long session, and observe `/dcp` statistics. Project-local config has highest precedence and is easier to review than changing global policy.
3. **Match context thresholds to the actual model.** The README explicitly warns that smaller-context models need lower `compress.minContextLimit` and `compress.maxContextLimit`. Prefer percentage limits or per-model overrides when the kit supports multiple providers/models.[1]
4. **Protect high-value context before increasing aggressiveness.** Add project-specific tools to `compress.protectedTools`, `commands.protectedTools`, and strategy-specific `protectedTools`; add important file globs to `protectedFilePatterns`. Keep `task`, `skill`, todo, write/edit, and other orchestration outputs protected unless a measured test proves they are safe to prune.
5. **Use V2-safe permission behavior.** The schema exposes `ask`, but the V2 implementation explicitly reports that `compress` permission `ask` is not supported by OpenCode V2's public plugin API yet. For V2 validation, use `allow` or `deny`; treat `ask` as an incompatibility test, not a recommended production setting.[11] [12]
6. **Keep subagents disabled initially.** `experimental.allowSubAgents` defaults to `false`, and DCP explains that subagent pruning may interfere with final summarization. Enable only after dedicated subagent regression tests.[1]
7. **Use `message` mode and custom prompts only as controlled experiments.** `message` mode is documented as experimental. Enable `customPrompts` only when prompt files are version-controlled and reviewed; test that the prompt preserves the host's V2 message-ID format.
8. **Evaluate cache economics.** DCP changes outgoing context and can invalidate provider prompt-cache prefixes. Compare token savings, cache reads, latency, and error/recovery quality before making aggressive pruning defaults universal.[1]
9. **Validate the installed artifact, not a checkout.** Run `opencode plugin list`, `opencode plugin check`, restart OpenCode, invoke `/dcp`, and run `/dcp-compress` in a disposable V2 project. Confirm the plugin loads without peer-resolution errors and that compression, protection, and context-limit behavior work on the exact target release.[3] [6]

## Verification checklist for the manifest maintainer

- Resolve and install exactly `@tarquinen/opencode-dcp@3.2.0`.
- Confirm OpenCode configuration uses V2 `plugins` (plural), not V1 `plugin`.
- Confirm the loaded package reports ID `opencode-dcp` and reaches V2 `setup`.
- Test with `compress.permission: "allow"`; separately verify that `deny` disables the tool. Do not assume `ask` works in V2.
- Test `/dcp` and `/dcp-compress [focus]`.
- Test a protected tool and a protected file glob, then verify an ordinary repeated tool call can be deduplicated.
- Test a smaller model/context window with lower `minContextLimit`/`maxContextLimit`.
- Inspect OpenCode/plugin logs and the DCP debug directory only if `debug: true` is temporarily enabled.
- Keep the plugin marked **V2-compatible with packaging caveat**, not unconditionally “V2-native,” until the exact OpenCode V2 build passes these checks.

## Warnings and uncertainty

- **V2 implementation is verified in source; package metadata is mixed-generation.** The V2 `id`/`setup` entrypoint is real, but `@opencode/plugin` is only a dev dependency while `@opencode-ai/plugin` is the peer dependency. This is the central compatibility caveat.
- **No explicit Node engine requirement exists.** Do not add a guessed Node minimum to the manifest.
- **The repository says development has slowed** because newer context-management work moved to Sleev. DCP remains available, but maintenance/future-feature expectations should be conservative.[1]
- The package is licensed **AGPL-3.0-or-later** in the current repository and npm 3.2.0 metadata. Check this against the distribution policy before bundling it.[2]
- Pruning modifies outgoing request context and can reduce prompt-cache hits. Token savings are not guaranteed to dominate cache costs for every provider.[1]
- `@keakon/opencode-dcp` is an older separate npm package identity, not a reason to change the current safe install target.[5]

## References

[1]: https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/README.md "Official DCP repository README"
[2]: https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/package.json "Official DCP repository package.json"
[3]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin configuration and CLI documentation"
[4]: https://registry.npmjs.org/@tarquinen%2Fopencode-dcp/latest "npm registry metadata for @tarquinen/opencode-dcp latest"
[5]: https://registry.npmjs.org/@keakon%2Fopencode-dcp "npm registry metadata for the separate @keakon/opencode-dcp package"
[6]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin development and publishing documentation"
[7]: https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/index.ts "DCP default entrypoint showing id, setup, and server"
[8]: https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/lib/v2/index.ts "DCP V2 setup implementation"
[9]: https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/tsconfig.json "DCP TypeScript compiler configuration"
[10]: https://raw.githubusercontent.com/Tarquinen/opencode-dynamic-context-pruning/master/CONTRIBUTING.md "DCP development, V1/V2 sandbox, and testing notes"
[11]: https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/dcp.schema.json "DCP configuration schema"
[12]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1-to-V2 migration guidance"
