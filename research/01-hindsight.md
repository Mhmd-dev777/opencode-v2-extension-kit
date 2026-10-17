# brycehamrick/opencode-v2-hindsight — OpenCode V2 extension research

**Research status:** Resolved with a package rename and a compatibility caveat. The original GitHub path and old npm package are real, but the old npm package is deprecated. The maintained package is `@brycehamrick/opencode-hindsight@0.2.2`. The current published bundle contains a real OpenCode V2-shaped entrypoint (`default` export with `id` and `setup(ctx)`), but its manifest intentionally has no `@opencode/plugin` runtime dependency and still lists the V1-named `@opencode-ai/plugin` only as a development dependency. This is evidence for V2 compatibility by implementation shape, not a formal SDK peer-range guarantee.

**الخلاصة:** الاسم القديم قابل للتحقق لكنه deprecated/renamed. استخدم الحزمة المثبتة `@brycehamrick/opencode-hindsight@0.2.2`، وليس `@brycehamrick/opencode-v2-hindsight`. نقطة الدخول الحالية متوافقة شكلياً مع V2 (`id` و`setup`)؛ مع ذلك يجب اختبارها مع إصدار OpenCode V2 الفعلي لأن الحزمة لا تعلن `@opencode/plugin` كـ peer dependency.

## 1. Identity and rename resolution

The requested GitHub shorthand `brycehamrick/opencode-v2-hindsight` resolves to the repository now named **`brycehamrick/opencode-hindsight`**. The canonical repository page exposes `README.md`, `package.json`, `src/`, tests, and a `main` branch. Its current package manifest names the package `@brycehamrick/opencode-hindsight`, version `0.2.2`, and points its repository field to the renamed GitHub URL. [1] [3]

The old scoped npm package **does exist**, but npm marks every published `0.1.x` release as deprecated with the author message: “Renamed to `@brycehamrick/opencode-hindsight` — update the `package` field in your opencode config.” Its latest old version is `0.1.3`. [7] [8] The unscoped npm name `opencode-v2-hindsight` returned 404 during direct registry verification; do not install that unscoped name.

The maintained README explicitly says that `@brycehamrick/opencode-v2-hindsight` was the previous package name and instructs users to update configuration to `@brycehamrick/opencode-hindsight`. [2]

## 2. Safe install specification and command

### Verified safe spec

```text
@brycehamrick/opencode-hindsight@0.2.2
```

The npm registry identifies `0.2.2` as the `latest` dist-tag for the renamed package. The registry records versions `0.2.0`, `0.2.1`, and `0.2.2` (plus a staging placeholder), with the published `0.2.2` tarball at:

```text
https://registry.npmjs.org/@brycehamrick/opencode-hindsight/-/opencode-hindsight-0.2.2.tgz
```

The exact package metadata has `main: dist/index.js`, ESM `type: module`, and an `exports` map exposing `./dist/index.js` plus declarations. [3] [4]

### Recommended exact OpenCode command

```sh
opencode plugin add @brycehamrick/opencode-hindsight@0.2.2
```

This uses the official OpenCode V2 package-plugin installer and pins the known published version. OpenCode’s official plugin documentation explicitly supports exact npm package versions and gives the same `opencode plugin add <name>@<version>` form. [9]

The repository README also documents:

```sh
npm install -g @brycehamrick/opencode-hindsight
```

That command is a package-install instruction from the extension author, but the OpenCode CLI command above is safer for OpenCode plugin lifecycle management because it records the package in OpenCode’s plugin configuration and uses an exact version. [2] [9]

The corresponding V2 config entry should use the maintained name, preferably pinned as well:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": [
    {
      "package": "@brycehamrick/opencode-hindsight@0.2.2",
      "options": {
        "dynamicBankId": true,
        "dynamicBankGranularity": ["agent", "gitProject"]
      }
    }
  ]
}
```

Whether an already-installed package is referenced as a bare name or exact version depends on how it was added; the manifest recommendation should retain the exact safe spec above. Do **not** use the deprecated old package as the normal installation target.

## 3. V2 entrypoint verification

### Current maintained package: verified V2-shaped entrypoint

The current source entrypoint at `src/index.ts` default-exports an object with:

```ts
{
  id: "hindsight",
  async setup(ctx) { /* initialize state, tools, hooks */ }
}
```

It returns a cleanup function, reads `ctx.options`, uses `ctx.storage`, registers tools and hooks, and initializes the memory manager. [5]

The published `0.2.2` tarball was also unpacked and checked directly. Its `dist/index.js` ends with a default export of exactly this shape:

```js
var index_default = {
  id: "hindsight",
  async setup(ctx) { /* ... */ }
};
export { index_default as default };
```

The bundle’s imports are Node built-ins (`child_process`, `fs`, `os`, `path`, `url`) rather than an OpenCode SDK package. This confirms that the real published entrypoint is not merely a README claim. [4]

OpenCode’s official V2 documentation defines a package/local plugin as a default export with a stable `id` and `setup(ctx)`; V2 reads this export and registers hooks/tools through the context. [10] The current Hindsight package therefore has the required V2 entrypoint shape.

### Old `0.1.3` package: also V2-shaped, but deprecated and riskier

The deprecated old tarball `@brycehamrick/opencode-v2-hindsight@0.1.3` also contains a `Plugin.define({ id, setup })` default export in `dist/index.js`. However, its manifest has runtime dependencies on `@opencode-ai/plugin: "beta"` and `@vectorize-io/hindsight-client: "^0.5.2"`. [7] Direct tarball inspection confirmed the old bundle imports `@opencode-ai/plugin` at runtime. It should not be selected when the maintained package is available.

## 4. V1 indicator check: `@opencode-ai/plugin` vs `@opencode/plugin`

The official V2 migration guide says that V1 implementations import `@opencode-ai/plugin`, while V2 examples import `@opencode/plugin` and default-export a V2 definition with `id` and `setup(ctx)`. It also warns that a V1 implementation does not run in V2 merely because its config name or file was changed. [11]

The current Hindsight `package.json` contains:

- `dependencies: {}`
- no `peerDependencies` field
- `devDependencies["@opencode-ai/plugin"] = "beta"`
- `devDependencies["@vectorize-io/hindsight-client"] = "^0.5.2"`

It does **not** declare `@opencode/plugin`, either as a dependency or peer dependency. [3] The source explicitly explains that it intentionally does not import `@opencode-ai/plugin` at runtime; it defines the minimal `{ id, setup }` contract locally so the bundle avoids SDK/host version skew. [5]

**Evidence-based interpretation:**

1. The V1-named package is a real warning signal in the manifest, and the absence of the official V2 SDK package means there is no declared compatibility range to enforce during installation.
2. It is not, by itself, proof that the maintained package is V1: the current source and published bundle expose the official V2-required `id`/`setup` shape, and the bundle has no runtime OpenCode SDK import.
3. The author’s README says the current package requires OpenCode V2.0+ and was built/tested against `opencode v2.0.27`. [2]
4. Treat compatibility as **verified by entrypoint and bundled-runtime inspection, with runtime testing still required for the exact OpenCode build**. Do not upgrade the status to unconditional compatibility solely from the devDependency name.

## 5. Versions, dependencies, and runtime requirements

### Maintained package `@brycehamrick/opencode-hindsight@0.2.2`

- **Package version:** `0.2.2`; npm `latest` at the time of research. [4]
- **Module format:** ESM (`"type": "module"`). [3]
- **Entrypoint:** `dist/index.js`; type declarations at `dist/index.d.ts`; export map exposes the package root. [3] [4]
- **Runtime dependencies:** none in npm `dependencies`; the published bundle includes the Hindsight client code and does not require an OpenCode SDK package at runtime. [3] [4]
- **Peer dependencies:** none declared. [3] [4]
- **Development-only dependencies:** `@opencode-ai/plugin: "beta"`, `@vectorize-io/hindsight-client: "^0.5.2"`, TypeScript, tsup, Vitest, and Node types. [3]
- **Node requirement:** `node >=22`. [3] [4]
- **OpenCode requirement claimed by the README:** OpenCode v2.0 or newer; tested against `opencode v2.0.27`; not compatible with OpenCode V1. [2]
- **External service:** Hindsight Cloud is the default endpoint (`https://api.hindsight.vectorize.io`), or configure a self-hosted Hindsight URL. A token is needed for hosted use; the README says an unauthenticated self-hosted instance can leave the token unset. [2] [6]
- **Operational requirement:** restart OpenCode after config changes if the running process does not reload the affected configuration automatically. [2]

### Deprecated package `@brycehamrick/opencode-v2-hindsight@0.1.3`

- **Latest old version:** `0.1.3`; all four old versions (`0.1.0`–`0.1.3`) are deprecated. [7] [8]
- **Node requirement:** `node >=22`. [7]
- **Runtime dependencies:** `@opencode-ai/plugin: "beta"` and `@vectorize-io/hindsight-client: "^0.5.2"`. [7]
- **Reason not to use:** npm’s author deprecation message explicitly directs users to the renamed package. [7] [8]

## 6. Documented configuration options

The README documents these options and defaults. The source configuration type and defaults were checked against the README. [2] [6]

- `hindsightApiUrl` — `"https://api.hindsight.vectorize.io"`; Hindsight API base URL.
- `hindsightApiToken` — `null`; token, with `null` intended for self-hosted unauthenticated use.
- `bankId` — `null`; static bank ID.
- `bankIdPrefix` — `""`; prefix for derived bank IDs.
- `dynamicBankId` — `false`; derive a bank ID from contextual fields.
- `dynamicBankGranularity` — `["agent", "project"]`; accepted fields include `agent`, `project`, `gitProject`, `channel`, and `user`.
- `agentName` — `"opencode"`; fallback agent name.
- `bankMission` — `""`; mission used when creating a bank.
- `retainMission` — `null`; retain mission for the bank.
- `autoRecall` — `true`; recall memories for user messages.
- `autoRetain` — `true`; automatically retain conversation content.
- `retainMode` — `"facts"`; accepted values `"facts"`, `"transcript"`, or `"none"`.
- `coreMemoryMaxTokens` — `256`.
- `perMessageRecallMaxTokens` — `512`.
- `compactionRecallMaxTokens` — `512`.
- `extractionMaxTokens` — `256`.
- `recallBudget` — `"mid"`; accepted values `"low"`, `"mid"`, or `"high"`.
- `recallContextTurns` — `2`.
- `recallMaxQueryChars` — `800`.
- `recallPromptPreamble` — built-in explanatory preamble.
- `recallTypes` — `["world", "experience"]`.
- `recallTags` — `[]`.
- `recallTagsMatch` — `"any"`; accepted values `"any"`, `"all"`, `"any_strict"`, or `"all_strict"`.
- `retainContext` — `"opencode"`.
- `retainEveryNTurns` — `3`.
- `retainOverlapTurns` — `2`.
- `retainTags` — `[]`.
- `retainMetadata` — `{}`.
- `stripSecrets` — `true`.
- `stripBase64` — `true`.
- `maxRetainedMessageLength` — `4000`.
- `debug` — `false`.

The source also documents configuration precedence: built-in defaults, then `~/.hindsight/opencode.json`, then the plugin’s `options` object in `opencode.jsonc`, then environment variables. [2] [6]

The documented environment overrides include `HINDSIGHT_API_URL`, `HINDSIGHT_API_TOKEN`, `HINDSIGHT_BANK_ID`, `HINDSIGHT_AGENT_NAME`, `HINDSIGHT_AUTO_RECALL`, `HINDSIGHT_AUTO_RETAIN`, `HINDSIGHT_RETAIN_MODE`, `HINDSIGHT_RECALL_BUDGET`, `HINDSIGHT_RECALL_MAX_QUERY_CHARS`, `HINDSIGHT_RECALL_CONTEXT_TURNS`, `HINDSIGHT_RETAIN_EVERY_N_TURNS`, `HINDSIGHT_RETAIN_OVERLAP_TURNS`, `HINDSIGHT_RETAIN_CONTEXT`, `HINDSIGHT_DYNAMIC_BANK_ID`, `HINDSIGHT_BANK_MISSION`, `HINDSIGHT_BANK_ID_PREFIX`, `HINDSIGHT_CORE_MEMORY_MAX_TOKENS`, `HINDSIGHT_PER_MESSAGE_RECALL_MAX_TOKENS`, `HINDSIGHT_COMPACTION_RECALL_MAX_TOKENS`, `HINDSIGHT_EXTRACTION_MAX_TOKENS`, `HINDSIGHT_STRIP_SECRETS`, `HINDSIGHT_STRIP_BASE64`, `HINDSIGHT_MAX_RETAINED_MESSAGE_LENGTH`, `HINDSIGHT_RECALL_TAGS`, and `HINDSIGHT_RETAIN_TAGS`. [6]

The README documents four explicit tools: `hindsight_retain`, `hindsight_recall`, `hindsight_reflect`, and `hindsight_forget`. [2]

## 7. Strongest evidence-based customization plan

1. **Use the maintained package and pin it.** Add `@brycehamrick/opencode-hindsight@0.2.2` with `opencode plugin add`. Do not fork or configure the deprecated `@brycehamrick/opencode-v2-hindsight@0.1.3` unless reproducing a historical install is the explicit goal.

2. **Start with configuration, not source edits.** The official V2 plugin API passes object-form plugin options through `ctx.options`; the Hindsight implementation already exposes the options above. [10] Put a conservative global baseline in `opencode.jsonc` and use project-level options only for intentional differences.

   ```jsonc
   {
     "$schema": "https://opencode.ai/config.json",
     "plugins": [
       {
         "package": "@brycehamrick/opencode-hindsight@0.2.2",
         "options": {
           "dynamicBankId": true,
           "dynamicBankGranularity": ["agent", "gitProject"],
           "retainMode": "facts",
           "stripSecrets": true,
           "stripBase64": true,
           "debug": false
         }
       }
     ]
   }
   ```

   This follows the repository’s examples and keeps agent/project memory separated. Use a static `bankId` only when intentionally sharing one memory bank across the relevant scope. [2]

3. **Keep secrets out of committed configuration.** For Hindsight Cloud, provide `HINDSIGHT_API_TOKEN` in the process environment and optionally set `HINDSIGHT_API_URL`; for self-hosting, set the URL and leave the token unset when the service is unauthenticated. Environment variables have the highest precedence in the implementation. [2] [6]

4. **Preserve safety and budget defaults initially.** Keep `retainMode: "facts"`, `stripSecrets: true`, `stripBase64: true`, and the default recall/retention token caps until behavior is observed. Increase `perMessageRecallMaxTokens`, `compactionRecallMaxTokens`, or `coreMemoryMaxTokens` only when the memory quality need is clear; these values directly affect injected context size. [2] [6]

5. **If custom code is required, fork the canonical renamed repository and preserve the V2 contract.** Keep the default export as `{ id: "hindsight", setup(ctx) }`, use `ctx.options` for new options, use `ctx.storage` for durable plugin state, and return cleanup from `setup`. Do not convert the implementation to a V1 function or import `@opencode-ai/plugin` as a runtime dependency. This plan follows both the actual source design and the official V2 migration rules. [5] [10] [11]

6. **Preserve the bundle’s runtime isolation unless there is a strong reason not to.** The current source deliberately avoids importing the SDK at runtime and bundles the Hindsight client. If modifying the build, keep ESM output, Node 22 targeting, and the `dist/index.js` export so host/SDK version skew is not reintroduced. [3] [5]

7. **Validate against the exact OpenCode build before enabling broadly.** Run `opencode plugin list`, `opencode plugin check`, and a clean test project. Confirm that the plugin appears with ID `hindsight`, that all four tools register, that an explicit retain/recall round trip works, that per-agent/project bank IDs are separated as intended, and that cleanup/reload works. Official V2 guidance recommends testing the installed package rather than only a workspace-linked copy. [9] [10] [11]

## 8. Verification steps for the manifest owner

1. Resolve the requested GitHub path to `https://github.com/brycehamrick/opencode-hindsight`.
2. Use source/package identity `@brycehamrick/opencode-hindsight@0.2.2`.
3. Install with `opencode plugin add @brycehamrick/opencode-hindsight@0.2.2`.
4. Confirm `node --version` is `>=22`.
5. Configure `HINDSIGHT_API_TOKEN` and, if needed, `HINDSIGHT_API_URL` without committing credentials.
6. Confirm the config uses a V2 `plugins` entry with an object `{ "package": ..., "options": ... }`.
7. Run `opencode plugin list` and confirm plugin ID `hindsight`.
8. Exercise `hindsight_retain`, `hindsight_recall`, `hindsight_reflect`, and `hindsight_forget`.
9. Test an isolated agent/project bank configuration before enabling automatic retention for sensitive repositories.
10. Record the result against the exact OpenCode V2 version used; no peer dependency currently enforces a compatible SDK range.

## 9. Final decision

**Enablement recommendation:** `approved-with-runtime-test` for OpenCode V2 only, using the pinned renamed package.

**Do not enable:** the deprecated `@brycehamrick/opencode-v2-hindsight` package as the normal target, the unscoped `opencode-v2-hindsight` name, or any OpenCode V1 configuration.

**Reason:** the maintained package has a real V2 `id`/`setup` entrypoint and a Node-22 ESM bundle with no runtime SDK dependency, but it has no formal `@opencode/plugin` peer range and retains a V1-named SDK only in development metadata. That combination is strong evidence of an intentional V2 host-contract implementation, but exact-version runtime verification remains necessary.

## References

[1]: https://github.com/brycehamrick/opencode-hindsight "Canonical brycehamrick OpenCode Hindsight repository"
[2]: https://raw.githubusercontent.com/brycehamrick/opencode-hindsight/main/README.md "Maintained Hindsight plugin README"
[3]: https://raw.githubusercontent.com/brycehamrick/opencode-hindsight/main/package.json "Maintained Hindsight package.json"
[4]: https://registry.npmjs.org/%40brycehamrick%2Fopencode-hindsight "npm registry metadata for maintained Hindsight package"
[5]: https://raw.githubusercontent.com/brycehamrick/opencode-hindsight/main/src/index.ts "Maintained Hindsight V2 source entrypoint"
[6]: https://raw.githubusercontent.com/brycehamrick/opencode-hindsight/main/src/config.ts "Maintained Hindsight configuration source"
[7]: https://registry.npmjs.org/%40brycehamrick%2Fopencode-v2-hindsight "npm registry metadata for deprecated old Hindsight package"
[8]: https://www.npmjs.com/package/%40brycehamrick/opencode-v2-hindsight "Deprecated old Hindsight npm package page"
[9]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin installation and management documentation"
[10]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin development documentation"
[11]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1-plugin migration guide"
