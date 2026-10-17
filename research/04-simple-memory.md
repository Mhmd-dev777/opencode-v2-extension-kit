# `knikolov/opencode-plugin-simple-memory` — OpenCode V2 compatibility report

**الحالة / Status:** **Verified V2-capable published package, with a repository-name ambiguity.** The exact GitHub slug requested by the manifest (`knikolov/opencode-plugin-simple-memory`) is not currently an authoritative repository endpoint (GitHub API returns 404). However, the scoped npm package `@knikolov/opencode-plugin-simple-memory` exists, its current `latest` dist-tag is `2.0.0`, and the published package contains a real OpenCode V2 entrypoint. The package metadata points to `cnicolov/opencode-plugin-simple-memory`; that GitHub URL currently resolves to the `ApplauseLab/opencode-plugin-simple-memory` repository. Do not silently treat the original `github:knikolov/...` source as the install target.

## Verified identity and safe installation

- **Requested identifier:** `knikolov/opencode-plugin-simple-memory`.
- **Authoritative installable package:** `@knikolov/opencode-plugin-simple-memory`.
- **Exact safe install specification:** `@knikolov/opencode-plugin-simple-memory@2.0.0`.
- **OpenCode CLI command:**

  ```sh
  opencode plugin add '@knikolov/opencode-plugin-simple-memory@2.0.0'
  ```

  OpenCode V2 documents `opencode plugin add <npm-name>@<version>` and supports scoped npm packages. An exact version is safer than the package's moving `latest` tag; OpenCode also documents that exact npm versions remain pinned.

- **Equivalent V2 project configuration:**

  ```json
  {
    "$schema": "https://opencode.ai/config.json",
    "plugins": ["@knikolov/opencode-plugin-simple-memory@2.0.0"]
  }
  ```

  The plugin README shows the same package without a version, but the exact pin above is the reproducible choice for this kit. If options are needed, use the V2 object form shown below.

The npm registry metadata is the strongest package-identity evidence: it names the package, reports `2.0.0` as `latest`, gives the `2.0.0` tarball and integrity/signature metadata, and records the repository/homepage fields. The package archive was inspected rather than relying on a search snippet.

## Package versions and dependency metadata

The registry currently lists these published versions: `1.0.0`, `1.0.1`, `1.0.2`, `1.0.3`, `1.0.4`, `1.1.0`, `1.1.1`, and `2.0.0`; `latest` is `2.0.0` [1]. The package manifest inside the `2.0.0` tarball verifies:

```json
{
  "name": "@knikolov/opencode-plugin-simple-memory",
  "version": "2.0.0",
  "type": "module",
  "module": "index.ts",
  "exports": { ".": "./index.ts" },
  "dependencies": {
    "@opencode-ai/plugin": "^1.18.29",
    "@opencode/plugin": "^2.0.14"
  },
  "peerDependencies": { "typescript": "^5" },
  "devDependencies": { "@types/bun": "latest" }
}
```

There is **no `engines` field** in `2.0.0`, so the package does not publish a numeric minimum Node or Bun version. The two OpenCode packages are ordinary dependencies, not peer dependencies; a consumer should not need to add them manually. The only declared peer dependency is `typescript@^5`.

The older package history is relevant to compatibility: `1.0.0` declared `@opencode-ai/plugin` `^1.0.153`, while `1.0.3`/`1.1.1` still used the V1 package family. The `2.0.0` release adds the V2 dependency `@opencode/plugin@^2.0.14` while retaining `@opencode-ai/plugin@^1.18.29` for its shared/V1 implementation.

## Is a real V2 plugin entrypoint present?

**Yes, in the published `2.0.0` archive.** The package exports `./index.ts`; that file default-exports `MemoryPlugin` from `src/index.ts`. The source contains:

```ts
import { Plugin } from "@opencode/plugin"

export const MemoryPlugin = {
  ...Plugin.define({
    id: "knikolov.simple-memory",
    async setup(ctx) {
      // registers the nine memory tools and V2 session hooks
    },
  }),
  server,
}

export default MemoryPlugin
```

This matches the official V2 plugin contract: import `Plugin` from `@opencode/plugin`, expose a default definition with an `id`, and provide `setup(ctx)`. The source registers V2 tools through `ctx.tool.transform(...)` and V2 session hooks through `ctx.session.hook("prompt", ...)` and `ctx.session.hook("context", ...)`.

The package also deliberately includes a V1 path. `server()` is typed from `PluginModule` imported from `@opencode-ai/plugin` and supplies the legacy `tool`, `chat.message`, and `experimental.chat.system.transform` hooks. This is a **V1 indicator and compatibility path**, not evidence that V2 is absent. The README explicitly documents V2 `setup()` and V1 `server()` from the same default export. The official V2 documentation describes this same dual-export pattern and says V2 reads `id`/`setup()` while ignoring `server()` [2].

## Runtime and environment requirements

Verified or strongly implied requirements are:

1. **OpenCode V2 plugin loading:** use the V2 `plugins` array and, when passing options, the object form `{ "package": ..., "options": ... }`.
2. **Bun runtime APIs in the implementation:** the published source directly uses `Bun.Glob`, `Bun.file`, and `Bun.write`, in addition to Node built-ins such as `node:fs/promises` and `node:path`. Therefore Bun-compatible plugin execution is a practical runtime requirement. The package does not declare a Bun version floor, so no minimum Bun version should be guessed.
3. **TypeScript `^5` peer:** this is the sole declared peer dependency and is relevant to local type-check/build workflows. It is not a published runtime-engine declaration.
4. **No declared Node engine:** `2.0.0` contains no `engines` field. Do not claim a Node minimum from the package metadata.
5. **Filesystem access:** memories are stored under `<project>/.opencode/memory/` as daily `YYYY-MM-DD.logfmt` files; deletion/update audit lines go to `.opencode/memory/deletions.logfmt`.
6. **Restart after configuration changes:** the README says plugin configuration is loaded at startup; restart OpenCode after changing the plugin entry or options.

## Documented tools and configuration options

The README documents nine tools: `memory_remember`, `memory_recall`, `memory_update`, `memory_forget`, `memory_list`, `memory_export`, `memory_import`, `memory_compact`, and `memory_context`. Manual tools remain available when automatic behavior is disabled.

The documented V2 options are:

- `autoLoad` — default `false`; injects a compact relevant-memory block using the latest user message as the search query.
- `autoSave` — default `false`; saves only explicit requests such as `remember that I prefer minimal diffs`; it does not save arbitrary conversation content.
- `autoHookTimeoutMs` — default `100`; bounds automatic memory work and fails open after the timeout.
- `contextLimit` — default `5`; maximum memories in the automatic context block.
- `contextMaxChars` — default `1200`; character budget for that block.
- `contextMinScore` — default `1` when a query exists; raises or lowers the relevance threshold.
- `autoSaveScope` — default `"user"`; default scope for automatic explicit saves unless type inference supplies a more specific interpretation.

The documented V2 object form is:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": [
    {
      "package": "@knikolov/opencode-plugin-simple-memory@2.0.0",
      "options": {
        "autoLoad": true,
        "autoSave": true,
        "autoHookTimeoutMs": 100,
        "contextLimit": 5,
        "contextMaxChars": 1200,
        "contextMinScore": 1,
        "autoSaveScope": "user"
      }
    }
  ]
}
```

The README also documents richer **tool arguments** (not plugin options), including recall filters `scope`, `type`, `query`, `limit`, `tags`, `since`, `until`, and `match`; export/import formats `jsonl`, `json`, and `logfmt`; and `memory_compact`'s `dryRun`. These should not be placed in the plugin `options` object unless the upstream package later documents them as such.

## Strongest evidence-based customization plan

1. **Pin and baseline first.** Install `@knikolov/opencode-plugin-simple-memory@2.0.0` and keep automatic behavior off (`autoLoad: false`, `autoSave: false`) until manual memory tools and the `.opencode/memory/` files are verified in the target project.
2. **Use the supported object-form options, not undocumented keys.** For a conservative automatic rollout, enable `autoLoad` only, retain the documented timeout, and tune only `contextLimit`, `contextMaxChars`, and `contextMinScore` against observed context quality. This changes retrieval volume and relevance without changing storage format.
3. **Enable `autoSave` only where explicit-memory capture is desired.** It is intentionally conservative and recognizes explicit `remember ...` requests. Keep `autoSaveScope: "user"` for user-level preferences, or choose a documented scope appropriate to the project; do not assume it captures arbitrary conversation text.
4. **For code-level customization, use the documented local checkout path.** Fork/clone the currently published source repository, run `bun install`, `bun test`, and `bun run typecheck`, then point V2 at `file:///absolute/path/to/opencode-plugin-simple-memory` in the object form. Preserve the default export, `id: "knikolov.simple-memory"`, `Plugin.define(...)`, and `setup(ctx)` contract. Changes to storage, matching, tool schemas, or hook behavior should be covered by tests before replacing the pinned package.
5. **Keep V1 and V2 paths separate if maintaining a fork.** The source intentionally shares runtime logic but has separate V2 registrations and V1 `server()` hooks. A V2-only modification should be made in `setup`/V2 hooks; changing only `server()` will not customize V2 behavior. This follows the official V2 guidance that V1 hooks are not translated into V2 hooks automatically.

This plan is evidence-based because every option above is documented by the package, and the source confirms where the V2 behavior is actually registered. No additional environment variables, config files, storage backends, or option names were inferred.

## Warnings and unresolved points

- **Repository slug mismatch:** `https://github.com/knikolov/opencode-plugin-simple-memory` is not a current GitHub repository endpoint. The npm package metadata instead points to `https://github.com/cnicolov/opencode-plugin-simple-memory`, which currently resolves to `ApplauseLab/opencode-plugin-simple-memory`. Treat the npm package and its tarball as the authoritative install artifact; keep the original GitHub manifest source marked as ambiguous rather than rewriting it as a verified Git repository source without a policy decision.
- **V1 marker remains present:** `@opencode-ai/plugin` appears in the `2.0.0` dependencies and source imports because the package keeps the V1 `server()` path. V2 compatibility is nevertheless verified by the separate `@opencode/plugin` import and `Plugin.define({ id, setup })` entrypoint.
- **Transitive ranges are not fully pinned:** the plugin itself is pinned at `2.0.0`, but its dependencies use caret ranges (`@opencode/plugin@^2.0.14` and `@opencode-ai/plugin@^1.18.29`). If a fully reproducible environment is required, lock the resolved dependency tree in the consuming installation and test against the exact OpenCode V2 build.
- **Runtime floor is unspecified:** no Bun or Node version is declared. Because the source uses Bun globals, test the exact target OpenCode/Bun runtime; do not claim that a Node-only runtime is supported.
- **No remote installation test was performed in this research pass:** the entrypoint and metadata were inspected from the published tarball and authoritative docs. The final kit should run `opencode plugin check`/startup validation in the target environment before enabling automatic hooks.

## References

[1]: https://registry.npmjs.org/@knikolov%2fopencode-plugin-simple-memory/2.0.0 "npm registry metadata for @knikolov/opencode-plugin-simple-memory 2.0.0"
[2]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin build documentation"
[3]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin configuration and CLI documentation"
[4]: https://github.com/ApplauseLab/opencode-plugin-simple-memory "Current GitHub repository resolved by the package's cnicolov repository URL"
[5]: https://github.com/knikolov/opencode-plugin-simple-memory "Requested GitHub repository slug (not currently found)"
[6]: https://registry.npmjs.org/@knikolov/opencode-plugin-simple-memory/-/opencode-plugin-simple-memory-2.0.0.tgz "Published @knikolov/opencode-plugin-simple-memory 2.0.0 tarball inspected for source and package.json"
