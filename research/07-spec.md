# opencode-spec — V2 extension research / بحث امتداد V2

## Identity and disposition / الهوية والقرار

- **Requested item:** `opencode-spec`.
- **Repository resolved from the supplied manifest:** `github:devcxl/opencode-spec`.
- **Authoritative published package name:** `@devcxl/opencode-spec` (scoped). The unscoped npm name `opencode-spec` is not the package identified by the repository or npm metadata.
- **Status:** **V2 source exists, but no verified published V2 package exists.** The current `master` source contains a real V2 entrypoint, while the latest npm/release package is still V1. Do not mark the npm package as V2-safe.
- **Recommended manifest posture:** keep this item **needs-review / source-build required**, rather than enabling `@devcxl/opencode-spec@0.2.0`.

This distinction matters because the supplied manifest names the GitHub repository, not an npm version. The current repository `master` package is version `1.0.0` and depends on `@opencode/plugin` `2.0.22` [3]. However, npm currently reports `@devcxl/opencode-spec` `0.2.0` as latest [7] [8], and that published version depends on `@opencode-ai/plugin` `^1.3.7` [7] [9].

## Real V2 plugin entrypoint / مدخل V2 الحقيقي

**Verified on current `master` (commit `74723f567967c6c68805e8b7eb93f2df5c1c0ce5`, dated 2026-10-09):**

1. `src/index.ts` explicitly says that OpenCode V2 requires a default export defined by `Plugin.define({ id, setup })`, and re-exports the default from `./plugin.js` [4].
2. `src/plugin.ts` imports `Plugin` from **`@opencode/plugin`**, not `@opencode-ai/plugin`, and default-exports:

   ```ts
   Plugin.define({
     id: "opencode-spec",
     setup: createOpencodeSpec(packageRoot),
   })
   ```

   [5]
3. The current repository package manifest exposes `./dist/index.js` through `main` and `exports`, is ESM (`"type": "module"`), and declares the V2 runtime dependency `"@opencode/plugin": "2.0.22"` [3].

This is a genuine V2 entrypoint, not a V1 compatibility object. OpenCode's V2 documentation defines the expected default export as `Plugin.define({ id, setup })` and says V2 uses `@opencode/plugin`; its migration guide says V1 implementations do not run in V2 and identifies `@opencode-ai/plugin` as the V1 import [12] [13].

### Important release mismatch / فرق الإصدار

The latest published npm/release artifact is **not** this V2 source:

- npm metadata: latest `0.2.0`, dependency `@opencode-ai/plugin: ^1.3.7`, no `peerDependencies`, no `engines` [7].
- Git tag `v0.2.0` points to commit `b78f07fca299e3bc07e03fb4b65514bc4e77096a` [15]. Its `src/index.ts` default-exports `{ id: "opencode-spec", server: OpencodeSpec }` [10], and its `package.json` depends on `@opencode-ai/plugin` `^1.3.7` [9]. That is a V1 indicator.
- The current `master` V2 package manifest reports version `1.0.0`, but the npm registry metadata does **not** list a published `1.0.0` version [3] [7]. The repository's visible releases/tags stop at `v0.2.0` [14] [15].

Therefore, the V2 entrypoint is **verified in source only, not in the current published npm package**.

## Exact safe installation specification and command / التثبيت الآمن

### What must not be used for V2

Do **not** use either of these as a V2 install:

```text
@devcxl/opencode-spec@latest
@devcxl/opencode-spec@0.2.0
```

They resolve to the published V1 package. Do not claim `@devcxl/opencode-spec@1.0.0` is installable from npm; the registry metadata does not show it.

A bare Git install such as `github:devcxl/opencode-spec#74723f567967c6c68805e8b7eb93f2df5c1c0ce5` is a useful source pin, but it should **not** be treated as sufficient by itself: the repository tree contains TypeScript source and the package points at `dist/index.js`; the current `package.json` has no `prepare`, `postinstall`, or install-time build script [3] [4]. Build the pinned checkout before loading it.

### Recommended reproducible V2 specification

Use the exact current V2 source commit:

```text
github:devcxl/opencode-spec#74723f567967c6c68805e8b7eb93f2df5c1c0ce5
```

The safest reproducible command sequence is a pinned local source build:

```sh
mkdir -p vendor
git clone https://github.com/devcxl/opencode-spec.git vendor/opencode-spec
git -C vendor/opencode-spec checkout --detach 74723f567967c6c68805e8b7eb93f2df5c1c0ce5
npm ci --prefix vendor/opencode-spec
npm run build --prefix vendor/opencode-spec
```

Then configure the built local package in the project-root `opencode.json` using the V2 object form:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": [
    {
      "package": "./vendor/opencode-spec",
      "options": { "directory": "openspec" }
    }
  ]
}
```

The relative package path resolves from the config file. This follows OpenCode V2's documented local-package and object-with-options syntax [11] [12]. If the repository is placed elsewhere, replace the relative path with the corresponding local path. This plan is stronger than an unpinned `master` install because it fixes the exact source commit and builds the `dist/` entrypoint deterministically.

## Versions, dependencies, and runtime requirements / الإصدارات والمتطلبات

### Current V2 source (`master` at the pinned commit)

- Package name: `@devcxl/opencode-spec` [3].
- Repository package version: `1.0.0` [3]. This is a source-manifest version, not a published npm version.
- Module format: ESM (`"type": "module"`) [3].
- Entrypoint: `main: ./dist/index.js`; package exports `.` and `./server` to `./dist/index.js` [3].
- Direct runtime dependencies: `@opencode/plugin` **exactly `2.0.22`** and `yaml` **`^2.8.3`** [3].
- `peerDependencies`: **none declared** [3].
- `engines`: **none declared** [3].
- Dev-only dependencies include `typescript ^5.9.3`, `vitest ^3.2.4`, and `@types/node ^24.6.0` [3].

### Runtime requirements actually documented

- OpenCode V2 is required [1] [2].
- The shell used by OpenCode must be able to execute `node` directly, because the skills run bundled JavaScript reference scripts through Node [1] [2].
- The plugin does not declare a Node version in `engines`; do not invent a minimum Node version. The repository lockfile contains transitive packages with their own engine constraints, including a Node `>=18` constraint for `@ai-sdk/provider`, but that is not an explicit `opencode-spec` support contract [3]. Verify with the exact OpenCode V2 build and the deployed Node runtime.
- A source checkout must be built (`npm ci` then `npm run build`) before loading because the package entrypoint is `dist/index.js` and the source manifest has no install-time build hook [3].

## Documented configuration options / الخيارات الموثقة

The current V2 README and implementation document one plugin option:

- `directory`: a **project-relative** output directory for OpenSpec data. Default: `openspec` at the project root [1] [6]. V2 config form:

  ```json
  {
    "plugins": [
      {
        "package": "@devcxl/opencode-spec",
        "options": { "directory": "docs" }
      }
    ]
  }
  ```

- `OPENSPEC_DIR`: environment-variable override. The implementation resolves precedence as **`OPENSPEC_DIR` > `options.directory` > `openspec`** [6]. It trims the value and rejects absolute paths, paths containing `..` segments, and NUL characters [6].
- No other public plugin options are documented in the README, usage guide, or reference guide. The command/skill set is runtime-registered; the plugin does not document a switch to selectively disable individual commands or skills [1] [2] [16].

The current source registers 12 skills through `ctx.skill.transform`, 12 slash commands through `ctx.command.transform`, and a V2 `ctx.session.hook("context", ...)` bootstrap prompt [6] [16]. Existing commands with the same name are preserved, so user-defined commands take precedence [6].

## Strongest evidence-based customization plan / خطة التخصيص الموصى بها

1. **Pin and build the V2 source.** Use the full commit above, not `latest`, `0.2.0`, or an unpinned `master` branch. Keep the clone/build steps in project setup or CI so the generated `dist/` is reproducible.
2. **Use the V2 `plugins` key and object form.** Configure `{"package":"./vendor/opencode-spec","options":{"directory":"openspec"}}`; do not use the V1 `plugin` key or V1 tuple form. OpenCode's migration documentation explicitly requires `plugin` → `plugins` and tuple → object for V2 [13].
3. **Customize only `directory` unless source changes are intended.** Choose a simple project-relative path such as `docs/openspec` if the repository wants planning artifacts under documentation. The source rejects absolute/traversal paths, so do not use `/tmp`, `../shared`, or a path with `..` segments [6].
4. **Prefer the per-plugin option for multi-workspace correctness.** Use `OPENSPEC_DIR` only when a process-wide override is deliberate; it outranks the config option. The current implementation explicitly avoids mutating `process.env` internally so different workspaces do not share a directory setting [6].
5. **Treat the runtime-injected commands/skills as the customization surface.** Start with `/opsx-propose`, then `/opsx-apply`, then `/opsx-archive`; use `/opsx-explore` when clarification is needed. Use the 8 extension commands/skills when their documented workflow is wanted [1] [2] [16]. For deeper behavior changes, fork or patch the pinned source rather than guessing undocumented options.

## Verification steps / خطوات التحقق

1. Confirm the OpenCode process shell can resolve Node: `command -v node && node --version`.
2. Confirm the checkout is exactly the intended commit: `git -C vendor/opencode-spec rev-parse HEAD` must print `74723f567967c6c68805e8b7eb93f2df5c1c0ce5`.
3. Run `npm ci --prefix vendor/opencode-spec` and `npm run build --prefix vendor/opencode-spec`; ensure `vendor/opencode-spec/dist/index.js` exists.
4. Inspect the built default export before launching OpenCode, for example:

   ```sh
   node --input-type=module -e "import('./vendor/opencode-spec/dist/index.js').then(m => console.log(m.default.id, typeof m.default.setup))"
   ```

   Expected output is `opencode-spec function`.
5. Launch OpenCode V2 with the local `plugins` object and confirm the active plugin list/diagnostics show the plugin ID `opencode-spec`.
6. Confirm `/opsx-propose`, `/opsx-explore`, `/opsx-apply`, and `/opsx-archive` are available, then run a disposable workflow and verify artifacts land under the configured relative directory.
7. Verify that no integration files are written into the project's `.opencode/` directory, consistent with the documented runtime injection behavior [1] [16].
8. If testing precedence, set `OPENSPEC_DIR` to a safe relative path and verify it wins over `options.directory`; remove it afterward.
9. As a negative control, inspect npm metadata before any package install and verify that `@devcxl/opencode-spec@0.2.0` imports `@opencode-ai/plugin`; reject it for V2.

## Warnings and uncertainty / التحذيرات

- **Published V2 artifact unresolved:** source V2 compatibility is verified, but no published npm version or release tag containing the current V2 `@opencode/plugin` entrypoint was found. The current master package version `1.0.0` is not listed by npm [3] [7] [14] [15].
- **V1 indicator is conclusive for the published package:** `@opencode-ai/plugin` appears in npm `0.2.0` and the `v0.2.0` source uses `{ id, server }` [7] [9] [10]. OpenCode V2 documentation warns that V1 implementations do not run in V2 [13].
- **No peer dependency claim:** neither current V2 source `package.json` nor npm `0.2.0` declares `peerDependencies`; `@opencode/plugin` is a regular dependency in the current V2 source, not a peer dependency [3] [7].
- **No Node minimum claim:** there is no `engines` field. Only the direct `node` executable requirement is documented [1] [2] [3].
- **Source-build caveat:** the exact Git commit is reproducible, but it is not a published prebuilt V2 package. Loading the local path before running the build will fail or be incomplete because the declared entrypoint is `dist/index.js` [3].

## References

[1]: https://raw.githubusercontent.com/devcxl/opencode-spec/master/README.en.md "opencode-spec current English README"
[2]: https://github.com/devcxl/opencode-spec/blob/master/docs/en/usage.md "opencode-spec English usage guide"
[3]: https://raw.githubusercontent.com/devcxl/opencode-spec/74723f567967c6c68805e8b7eb93f2df5c1c0ce5/package.json "opencode-spec V2 source package.json at pinned commit"
[4]: https://raw.githubusercontent.com/devcxl/opencode-spec/master/src/index.ts "opencode-spec current V2 source entrypoint"
[5]: https://raw.githubusercontent.com/devcxl/opencode-spec/master/src/plugin.ts "opencode-spec current V2 Plugin.define implementation"
[6]: https://raw.githubusercontent.com/devcxl/opencode-spec/master/src/plugin/server.ts "opencode-spec current V2 setup and option handling"
[7]: https://registry.npmjs.org/@devcxl%2fopencode-spec "npm registry metadata for @devcxl/opencode-spec"
[8]: https://www.npmjs.com/package/@devcxl/opencode-spec "npm package page for @devcxl/opencode-spec"
[9]: https://raw.githubusercontent.com/devcxl/opencode-spec/v0.2.0/package.json "opencode-spec released v0.2.0 package.json"
[10]: https://raw.githubusercontent.com/devcxl/opencode-spec/v0.2.0/src/index.ts "opencode-spec released v0.2.0 V1 entrypoint"
[11]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin loading and installation documentation"
[12]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin development documentation"
[13]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1-to-V2 migration guide"
[14]: https://api.github.com/repos/devcxl/opencode-spec/commits?per_page=10 "opencode-spec current commit history"
[15]: https://api.github.com/repos/devcxl/opencode-spec/tags?per_page=20 "opencode-spec repository tags"
[16]: https://raw.githubusercontent.com/devcxl/opencode-spec/master/docs/en/reference.md "opencode-spec English reference guide"
