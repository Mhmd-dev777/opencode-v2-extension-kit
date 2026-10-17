# `lansya/opencode-plugin-claude-memory` — OpenCode V2 Extension Review

**Status: unresolved for the requested GitHub identity; the matching scoped npm package is verified but V1-only. Do not enable it as an OpenCode V2 plugin.**

## Identity resolution and source quality

The requested string looks like a GitHub owner/repository reference: `lansya/opencode-plugin-claude-memory`. The authoritative GitHub repository API returns `404 Not Found`, and the `lansya` user lookup also returns `404`.[1] A GitHub repository search for `opencode-plugin-claude-memory` returns 45 results, but no exact `lansya/opencode-plugin-claude-memory`; it returns different repositories such as `kuitos/opencode-claude-memory` and `krishna2206/opencode-claude-memory`.[2] Those similarly named repositories are not interchangeable with the requested item and were not treated as this extension.

NPM search does expose a likely name-related candidate, **`@lansya/opencode-plugin-claude-memory`**, currently at `1.0.7`. The candidate is identifiable by the `lansya` scope and the same package-name suffix, but its npm metadata has no `repository`, `homepage`, or `bugs` field, so there is no authoritative public repository link proving that it is the missing GitHub repository.[3] This report therefore records the package facts while keeping the requested GitHub identity **unresolved** rather than guessing that the two identities are the same.

## Verified npm package facts

The scoped npm candidate is:

```text
@lansya/opencode-plugin-claude-memory@1.0.7
```

The registry `latest` dist-tag is `1.0.7`. The registry lists these published versions: `0.1.0`, `0.1.1`, `0.1.2`, `0.1.3`, `0.1.5`, `0.1.6`, `1.0.0`, `1.0.1`, `1.0.2`, `1.0.3`, `1.0.4`, `1.0.5`, `1.0.6`, and `1.0.7`.[3] The exact `1.0.7` registry record identifies it as an ES module (`"type": "module"`), licensed MIT, with package exports:

```json
{
  ".": "./src/index.ts",
  "./server": "./src/server.ts",
  "./core": "./src/core.ts"
}
```

The immutable registry metadata for `1.0.7` reports tarball integrity `sha512-m9sDy5qUM5pvMij8burYHEUUF0SsQnrS5R58oPXEJMjPscOGWbFWsOmQ3CjR45UIyxYBJOBYcxyArz26DIbDEg==` and SHA-1 `36b7be166e95e25c7992c56d86f966777d0cc7fc`.[3]

### Dependencies and peer dependencies

The package has **no declared `peerDependencies`**. Its runtime dependency is instead a normal dependency:

```json
"dependencies": {
  "@opencode-ai/plugin": "^1.4.3"
}
```

Its development-only metadata includes TypeScript, Node 22 type/config packages, and `@types/bun`; these are not declared runtime engines.[3] The package does not declare a Node engine. It does declare this OpenCode engine range:

```json
"engines": {
  "opencode": ">=1.4.3 <2"
}
```

That range is an explicit blocker for OpenCode V2, whose major version is 2.

### Runtime requirements observed in the published source

The package is ESM and its source directly uses Bun APIs such as `Bun.file(...)` and `Bun.write(...)` for memory, state, transcript, and command files.[4] Therefore a usable V1 deployment needs an OpenCode runtime that provides the Bun APIs expected by this source. The package's `@types/bun` entry is dev-only, but the direct `Bun.*` calls are runtime behavior. The source also requires write access under the project directory for `.opencode/memory/` and, on first load, `.opencode/commands/dream.md`.[4]

The package does not declare a Node version requirement. The registry's `nodeVersion: 22.14.0` is publication metadata, not an `engines.node` constraint, so it must not be reported as a user runtime requirement.

## Entrypoint and V2 compatibility

There is **no real OpenCode V2 plugin entrypoint** in the published package. The package root exports `./src/index.ts`; that file only re-exports `server` and the default export from `./server.ts`.[4] The default export in `server.ts` is:

```ts
export default {
  id: "@lansya/opencode-plugin-claude-memory",
  server,
}
```

It has `server`, but no `setup` and no `effect`.[4] The implementation imports V1 types from `@opencode-ai/plugin` (`PluginInput` and `PluginOptions`) and implements a V1 `server(input, raw?)` function that returns V1 hook keys, including `experimental.chat.system.transform` and `event`.[4]

This is decisive under the official V2 migration rules: V1 code imports `@opencode-ai/plugin`; V2 code imports `@opencode/plugin`, default-exports a definition with a stable `id` and `setup(ctx)`, and registers hooks through the V2 context. The official documentation explicitly warns that V1 implementations do not run in V2; renaming `plugin` to `plugins` or changing only configuration is insufficient.[5] The current package therefore has **V1 compatibility only**, despite its package description saying “Repo-local memory v2 plugin”; that “v2” describes the memory-file format/version in the implementation, not OpenCode major-version compatibility.

### V1 indicators found

- `@opencode-ai/plugin` is the package dependency and the source import. This is the V1 indicator requested for review.[3][4]
- The OpenCode engine range is `>=1.4.3 <2`.[3]
- The entrypoint exports `{ id, server }`, not `Plugin.define({ id, setup })`.[4]
- The README uses the legacy singular `"plugin"` configuration key and a package/options tuple.[6]
- The implementation returns V1 hook names, including `experimental.chat.system.transform` and `event`.[4]

## Safe install specification and command

There is **no V2-safe install specification** for this item. The exact npm candidate specification is:

```text
@lansya/opencode-plugin-claude-memory@1.0.7
```

The pin is safer than `@latest` for reproducibility, but it is only a **V1-only candidate** and must not be enabled in an OpenCode V2 manifest. If a V1-compatible environment is being tested separately, the exact package-install command is:

```sh
opencode plugin add '@lansya/opencode-plugin-claude-memory@1.0.7'
```

This command installs the package; it does not make the package V2-compatible. OpenCode's V2 CLI supports exact npm package versions, but the installed package must still expose the V2 API.[7] For V2, the safe action is **do not add this package** until a ported package or fork has been independently published and verified.

For the legacy package's own documented configuration, the README says OpenCode loads its `./server` export and shows the old form:

```json
{
  "plugin": ["@lansya/opencode-plugin-claude-memory@latest"]
}
```

The README also shows tuple-style options under the same V1 `plugin` key.[6] Those snippets are not valid evidence of V2 compatibility; official V2 configuration uses `plugins`, and options use an object with `package` and `options`.[5][7]

## Documented configuration options

The published README documents exactly two plugin options:

- `once: true`: summarize each session at most once / prevent a session from being consolidated more than once.
- `debug: true`: retain the helper consolidation session for inspection instead of deleting it after completion.

The source parses only these two booleans from the raw V1 options object (`value.once === true` and `value.debug === true`).[4] No documented option for memory path, decay interval, injection size, model, or command name was found in the package manifest, README, or source option parser. The package writes to fixed paths under `.opencode/memory/` and creates `.opencode/commands/dream.md`.[4][6]

The README documents the storage layout and behavior: `.opencode/memory/MEMORY.md`, `.opencode/memory/topics/*.md`, helper state in `.state.json`, pending transcript snapshots under `.pending/`, a seven-day decay interval, and injection truncation at 200 lines / 25 KB.[6] These are behavior constants, not configurable options.

## Strongest evidence-based customization plan

Because the published package is V1-only, the strongest plan is a **source port**, not a config-only workaround:

1. **Resolve identity before implementation.** Treat the GitHub request and scoped npm package as separate until the publisher provides a canonical repository link. Do not substitute `kuitos/opencode-claude-memory` or another similarly named repository.
2. **Fork or obtain source permission, then preserve the core.** Keep the tested memory parser/materializer, decay rules, storage format, `/dream` command generation, and `once`/`debug` semantics from `src/core.ts` and `src/server.ts`. The core memory format is independent enough to reuse, but its file operations and session lifecycle must be re-tested under V2.
3. **Replace the entrypoint and dependency.** Change the import from `@opencode-ai/plugin` to `@opencode/plugin`, update the dependency to a version compatible with the target OpenCode V2 release, and export `Plugin.define({ id: "@lansya/opencode-plugin-claude-memory", async setup(ctx) { ... } })` (or a new stable fork ID). Do not retain only `{ id, server }`.
4. **Map V1 context to V2 context.** Replace `input.directory` with `ctx.location.directory`; replace the V1 `input.client.*` calls with the corresponding V2 domains such as `ctx.session.*`; read `once` and `debug` from `ctx.options`. The official migration table provides these mappings, but each `ctx.session` call must be compiled and tested against the exact V2 release.[5]
5. **Port the hooks explicitly.** The V1 `experimental.chat.system.transform` memory injection should become a V2 `ctx.session.hook("context", ...)` handler that edits the V2 `event.system` shape. The V1 `event` loop for `session.created`, `session.idle`, and `session.deleted` should become a `ctx.event.subscribe()` task with an `AbortController` and a cleanup function. The official guide specifically maps the system transform to the V2 context hook and V1 events to `ctx.event.subscribe()`.[5]
6. **Handle helper sessions and permissions deliberately.** The current package creates a helper session and supplies restrictive rules for `.opencode/memory/.work/<run>/OPS.md`. Recreate those calls using the V2 session/permission APIs and verify that helper sessions cannot recursively trigger memory injection or write outside the intended work file. Do not assume V1 `input.client.session.create/prompt` shapes are source-compatible.
7. **Keep V2 configuration native.** The ported package should be configured with V2's `plugins` array, for example `{ "package": "<ported-package>@<exact-version>", "options": { "once": true, "debug": false } }`, not the README's V1 `plugin` tuple.[5][7]
8. **Verify before manifest promotion.** Build/type-check against the target V2 package, install the published artifact rather than only a workspace link, start OpenCode V2, confirm the plugin appears with its stable ID, confirm memory injection, session idle/create/delete transitions, helper-session cleanup, `/dream` creation, and both options. Only after these checks should a new V2 package/version be added to the manifest.

A local compatibility shim that merely adds `setup` while leaving the V1 hooks and `@opencode-ai/plugin` dependency is not sufficient. The official migration guide says V1 implementations do not run in V2 and requires a real API port.[5]

## Findings for the parent manifest

- **Do not mark this item `v2-reviewed` or enable it.**
- Keep the requested GitHub source unresolved because the exact public repository is not available from authoritative GitHub endpoints.
- Record the npm candidate separately as `@lansya/opencode-plugin-claude-memory@1.0.7`, with a `v1-only` / `blocked-on-v2-port` note.
- `peerDependencies`: none declared. The critical compatibility dependency is a normal dependency on `@opencode-ai/plugin:^1.4.3`.
- No V2 install command should be executed as an enablement step. The exact CLI command above is only for an isolated V1 compatibility test.

## References

[1]: https://api.github.com/repos/lansya/opencode-plugin-claude-memory "GitHub repository API response for the requested repository"
[2]: https://api.github.com/search/repositories?q=opencode-plugin-claude-memory&per_page=100 "GitHub repository search for the requested name"
[3]: https://registry.npmjs.org/@lansya%2Fopencode-plugin-claude-memory "NPM registry metadata for the scoped candidate package"
[4]: https://registry.npmjs.org/@lansya/opencode-plugin-claude-memory/-/opencode-plugin-claude-memory-1.0.7.tgz "Published npm tarball inspected for package manifest and source entrypoint"
[5]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 plugin migration guide"
[6]: https://www.npmjs.com/package/@lansya/opencode-plugin-claude-memory "Official npm package page and published README"
[7]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin configuration and CLI documentation"
