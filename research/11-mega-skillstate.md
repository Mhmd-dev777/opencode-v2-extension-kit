# mega-skillstate — OpenCode V2 extension research

**ID:** `mega-skillstate`  
**Requested source:** `github:megablue/mega-skillstate`  
**Research status:** **V2 entrypoint verified in the public repository; npm publication unresolved as a package because the registry returns 404.** The repository is authoritative and unambiguous, but it is not a published npm package.

## Verdict / الخلاصة

`megablue/mega-skillstate` is a real OpenCode 2.x plugin repository. Its `server.ts` re-exports the default OpenCode adapter, and the adapter default-exports an object with the V2 `id` and `setup` surface. The source imports the V2 package name `@opencode/plugin` as a **type-only** import; there is no `@opencode-ai/plugin` import in the OpenCode adapter. This is strong evidence of a V2 implementation, not a V1-only plugin. [1] [2] [3] [8] [10]

The safest reproducible package target is the immutable Git commit `4aa74bd96fbea502e5efcc92994839c01b34c38f` on `main` at the time of research. Use the Git specification, not `mega-skillstate@0.3.0` from npm: npm reports HTTP 404 and the repository manifest explicitly has `"private": true`. The repository itself documents a separate copy-to-discovery-directory installer, which is the most directly documented installation path. [3] [4] [11]

## Authoritative identity and version evidence

- **Repository:** [megablue/mega-skillstate](https://github.com/megablue/mega-skillstate), public, default branch `main`, MIT license. GitHub describes it as an “OpenCode 2.0 plugin”. [1]
- **Repository HEAD used for pinning:** `4aa74bd96fbea502e5efcc92994839c01b34c38f`; the GitHub branch API identifies this as the `main` commit. The commit is unsigned according to GitHub metadata; the full SHA is still the correct reproducibility pin for a Git install. [11]
- **Repository package version:** `0.3.0`. [3]
- **npm publication:** **not published under the exact name**. `https://registry.npmjs.org/mega-skillstate` returns HTTP 404 / `E404 Not Found`; the npm package page does not expose a package. Do not use `mega-skillstate@0.3.0` as an npm install target. [4]
- **Tags/releases:** the GitHub tags endpoint returned an empty list. There is therefore no authoritative semver Git tag to prefer over the full commit SHA. [12]
- **Package flags:** `private: true`, `type: "module"`, `main: "./server.ts"`, and exports for `.`, `./server`, and `./package.json`. [3]

## V2 plugin entrypoint check

**Result: PRESENT and verified.** There are two layers:

1. `server.ts` is the host entrypoint and contains `export { default } from "./src/adapters/opencode/index.ts"`. Its comment says the loader resolves `<plugin-root>/server` before `<plugin-root>/index` and probes `.ts` before `.js`. [8]
2. `src/adapters/opencode/index.ts` imports `type { Plugin } from "@opencode/plugin"`, defines `setup(ctx)`, registers V2 model/session/tool/command hooks, and ends with:

   ```ts
   export default { id, setup } satisfies Plugin.Plugin
   ```

   The plugin ID is `mega-skillstate`. [10]

OpenCode’s official V2 documentation says a V2 plugin is a default export with a stable `id` and `setup(ctx)`; its examples use `Plugin.define`, but the documentation also describes the default-export `id`/`setup` contract and a compatible object form. The mega-skillstate source matches that contract even though it does not call `Plugin.define`. [6] [7]

### V1 indicator check

- **V2 indicator found:** `@opencode/plugin` in the OpenCode adapter, as a type-only import; default export has `id` plus `setup`. [10]
- **V1 indicator not found in the OpenCode adapter:** no `@opencode-ai/plugin` import and no V1 function export of the form `export const Plugin = async (...) => hooks`.
- The repository has a separate `src/adapters/pi/index.ts` default function for the Pi ecosystem. That is not the OpenCode entrypoint and should not be mistaken for a V1 OpenCode plugin. [10]
- Official migration guidance says V1 implementations using `@opencode-ai/plugin` do not run in V2 merely by renaming configuration; V2 needs the `id`/`setup` API. mega-skillstate meets the latter requirement. [7]

## Safe install specification and commands

### Preferred manifest/install target: pinned Git package

```text
github:megablue/mega-skillstate#4aa74bd96fbea502e5efcc92994839c01b34c38f
```

OpenCode V2 officially accepts npm-compatible Git package specifications, including hosted `github:` shortcuts and complete commit hashes; exact Git revisions remain pinned. [5]

```sh
opencode plugin add 'github:megablue/mega-skillstate#4aa74bd96fbea502e5efcc92994839c01b34c38f'
```

The resulting configured package should be represented in V2 configuration as an entry under `plugins`, for example:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": [
    "github:megablue/mega-skillstate#4aa74bd96fbea502e5efcc92994839c01b34c38f"
  ]
}
```

**Important qualification:** the repository README documents its own directory installer, not `opencode plugin add`; the Git command above follows the official OpenCode V2 Git-package contract and is the safest package-spec form, but it should be tested against the exact OpenCode build used by the consumer. The Git source has `private: true` and is not an npm publication. [2] [3] [5]

### Repository-documented directory installation

The README’s directly documented install path is to clone the repository and run its installer. To make that path reproducible, check out the same full SHA first:

```sh
git clone https://github.com/megablue/mega-skillstate.git
cd mega-skillstate
git checkout 4aa74bd96fbea502e5efcc92994839c01b34c38f
npm run plugin:install
```

The installer copies the manifest `files[]` set plus `package.json` into `~/.config/opencode/plugins/` for user scope. The project-scope variant is:

```sh
npm run plugin:install:project
```

The README says the host loads `server.ts` directly, no build step and no `node_modules` are needed for the installed copy, and OpenCode must be restarted after installation or code changes. [2] [8]

## Package versions, dependencies, and runtime requirements

### Versions

- `mega-skillstate`: repository version `0.3.0`. [3]
- `@opencode/plugin`: exact **development dependency** `2.0.26`; it is also the API version against which the repository’s OpenCode types were measured. It is **not declared as a peer dependency or runtime dependency**. [3] [10]
- `typescript`: development dependency `^5.8.0`. [3]
- `@types/node`: development dependency `^22.15.0`. [3]
- The lockfile root repeats `@opencode/plugin: 2.0.26` and the same package version `0.3.0`. [9]

### Peer dependencies

The manifest declares these peers, all with the unconstrained range `*`:

- `pi-ai`
- `pi-agent-core`
- `pi-coding-agent`
- `pi-tui`
- `typebox`

These are the repository’s cross-adapter/Pi peers. They are not `@opencode/plugin`, and the OpenCode adapter’s import of `@opencode/plugin` is type-only. The manifest has no `dependencies`, `optionalDependencies`, or `engines` field. [3] [10]

### Runtime requirements and caveats

Verified requirements are:

- An OpenCode **V2** host that supports the V2 plugin `id`/`setup(ctx)` API and TypeScript ESM plugin loading. Official V2 docs state that local `.ts`/`.js` plugins and package plugins are supported. [5] [6]
- An ESM-capable host: the package sets `type: "module"` and uses `.ts` imports with explicit extensions. [3] [8]
- No runtime npm package dependency is declared by the repository. The README and installer intentionally copy source and load TypeScript directly. [2]
- For repository development checks, the CI workflow uses Node `22` and states that the smoke test needs Node’s built-in TypeScript type stripping from **Node 22.18** onward. The current sandbox had Node `22.13.0`: after `npm ci`, `npm run typecheck` passed, but `npm run smoke` failed with `ERR_UNKNOWN_FILE_EXTENSION` for `server.ts`. This is a local test-runtime mismatch, not evidence that the OpenCode V2 loader lacks the required TypeScript support. [13]
- The package itself declares no Node/Bun engine range. Therefore do not infer a precise minimum runtime beyond the host and the repository’s documented/tested assumptions.

## Documented configuration options

The README table documents the first 12 options. The repository’s authoritative `options.json` and `src/core/config.ts` add four more options, so the complete current set is 16 keys. Configuration layers are merged key-by-key, with the installed `options.json` first, user-level `~/.config/opencode/mega-skillstate.json` next, and the plugin-entry `options` object most specific last. Unknown keys and invalid value types are rejected rather than silently ignored. [2] [9] [14]

| Option | Default | Meaning / documented behavior |
|---|---:|---|
| `enabled` | `true` | Run the context/state pass. |
| `min` | `4` | Minimum session turns before the superseded prefix may collapse. |
| `keepRecentTurns` | `4` | Number of recent turns kept verbatim. |
| `collapseOlder` | `true` | Collapse the older superseded prefix into Σ. |
| `protectFirstUserMessage` | `true` | Never drop the first user instruction. |
| `allowSubagentSessions` | `false` | Also transform a subagent’s own session. |
| `seedFromTools` | `true` | Keep the deterministic Σ floor current from recent tool activity. |
| `trackTools` | `["read", "edit", "write", "patch", "glob", "shell"]` | Tool names used by the deterministic seed. |
| `nudgeWhenStale` | `true` | Remind the model to commit Σ when stale. |
| `staleAfter` | `8` | Steps since the last instruction before the reminder is eligible. |
| `manualCommand` | `true` | Register `/skillstate`. |
| `debug` | `false` | Log each transform decision. |
| `foldPatchInputs` | `true` | Replace old absorbed `skill_state` patch bodies with a marker during collapse; the live turn is not changed. |
| `maxResultChars` | `4000` | Cap old tool-result values; `0` disables this cap. |
| `sigmaCondenseChars` | `400` | Fold long findings to head/tail when Σ exceeds the warning threshold; `0` disables the fold. |
| `sigmaWarnTokens` | `16000` | Show the Σ size warning and gate long-finding condensation; `0` disables both. |

The state model itself uses fields such as `objective`, `plan`, `done`, `findings`, `files`, `decisions`, `errors_tried`, `working`, `open`, and `step`. The README also documents the `skill_state` model tool, `mega_state` message, `/skillstate`, and `/skillstate now`. [2]

Example V2 per-entry options:

```jsonc
{
  "plugins": [
    {
      "package": "github:megablue/mega-skillstate#4aa74bd96fbea502e5efcc92994839c01b34c38f",
      "options": {
        "keepRecentTurns": 6,
        "maxResultChars": 6000,
        "sigmaCondenseChars": 800,
        "debug": false
      }
    }
  ]
}
```

For a directory install, edit the copied `options.json` or the user file. The README explicitly says a bare discovery-directory install receives no host entry options, which is why the package-level and user-level files matter. [2] [14]

## Strongest evidence-based customization plan

1. **Pin before customizing.** Use the full Git SHA above. Do not track `main`, and do not invent an npm version because there is no npm publication and no Git tag. Record the SHA in the manifest and in the local verification notes.
2. **Start with options, not a fork.** Keep the safety defaults `protectFirstUserMessage: true`, `collapseOlder: true`, and `foldPatchInputs: true`. Tune `keepRecentTurns` upward for a tool-heavy workflow; tune `maxResultChars` and `sigmaCondenseChars` only after observing payload size; keep `sigmaWarnTokens` as the pressure signal. Set `allowSubagentSessions: true` only if child-session compression is explicitly desired. Keep `debug: false` in normal use.
3. **Use the plugin’s own telemetry surfaces.** Exercise `/skillstate` and `/skillstate now`, confirm the `mega_state` message and `skill_state` tool appear, and inspect debug output in a test profile before enabling aggressive thresholds. The plugin promises safe turn-boundary cuts and no split tool-call/tool-result pair; verify that behavior with a real V2 session.
4. **Validate the installed artifact, not only a workspace.** Run `opencode plugin list`, `opencode plugin check`, and a clean test project. Confirm that the configured source is the pinned Git SHA, then test normal requests, a tool-result-heavy request, compaction, restart persistence, and a child session. Official V2 guidance specifically recommends testing the installed package rather than only a linked workspace. [5] [7]
5. **Fork only for behavior outside the schema.** If custom state fields, collapse policy, or host hooks are needed beyond the 16 options, fork the repository and preserve `server.ts` plus the default `{ id, setup }` V2 export. Add/update the repository’s typecheck and smoke fixtures, publish or pin the fork by full Git SHA, and keep the plugin ID stable unless intentional coexistence is required. Do not “port” it to `@opencode-ai/plugin`; that would move it toward V1 rather than customize the verified V2 adapter.

## Verification checklist

- [x] Repository identity, README, package manifest, and source entrypoint inspected.
- [x] Exact package version `0.3.0` verified from `package.json` and lockfile.
- [x] npm registry checked directly: exact package name returns `404 Not Found`.
- [x] Latest `main` full SHA recorded: `4aa74bd96fbea502e5efcc92994839c01b34c38f`.
- [x] No Git tags returned by the authoritative tags endpoint.
- [x] V2 source check: `@opencode/plugin` type import and default `{ id, setup }` export.
- [x] V1 check: no `@opencode-ai/plugin` in the OpenCode adapter; separate Pi adapter explicitly kept distinct.
- [x] `npm ci` and `npm run typecheck` passed locally.
- [ ] `npm run smoke` passed in this sandbox: **not passed**, because Node `22.13.0` does not provide the repository CI’s Node `22.18+` TypeScript type stripping needed to import `server.ts` directly.
- [ ] `opencode plugin add` install exercised against a live OpenCode V2 process: not available in this sandbox; treat the official Git syntax plus repository installer as the evidence-backed plan and perform this final host-level check before production.

## Warnings / uncertainty

- **Do not mark this as npm-installable.** `mega-skillstate@0.3.0` is not available from npm; the `0.3.0` number is a private repository package version.
- The repository’s own README documents copy installation from a checked-out repository. The pinned `opencode plugin add` Git command is derived from the official OpenCode V2 Git-package syntax, but host-level execution was not performed here.
- The repository HEAD commit is unsigned and GitHub reports no tags. Pinning the full SHA improves reproducibility but is not a signed release attestation.
- The package has unconstrained `*` Pi peer dependencies and no `engines` field. Do not turn these into a false OpenCode runtime minimum. They are evidence that the repo also contains a Pi adapter.
- README and `options.json` were slightly out of sync: four current options (`foldPatchInputs`, `maxResultChars`, `sigmaCondenseChars`, `sigmaWarnTokens`) are in the authoritative file/source but absent from the README’s visible option table. Treat the source schema as current and validate unknown keys strictly.
- The README says to restart after install/code changes. Follow that even if a particular OpenCode build hot-reloads configuration directories.

## References

[1]: https://github.com/megablue/mega-skillstate "Official mega-skillstate repository"
[2]: https://raw.githubusercontent.com/megablue/mega-skillstate/main/README.md "Official mega-skillstate README"
[3]: https://raw.githubusercontent.com/megablue/mega-skillstate/main/package.json "Official mega-skillstate package.json"
[4]: https://registry.npmjs.org/mega-skillstate "npm registry metadata for mega-skillstate"
[5]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin configuration and installation documentation"
[6]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin build documentation"
[7]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1-to-V2 migration guidance"
[8]: https://raw.githubusercontent.com/megablue/mega-skillstate/main/server.ts "Official mega-skillstate server entrypoint"
[9]: https://raw.githubusercontent.com/megablue/mega-skillstate/main/package-lock.json "Official mega-skillstate lockfile"
[10]: https://raw.githubusercontent.com/megablue/mega-skillstate/main/src/adapters/opencode/index.ts "Official mega-skillstate OpenCode adapter"
[11]: https://api.github.com/repos/megablue/mega-skillstate/commits/main "GitHub API latest main commit for mega-skillstate"
[12]: https://api.github.com/repos/megablue/mega-skillstate/tags "GitHub API tags for mega-skillstate"
[13]: https://raw.githubusercontent.com/megablue/mega-skillstate/main/.github/workflows/ci.yml "Official mega-skillstate CI workflow"
[14]: https://raw.githubusercontent.com/megablue/mega-skillstate/main/src/core/config.ts "Official mega-skillstate configuration schema and precedence"
