# opencode-morph-plugin — OpenCode V2 compatibility research

**Research status:** authoritative sources found, but the requested extension is **not a verified OpenCode V2 plugin**. The public package is the scoped package `@morphllm/opencode-morph-plugin`; the unscoped name `opencode-morph-plugin` is not published on npm.

## Identity and resolution

The name in the manifest is ambiguous as an npm identifier. The official repository is [`morphllm/opencode-morph-plugin`](https://github.com/morphllm/opencode-morph-plugin), and its README identifies the installable package as `@morphllm/opencode-morph-plugin`.[1] A direct npm lookup for the unscoped name `opencode-morph-plugin` returns `E404 Not Found`; therefore the unscoped name must not be used as an install target.

The authoritative package metadata reports:

- **Package:** `@morphllm/opencode-morph-plugin`
- **Latest/dist-tag:** `2.0.17`
- **Pinned safe package specification:** `@morphllm/opencode-morph-plugin@2.0.17`
- **Module format:** ESM (`"type": "module"`)
- **Published entrypoint:** `dist/index.js`, exported as `"."`
- **Repository:** `https://github.com/morphllm/opencode-morph-plugin`

The package JSON in the repository also says `2.0.17`, while the repository's checked-in lockfile still says `2.0.16`. For installation, use the npm registry's exact published version `2.0.17`, not the stale lockfile root version.[2] [4]

## Install specification and command

For OpenCode's package-plugin installer, the exact pinned command is:

```sh
opencode plugin add @morphllm/opencode-morph-plugin@2.0.17
```

This command follows the official V2 CLI syntax for exact npm package versions.[6] It is a **reproducible audit/install command**, not a recommendation to enable this package in V2: the compatibility evidence below shows that the current package uses the V1 API.

The upstream README instead documents the unpinned legacy workflow:

```sh
cd ~/.config/opencode
bun i @morphllm/opencode-morph-plugin
```

and a V1-style `"plugin"` configuration key. That upstream workflow should not be copied unchanged into a V2 configuration.[1] OpenCode V2 uses `"plugins"` and supports exact package entries such as `@morphllm/opencode-morph-plugin@2.0.17`.[6]

## Entrypoint and V2 determination

**Finding: no real V2 plugin entrypoint is present in the authoritative source.**

The repository entrypoint imports the V1 package and helper:

```ts
import { type Plugin, tool } from "@opencode-ai/plugin";
```

It then defines a V1-style async plugin function:

```ts
const MorphPlugin: Plugin = async ({ directory, worktree, client }, options) => {
  // returns a hooks/tools object
}

export default MorphPlugin;
```

The source does not import `Plugin` from `@opencode/plugin`, does not call `Plugin.define(...)`, does not provide a V2 `id`, and does not expose `setup(ctx)`. The default export is therefore a V1 function entrypoint, despite the source comment saying “OpenCode Morph Plugin v2.”[3]

The package manifest confirms the V1 indicator:

```json
"dependencies": {
  "@opencode-ai/plugin": "1.18.29",
  "@opencode-ai/sdk": "^1.18.29"
}
```

There is no `@opencode/plugin` dependency.[2] The official V2 migration guide explicitly says that V1 implementations do not run in V2, and that a V2 plugin must replace the V1 import with `@opencode/plugin` and export a definition with a stable `id` and `setup(ctx)`.[7] The V2 build guide shows the same `Plugin.define({ id, setup })` contract and recommends depending on an API version compatible with the targeted OpenCode release.[6]

**Compatibility verdict:** `v2_compatibility = no — V1 implementation; requires a source port before V2 use.` The package's own semantic version `2.0.17` is a release number for the Morph package; it is not evidence of OpenCode V2 API compatibility.

## Package versions and dependencies

The current repository package manifest and npm metadata verify these direct dependencies for `2.0.17`:[2] [4]

- `@morphllm/morphsdk` **exactly `0.2.173`**
- `@opencode-ai/plugin` **exactly `1.18.29`** — V1 plugin API indicator
- `@opencode-ai/sdk` **`^1.18.29`** — V1-era SDK range

The package itself declares **no `peerDependencies`** and no `engines` field.[2] Relevant transitive metadata is:

- `@opencode-ai/plugin@1.18.29` declares peers `@opentui/core >=0.4.5`, `@opentui/solid >=0.4.5`, and `@opentui/keymap >=0.4.5`.[8]
- `@morphllm/morphsdk@0.2.173` declares optional peers `ai >=5.0.0`, `zod >=3.23.0`, `@anthropic-ai/sdk >=0.25.0`, and `@google/generative-ai >=0.21.0`; its engine declaration is `node >=18`.[9]

Because the plugin package has no own `engines` declaration, **Node >=18 is an evidence-based transitive runtime floor**, not a package-level guarantee. The README uses Bun for installation and development, but no package manifest engine requires Bun. The runtime also needs a Morph API key and network access to Morph services; public-repository search may additionally call GitHub.[1] [3]

## Documented configuration

The README documents one plugin option and the following environment variables. These are verified upstream options, not inferred settings.[1] [3]

### Credential input

- `MORPH_API_KEY` — required Morph API key.
- V1-style plugin option `apiKey` — fallback for desktop users who cannot set environment variables. The README/source state that `MORPH_API_KEY` takes precedence when both are set.

The README's example uses the legacy tuple form:

```json
{
  "plugin": [["@morphllm/opencode-morph-plugin", { "apiKey": "sk-..." }]]
}
```

For a true V2 port, the equivalent configuration shape must be converted to the V2 object form:

```jsonc
{
  "plugins": [
    {
      "package": "@morphllm/opencode-morph-plugin",
      "options": { "apiKey": "sk-..." }
    }
  ]
}
```

That V2 object syntax is documented by OpenCode, but the current Morph package does not implement the V2 context/entrypoint needed to make the conversion sufficient by itself.[6] [7]

### Feature and compaction controls

- `MORPH_COMPACT_TOKEN_LIMIT` — fixed token threshold; overrides the automatic threshold.
- `MORPH_COMPACT_CONTEXT_THRESHOLD` — fraction of the model context window; default `0.7` when a fixed token limit is not set.
- `MORPH_COMPACT_PRESERVE_RECENT` — recent messages to preserve; default `1`.
- `MORPH_COMPACT_RATIO` — target compression ratio; default `0.3`, documented range `0.05–1.0`.
- `MORPH_COMPACT` — default `true`; set `false` to disable compaction.
- `MORPH_EDIT` — default `true`; set `false` to disable Fast Apply.
- `MORPH_WARPGREP` — default `true`; set `false` to disable local WarpGrep.
- `MORPH_WARPGREP_GITHUB` — default `true`; set `false` to disable public GitHub repository search.

The README also documents an `instructions/morph-tools.md` file and recommends registering it in the configuration's instruction list so the model knows when to use the Morph tools.[1]

## What the plugin provides

The upstream README documents four capabilities:

1. `morph_edit` — Morph Fast Apply for partial/lazy-marker edits.
2. `warpgrep_codebase_search` — agentic local codebase search.
3. `warpgrep_github_search` — public GitHub repository context search.
4. Context compaction through Morph hooks, with tool routing and compaction behavior that an MCP-only integration cannot provide.[1]

These descriptions are product behavior claims from the upstream README. They do not establish V2 compatibility; the current implementation wires them through the V1 returned-hook object.[1] [3]

## Strongest evidence-based customization plan

1. **Do not add this package as an enabled V2 plugin yet.** Keep the manifest entry `unverified` or mark it `needs-port`/`v1-only`; do not claim `v2-reviewed`. The package has a real, authoritative source, but the source is V1.
2. **If a V2 implementation is required, fork the official repository and port the entrypoint first.** Replace `@opencode-ai/plugin` with `@opencode/plugin`; export `Plugin.define({ id: "morph", async setup(ctx) { ... } })`; move initialization and registration into `setup`. This is the exact migration shape specified by OpenCode, not an inferred wrapper.[7]
3. **Port each returned V1 hook deliberately.** The current source uses `tool`, `tool.definition`, `tool.execute.after`, `experimental.chat.system.transform`, `experimental.chat.messages.transform`, and `experimental.session.compacting`. OpenCode's migration guide maps these to V2 tool transforms/hooks and session hooks such as `context` and `compaction`; do not mechanically rename strings because the callback/event shapes differ.[3] [7]
4. **Preserve the documented configuration contract during the port.** Read `ctx.options.apiKey` first only when no `MORPH_API_KEY` is present, retaining the documented environment-variable precedence. Keep the feature toggles as environment variables so existing deployments can control risk without changing config schema.[1] [3]
5. **Start conservative after the port:** keep Fast Apply and local WarpGrep enabled, set `MORPH_WARPGREP_GITHUB=false` unless public-repository search is needed, and initially set `MORPH_COMPACT=false` while validating V2 compaction hooks. Once compaction is proven, use an explicit token limit in staging or retain the documented `0.7` context threshold. This plan follows the package's own independent toggles and avoids silently enabling network search or unverified compaction behavior.
6. **Treat the instruction file as an optional behavior aid, not an API bridge.** Add the shipped `instructions/morph-tools.md` only after verifying that its path is available from the installed package and that its guidance matches the ported tool names. It cannot convert a V1 implementation into a V2 implementation.

## Verification steps

- Confirm the exact package resolves: `npm view @morphllm/opencode-morph-plugin@2.0.17 version`.
- Inspect the installed `package.json` and `dist/index.js`; verify the exact versions and the `@opencode-ai/plugin` import before enabling anything.
- For a V2 port, verify that the active plugin list contains a stable Morph ID and the package source, as recommended by the OpenCode migration guide.[7]
- With `MORPH_API_KEY` set, exercise `morph_edit`, `warpgrep_codebase_search`, and `warpgrep_github_search`; verify expected failures when each feature toggle is disabled.
- Test `apiKey` option fallback versus `MORPH_API_KEY` precedence in a clean project. Do not commit the key to `opencode.json`.
- Test compaction separately. The upstream README recommends checking `~/.local/share/opencode/log/` for `service=morph` entries and observing the compaction toast.[1]
- Reload/remove the plugin and confirm cleanup. OpenCode's V2 verification guidance requires testing registrations, options, persisted state, and cleanup with an installed package rather than only a workspace-linked copy.[6] [7]

## Warnings and unresolved points

- **Name ambiguity resolved:** `opencode-morph-plugin` (unscoped) is not an npm package. The authoritative target is `@morphllm/opencode-morph-plugin`.
- **V2 status is not verified:** the package has no `@opencode/plugin` dependency, no `Plugin.define`, no V2 `id`, and no `setup(ctx)`. Do not enable it in an OpenCode V2 manifest without a maintained port.
- **README configuration is V1:** it says `"plugin"` singular and shows a V1 tuple. V2 requires `"plugins"` and an object with `package` and `options`.[1] [6] [7]
- **Version-name trap:** package version `2.0.17` does not mean OpenCode V2 compatibility.
- **Runtime uncertainty:** the plugin itself omits `engines`; Node >=18 comes from the Morph SDK dependency. Bun is documented as a tool, not a declared runtime requirement.
- **Upstream README freshness:** its compaction section refers to “current OpenCode 1.14.x,” which reinforces that its documented integration targets the V1 ecosystem and should not be treated as V2 evidence.[1]
- **Do not infer support from the source comment “v2.”** Dependency identity, export shape, and the official OpenCode migration contract are stronger evidence.

## References

[1]: https://github.com/morphllm/opencode-morph-plugin "Official Morph OpenCode plugin repository README"
[2]: https://raw.githubusercontent.com/morphllm/opencode-morph-plugin/main/package.json "Official repository package.json"
[3]: https://raw.githubusercontent.com/morphllm/opencode-morph-plugin/main/index.ts "Official repository plugin entrypoint"
[4]: https://registry.npmjs.org/@morphllm%2fopencode-morph-plugin "npm registry metadata for the scoped package"
[5]: https://www.npmjs.com/package/@morphllm/opencode-morph-plugin "npm package page for the scoped package"
[6]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin installation and configuration documentation"
[7]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1-plugin migration documentation"
[8]: https://registry.npmjs.org/@opencode-ai%2fplugin/1.18.29 "npm registry metadata for the V1 plugin API dependency"
[9]: https://registry.npmjs.org/@morphllm%2fmorphsdk/0.2.173 "npm registry metadata for the Morph SDK dependency"
