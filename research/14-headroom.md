# `opencode-headroom` — OpenCode V2 Extension Research

**Research target:** the exact unscoped npm name `opencode-headroom` (not the distinct `headroom-opencode` package mentioned in Headroom Labs documentation).

**Decision:** **V2 blocked / V1-only.** The published package has a real OpenCode **V1** entrypoint, but no real OpenCode V2 entrypoint. Do not mark this package V2-compatible or enable it in a V2 manifest without a source port.

## 1. Identity and source resolution

The exact npm package exists and currently has one published version in the npm registry:

- Name: `opencode-headroom`
- Latest/dist-tag: `0.1.0`
- Published version: `0.1.0`
- npm registry git head: `7ef788bb1e90c874fd52f765e7ab423ab0d87e70`
- Repository recorded in npm metadata: `https://github.com/ngotrnghia1811/opencode-headroom.git`
- Author recorded by npm: `ngotrnghia1811`
- License: Apache-2.0

The npm registry metadata is authoritative for the installable unscoped package and declares `0.1.0` as `latest`.[1]

There is a material repository/package mismatch that must not be silently merged:

- The current repository README describes the project as `@ngotrnghia1811/opencode-headroom`, and the current repository `package.json` is version `0.1.6` with a **scoped** package name.[3] [4]
- The exact npm tarball for `opencode-headroom@0.1.0` has an unscoped package name, version `0.1.0`, and a different package manifest. Its included README says `src/index.ts` exports a `server` entrypoint.[1] [2]
- Therefore, use the npm package metadata/tarball for the exact requested item. Do not infer that current `master` version `0.1.6` is a safe replacement or that its additional options are present in the published unscoped package.

The Headroom Labs documentation refers to a different package, `headroom-opencode`, and must not be used as proof that `opencode-headroom` is V2-compatible.[5]

## 2. Package manifest and exact versions

The published `opencode-headroom@0.1.0` manifest contains:

```json
{
  "name": "opencode-headroom",
  "version": "0.1.0",
  "type": "module",
  "exports": {
    ".": "./src/index.ts",
    "./server": "./src/index.ts"
  },
  "peerDependencies": {
    "@opencode-ai/plugin": "*"
  },
  "dependencies": {
    "js-tiktoken": "^1.0.19"
  }
}
```

Evidence and implications:

- Exact package version: `0.1.0`.[1] [2]
- Runtime dependency: `js-tiktoken ^1.0.19`.[1] [2]
- Peer dependency: `@opencode-ai/plugin *`.[1] [2]
- No `engines` field is declared, so npm metadata does **not** establish a Node version requirement.[1] [2]
- The package exports TypeScript source directly (`./src/index.ts`); this is not evidence of V2 support by itself.[2]

The npm package's lock metadata resolves `@opencode-ai/plugin` to `1.17.0` in the repository development lockfile, but the published peer range is `*`; do not treat `1.17.0` as a package-level compatibility guarantee.[2]

## 3. Entrypoint and V2 compatibility check

### Published entrypoint: V1 only

The published tarball's `src/index.ts` contains this shape:

```ts
import type { Plugin } from "@opencode-ai/plugin"

export const server: Plugin = async (_input, options) => {
  // returns { tool: ..., "tool.execute.after": ..., ... }
}
```

The implementation returns a V1 object with:

- `tool.headroom_retrieve`
- `tool.headroom_stats`
- `experimental.chat.messages.transform`
- `tool.execute.after`
- `experimental.chat.system.transform`

It does **not** contain any of the following V2 markers:

- `import { Plugin } from "@opencode/plugin"`
- `export default Plugin.define(...)`
- a stable V2 `id`
- `setup(ctx)`
- `ctx.session.hook(...)`
- `ctx.tool.hook(...)` or a V2 tool transform

The published README explicitly labels `src/index.ts` as a “Plugin entrypoint (server export)”.[2] The source imports the V1 package name `@opencode-ai/plugin` and exports only the named `server` function.[2]

### Official V2 contract

OpenCode V2 requires a default export based on `Plugin.define`, with an `id` and `setup(ctx)`; published V2 plugins should depend on `@opencode/plugin`.[6] The V2 migration guide is explicit: “V1 plugin implementations do not run in V2”; renaming the config key or moving the file is insufficient.[7]

The exact V2 configuration key is `plugins`, not the V1 `plugin` key. Package entries may be strings or objects with `package` and `options`.[8]

### Compatibility conclusion

**No real V2 plugin entrypoint is present in `opencode-headroom@0.1.0`.** It is a V1 implementation. The peer dependency `@opencode-ai/plugin` is a direct V1 indicator, while the absence of `@opencode/plugin`, default export, `id`, and `setup` confirms that this is not a V2 package.

## 4. Safe install specification and command

### Safe, pinned package specification

```text
opencode-headroom@0.1.0
```

Pinning is required for reproducibility because the registry currently exposes `0.1.0` as `latest`, while the linked repository's current package has a different scoped identity and version.[1] [3] [4]

### Install command (V1 evaluation only)

```bash
npm install opencode-headroom@0.1.0
```

Equivalent Bun command:

```bash
bun add opencode-headroom@0.1.0
```

For a legacy V1 OpenCode configuration, the package README uses:

```json
{
  "plugin": ["opencode-headroom"]
}
```

Do **not** use that configuration as a V2 enablement recipe. For V2, OpenCode's documented form would be `plugins`, for example:

```jsonc
{
  "plugins": [
    {
      "package": "opencode-headroom@0.1.0",
      "options": {}
    }
  ]
}
```

However, the V2 loader will ignore this package's V1 `server` implementation, so the V2 configuration is intentionally **not a working install claim**.[6] [7] [8]

## 5. Peer dependencies and runtime requirements

### Verified peer/dependency requirements

- `@opencode-ai/plugin: *` — peer dependency in the published manifest; V1 API.[1] [2]
- `js-tiktoken: ^1.0.19` — runtime dependency used for token counting.[1] [2]
- Bun is required in practice: the published source imports `Database` from `bun:sqlite`.[2] The repository setup guide documents **Bun >=1.0**.[3]
- The repository setup guide documents OpenCode **>=0.4.0** for the legacy plugin system, including the V1 `plugin` config field.[3]
- A writable SQLite path is needed if `ccr_db_path` is configured. The default is an in-memory store.

### Important runtime caveat

The package has no `engines` field.[1] [2] Nevertheless, direct use of Node.js is not a safe assumption because `bun:sqlite` is a Bun-specific module. Treat the package as Bun/V1-only unless a separate compatibility test proves otherwise.

## 6. Documented configuration options for the exact published package

These are the options documented by the published package README and implemented by its `parseOptions` source. Defaults below are the published package's V1 defaults, not options copied from the newer scoped repository.[2]

- `enabled: boolean` — default `true`; master switch for compression.
- `min_tokens_to_compress: number` — default `200`; skip outputs below this token count.
- `live_zone_only: boolean` — default `true`; restrict compression to the latest user message and tool results/live zone.
- `real_time: boolean` — default `true`; enable `tool.execute.after` compression before tool output enters history.
- `cache_align: boolean` — default `true`; normalize dynamic system-prompt tokens for cache stability.
- `verbose: boolean` — default `false`; log compression events to stdout.
- `ccr_db_path: string` — default in-memory; path for persistent CCR storage.

The published README also documents two tools:

- `headroom_retrieve(hash)` — retrieve original content referenced by a `<<ccr:HASH>>` marker.
- `headroom_stats()` — return session compression statistics.[2]

The current scoped repository documents additional `compressors`, `compressor_params`, and `log_file` settings, but those are **not verified in the published unscoped `0.1.0` package** and must not be added to the manifest for this item.[3] [4]

## 7. Strongest evidence-based customization plan

There is no evidence-based option-only customization that makes the package run on V2. The strongest plan is a deliberate source port, preferably in a fork or a new package, with an explicit V2 package identity.

1. **Freeze the source baseline.** Fork or vendor the exact `opencode-headroom@0.1.0` source/tarball. Do not start from the current scoped `master` package without documenting the source/version change.
2. **Replace the API dependency and entrypoint.** Change the implementation to import `Plugin` from `@opencode/plugin` and default-export `Plugin.define({ id: "opencode.headroom", async setup(ctx) { ... } })`. Add a V2-compatible, release-pinned `@opencode/plugin` dependency.
3. **Port the tool-result hook.** Convert V1 `tool.execute.after` to `await ctx.tool.hook("execute.after", event => { ... })`. Adapt the callback from separate V1 `input/output` objects to the V2 mutable event shape, preserving fail-open behavior and CCR storage.
4. **Port both message/system transforms.** Convert `experimental.chat.messages.transform` and `experimental.chat.system.transform` to `ctx.session.hook("context", event => ...)`, editing `event.messages` and `event.system` only for the outgoing model call. The V2 migration guide maps both legacy hooks to this context hook.[7]
5. **Register tools through V2 APIs.** Replace the returned V1 `tool` map with V2 `ctx.tool.transform(...)` registration, preserving `headroom_retrieve` and `headroom_stats` schemas and the existing CCR/session state.
6. **Preserve options via `ctx.options`.** Keep the seven published option names as a compatibility layer, but read them from `ctx.options`. Use an absolute `ccr_db_path`; the source passes the path directly to `bun:sqlite`, so tilde expansion should not be assumed.
7. **Add a temporary dual-entrypoint only if V1 support is needed.** OpenCode's official migration guide permits one default-exported object containing both V2 `setup()` and V1 `server()`, but the implementations remain separate; adding `server` does not translate V1 hooks into V2.[6] [7]
8. **Test the installed artifact, not only a workspace checkout.** Verify V2 plugin discovery, ID/source in the active plugin list, option passing, `headroom_stats`, large tool-output compression, retrieval after a CCR marker, system/message transforms, reload cleanup, and Bun/runtime behavior. The official V2 documentation specifically recommends testing the installed package.[6] [7]

Recommended initial port options are conservative and mirror verified defaults:

```jsonc
{
  "plugins": [
    {
      "package": "<your-v2-fork>@<exact-version>",
      "options": {
        "enabled": true,
        "min_tokens_to_compress": 200,
        "live_zone_only": true,
        "real_time": true,
        "cache_align": true,
        "verbose": false,
        "ccr_db_path": "/absolute/path/to/opencode/headroom.db"
      }
    }
  ]
}
```

Do not substitute `opencode-headroom@0.1.0` for `<your-v2-fork>` until the port has a real default V2 export and passes the verification plan.

## 8. Verification steps

### For the current package (legacy V1 smoke test only)

1. Install the exact pin with `npm install opencode-headroom@0.1.0` under Bun-compatible OpenCode.
2. Configure the legacy `plugin` key with `opencode-headroom`.
3. Start an OpenCode session and call `headroom_stats`; it should return a JSON object with zeroed counters initially.
4. Produce a large tool output (for example, a large JSON file, search result, log, or diff), then call `headroom_stats` again; compression counters should increase when compression triggers.
5. Set `verbose: true` and confirm compression log output.
6. Confirm that `headroom_retrieve` can retrieve a stored CCR marker and that expired/in-memory entries fail open.

These checks validate V1 behavior only and do not establish V2 compatibility.[2] [3]

### For a future V2 port

1. Run `opencode plugin add <your-v2-fork>@<exact-version>` or configure the exact package object under `plugins`.
2. Confirm the plugin ID and source appear in the active plugin list.
3. Exercise the `ctx.tool.hook("execute.after")` path and both context edits (`event.messages`, `event.system`).
4. Exercise both tools, option parsing through `ctx.options`, CCR persistence, cleanup/reload, and fail-open behavior.
5. Test the installed published artifact under the target OpenCode V2 release, not just a linked workspace copy.[6] [7] [8]

## 9. Warnings for the manifest owner

- **Do not label `opencode-headroom@0.1.0` `v2-reviewed` or `v2-compatible`.** Evidence supports V1 only.
- The peer name `@opencode-ai/plugin` is a strong V1 indicator. V2 documentation uses `@opencode/plugin`.[2] [6] [7]
- The exact unscoped npm package and the current GitHub repository package are not the same manifest identity: unscoped `0.1.0` versus scoped `@ngotrnghia1811/opencode-headroom` `0.1.6`.[1] [3] [4]
- Do not import the Headroom Labs `headroom-opencode` native-plugin claims into this item. That is a different package and integration path.[5]
- No Node engine is declared, but `bun:sqlite` makes Node-only execution unsafe to assume.
- The published README documents `ccr_db_path` examples using `~`; the source passes the value directly to Bun SQLite, so an absolute path is safer.
- Options documented only in the newer scoped repository (`compressors`, `compressor_params`, `log_file`) are unverified for the published unscoped package and should not be manifested as supported.

## References

[1]: https://registry.npmjs.org/opencode-headroom "npm registry metadata for opencode-headroom"
[2]: https://registry.npmjs.org/opencode-headroom/-/opencode-headroom-0.1.0.tgz "published opencode-headroom 0.1.0 package tarball"
[3]: https://github.com/ngotrnghia1811/opencode-headroom/blob/master/README.md "opencode-headroom repository README"
[4]: https://github.com/ngotrnghia1811/opencode-headroom/blob/master/package.json "current repository package.json"
[5]: https://docs.headroomlabs.ai/docs/opencode "Headroom Labs OpenCode integration documentation"
[6]: https://opencode.ai/v2/docs/build/plugins "official OpenCode V2 plugin build documentation"
[7]: https://opencode.ai/v2/docs/build/plugins/migrate-v1/ "official OpenCode V2 V1-to-V2 migration guide"
[8]: https://opencode.ai/v2/docs/plugins "official OpenCode V2 plugin configuration and CLI documentation"
