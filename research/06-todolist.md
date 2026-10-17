# opencode-todolist — OpenCode V2 Extension Research

**Research status / حالة البحث:** **Verified as a V2 package plugin, with an explicit caveat that the package does not declare an `engines` runtime field.** The current manifest already records `opencode-todolist@0.6.1` and `v2-reviewed`; the evidence below supports that status.

## Identity and authoritative resolution

The unambiguous package is the public npm package **`opencode-todolist`**, maintained by `tiagoaiev` and linked to the official repository **`aiev/opencode-todolist`**. npm marks `0.6.1` as the `latest` dist-tag, and the exact version metadata identifies the same GitHub repository and package name. [1] [2]

- **Package:** `opencode-todolist`
- **Latest verified version:** `0.6.1`
- **License:** MIT
- **Repository:** <https://github.com/aiev/opencode-todolist>
- **Exact npm metadata:** <https://registry.npmjs.org/opencode-todolist/0.6.1>
- **Published artifact integrity:** npm reports SHA-512 integrity `sha512-KIFESOOr8BjvumY6u0EZhbGs84XVpqKk5LAkFuUspkFCRW1ziYmn6n4Yigfo9krCYymJbuWQejPq0DfhOZ60Zg==`. [1]

## V2 entrypoint: verified

A real V2 server plugin entrypoint is present. The repository root `index.ts` re-exports `./src/index.ts`. [6] The source then imports `Plugin` from **`@opencode/plugin`** and default-exports an object typed as `Plugin.Plugin` with:

```ts
const plugin: Plugin.Plugin = {
  id: "aiev.todolist",
  async setup(ctx) { /* tools, RPC, hooks, cleanup */ },
}

export default plugin
```

The setup implementation uses V2-style APIs including `ctx.tool.transform`, `ctx.storage`, `ctx.rpc.register`, `ctx.session.hook`, and a cleanup function. It registers `todowrite` and `todoread`, session context/compaction hooks, a `/todo` command, storage cleanup, and RPC-backed settings. [5]

This matches the official OpenCode V2 plugin model: a package plugin uses a default export with an `id` and `setup`, and V2's build guide shows the same `Plugin.define({ id, setup })` contract. [9] [10] The package does not use a V1-only `server()` export or a V1 hook-only function entrypoint.

There is also a separate, real V2 TUI entrypoint at the package export `./tui`: `tui/index.js` default-exports `{ id: "aiev.todolist.tui", setup: mod.setup }`. [7] The package manifest explicitly exports both the server root (`.`) and `./tui`. [4]

### V1 indicator check

- **V2 indicator present:** `@opencode/plugin` is used in `src/index.ts`, `src/rpc.ts`, and `src/tui-settings.ts`; the package declares `@opencode/plugin >=2.0.0` as a peer dependency. [4] [5] [8]
- **V1 indicator absent in the verified package:** no `@opencode-ai/plugin` appears in the `0.6.1` package manifest, peer dependencies, dev dependencies, or inspected source entrypoints. [1] [4] [5] [8]
- The general (non-V2) OpenCode documentation still contains older examples using `@opencode-ai/plugin`; that is not evidence against this package because the V2 documentation explicitly uses `@opencode/plugin` and the package follows that V2 API. [10]

**Conclusion:** V2 entrypoint is **verified**, not inferred from an npm description alone.

## Safe install specification and command

The safest reproducible specification is the exact npm version:

```text
opencode-todolist@0.6.1
```

Use the V2 CLI command:

```bash
opencode plugin add opencode-todolist@0.6.1
```

The package README documents the unpinned form `opencode plugin add opencode-todolist`; the exact `@0.6.1` form is the evidence-based safety improvement because the official V2 CLI guide explicitly accepts versioned package names and says exact npm versions stay pinned. [2] [9]

Equivalent pinned configuration is:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": ["opencode-todolist@0.6.1"]
}
```

OpenCode V2 documents `plugins` (plural), accepts versioned package entries, and installs/loads package plugins from that list. [9] The repository README also documents the package in `~/.config/opencode/opencode.json`. [2]

For the terminal UI sidebar, the README separately documents adding the package to `~/.config/opencode/cli.json`; restart OpenCode if it is not picked up automatically. [2] The published package's `./tui` export and `aiev.todolist.tui` entrypoint corroborate that this is a separate TUI-facing part of the package. [4] [7]

## Package version, dependencies, and requirements

### Verified package metadata

`package.json` and npm `0.6.1` metadata agree on:

- `version`: `0.6.1`
- `type`: `module`
- root export: types `./dist/index.d.ts`, ESM import `./dist/index.js`
- TUI export: `./tui` -> `./tui/index.js`
- package scripts build the server and TUI artifacts before publish
- no regular runtime `dependencies` are declared in the package manifest
- peer dependencies are declared as follows. [1] [4]

### Peer dependencies

The published `0.6.1` package requires:

- `@opencode/plugin >=2.0.0`
- `@opentui/core >=0.5.10`
- `@opentui/solid >=0.5.10`
- `solid-js >=1.9.0` [1] [4]

`@opencode/plugin` is the V2 API peer. The OpenTUI and Solid peers are relevant to the TUI/sidebar portion; a server-only deployment may not exercise the TUI code, but the package declares them as peers and should be tested with the exact OpenCode build rather than silently assuming they are unnecessary.

### Runtime requirements and uncertainty

- **Required host:** OpenCode V2 with the V2 plugin loader/API, because the package's default export uses `id`/`setup` and `@opencode/plugin` V2 APIs. [5] [9] [10]
- **Required package API range:** `@opencode/plugin >=2.0.0` (declared peer). [1] [4]
- **TUI environment:** `@opentui/core >=0.5.10`, `@opentui/solid >=0.5.10`, and `solid-js >=1.9.0` are declared peers. [1] [4]
- **Node runtime:** **No `engines` field is declared** in `package.json` or the top-level `0.6.1` lockfile package record. Do not convert npm's `_nodeVersion: 22.23.3` into a runtime requirement; that is the publishing environment, not a support declaration. [1] [4] [11]
- **Installer/runtime behavior:** OpenCode's V2 plugin guide manages package plugins through the OpenCode CLI/configuration. The host is responsible for loading the ESM package and its peers; this report does not claim an independent Node-only invocation is supported. [9]

## Documented behavior and configuration options

The README describes the plugin as restoring the V1-era session todo tools in V2:

- `todowrite`: create or replace the complete current-session todo list.
- `todoread`: read the current list.
- `/todo`: post counts, current task, and the full list into the conversation.
- Lists are session-scoped; a compact summary is injected while tasks remain open, including across context compaction.
- Lists accept at most 100 items, each with at most 500 characters.
- Todo fields are `content` (required), `status` (`pending`, `in_progress`, `completed`, `cancelled`), and optional `priority` (`high`, `medium`, `low`). [2] [5]

### Auto-todo file

A project may provide `auto-todos.json` at the repository root or `.opencode/auto-todos.json`. The documented object contains a `todos` array and optional top-level `deduplicate` boolean. Each todo supports:

- `content` (required; entries over 500 characters are dropped)
- `priority` (`high`, `medium`, `low`)
- `always` (`true` adds to every list; default `false` adds only when the incoming list is empty)
- `match` (case-insensitive text condition)
- `order` (`"first"` or a zero-based index; omitted means append)
- `deduplicate` (default `true`; prevents containment duplicates). [2]

Injection is documented as best-effort, and an invalid/unreadable file leaves the model's list untouched. The merged result remains bounded by the todo limits. [2]

### TUI `/todo-settings` options

The README documents `/todo-settings` and the command-palette item `Todolist: Settings` with these controls:

- **Update reminders:** default `on`; `on`/`off`.
- **Show count:** default `on`; `on`/`off`.
- **Show percentage:** default `on`; `on`/`off`.
- **Show timer:** default `on`; `on`/`off`.
- **Header separator:** default `line`; `none`, `line`, or `line + blank`.
- **Collapse threshold:** default `2`; `2`, `3`, or `5`.
- **Border:** default `off`; `on`/`off`. [2]

The repository source confirms the defaults and allowed values. Server-side settings persist `updateReminders`; the TUI-side settings persist `count`, `percent`, `timer`, `gap`, `collapseThreshold`, and `border`. [7] [8]

These are **documented UI settings**, not an arbitrary JSON plugin-options schema. The package's source does not show a documented `ctx.options` contract for user configuration. Do not invent an options object such as `{ enabled: true }` and assume it changes behavior.

## Strongest evidence-based customization plan

1. **Install the pinned package first:** use `opencode-todolist@0.6.1`, then verify it loads with the steps below. This avoids silently testing a future `latest` release.
2. **Use supported configuration before forking:** run `/todo-settings` for reminders, count, percentage, timer, separator, collapse threshold, and border. These controls are implemented and documented. [2] [7] [8]
3. **Seed project policy with `auto-todos.json`:** put stable project tasks in the repository root or `.opencode/auto-todos.json`; use `always`, `match`, `order`, and `deduplicate` only as documented. Keep each content string under 500 characters and avoid more than 100 merged entries. [2]
4. **Do not pass undocumented plugin options:** the official V2 docs support an object-form plugin entry with `options`, but this package's verified source exposes no user-facing `ctx.options` schema. An object entry may therefore be ignored for this package. [5] [9]
5. **For code-level changes, fork/pin rather than patching the cached npm copy:** preserve the V2 default server export (`id: "aiev.todolist"`, `setup(ctx)`) and the separate TUI export (`id: "aiev.todolist.tui"`, `setup`). The likely customization points are `src/auto-todos.ts` for merge policy, `src/rpc.ts` for model-context reminder behavior, and `src/tui-settings.ts`/`src/tui.tsx` for sidebar presentation. Build and test with the exact OpenCode V2 release targeted, then load a local path or pinned Git revision using the V2 plugin configuration syntax. [5] [7] [9]
6. **Keep server and TUI testing separate:** verify `todowrite`/`todoread`/`/todo` first, then verify the terminal sidebar through the `cli.json` path. This reflects the package's two published entrypoints and avoids treating a missing sidebar as proof that the server plugin failed. [2] [4] [7]

## Verification steps for an implementation

1. Confirm the OpenCode build is V2 and can run `opencode plugin check`.
2. Install exactly with `opencode plugin add opencode-todolist@0.6.1`.
3. Confirm the configured plugin entry is exactly `opencode-todolist@0.6.1`, not an unpinned `latest` entry.
4. Start a test session and ask the agent to create a todo list; verify `todowrite` is callable.
5. Ask the agent to read the list; verify `todoread` returns the stored session list.
6. Run `/todo`; verify the report is posted into the conversation.
7. Restart or compact the session and verify the list/context reminder behavior remains available.
8. Add a small `auto-todos.json` fixture and verify the documented `always`, `match`, ordering, and deduplication semantics.
9. Enable the TUI package path documented by the README in `~/.config/opencode/cli.json`; run `/todo-settings` and verify each setting persists.
10. If installation reports peer conflicts, test with the exact peers listed above; do not infer compatibility from the package's publish-time Node version.

## Warnings and evidence boundaries

- The README calls the package an OpenCode V2 plugin, but the stronger verification is the source-level `@opencode/plugin` import, V2 `id`/`setup` export, package exports, and V2 peer declaration. [1] [4] [5] [10]
- `0.6.1` is the latest npm version verified during this research. Future releases may change the entrypoint or settings; keep the exact pin in the manifest until re-reviewed. [1]
- The package has no declared `engines` field. This means the supported Node version is **not specified by the package**; it does not prove that every Node version works.
- The OpenCode V2 docs show `@opencode/plugin` and a default `id`/`setup` plugin contract. The general OpenCode docs at another route show older `@opencode-ai/plugin` examples; do not use those older examples to relabel this package as V1. [9] [10]
- The package declares TUI peers even though its server entrypoint can be inspected independently. Treat the sidebar as a separately verified capability, not as a reason to omit declared peers. [1] [4] [7]

## References

[1]: https://registry.npmjs.org/opencode-todolist/0.6.1 "npm registry metadata for opencode-todolist 0.6.1"
[2]: https://www.npmjs.com/package/opencode-todolist "npm package page and README for opencode-todolist"
[3]: https://github.com/aiev/opencode-todolist "Official opencode-todolist repository"
[4]: https://raw.githubusercontent.com/aiev/opencode-todolist/master/package.json "Official repository package.json"
[5]: https://raw.githubusercontent.com/aiev/opencode-todolist/master/src/index.ts "Official server plugin source entrypoint"
[6]: https://raw.githubusercontent.com/aiev/opencode-todolist/master/index.ts "Official package root entrypoint shim"
[7]: https://raw.githubusercontent.com/aiev/opencode-todolist/master/tui/index.js "Official generated TUI plugin entrypoint"
[8]: https://raw.githubusercontent.com/aiev/opencode-todolist/master/src/tui-settings.ts "Official TUI settings implementation"
[9]: https://opencode.ai/v2/docs/plugins/ "Official OpenCode V2 plugin loading and CLI documentation"
[10]: https://opencode.ai/v2/docs/build/plugins/ "Official OpenCode V2 plugin build/API documentation"
[11]: https://raw.githubusercontent.com/aiev/opencode-todolist/master/package-lock.json "Official repository package-lock.json"
