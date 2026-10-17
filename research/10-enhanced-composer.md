# opencode2-enhanced-composer — OpenCode V2 research

**Item / العنصر:** `enhanced-composer`  
**Requested package:** `opencode2-enhanced-composer`  
**Research conclusion:** **Verified V2 TUI plugin, with an environment-sensitive Node requirement.** A real published V2 TUI entrypoint is present. The package is not unresolved, but it should not be enabled on a host that cannot satisfy Node `>=26.4.0` and the plugin's OpenCode V2 floor.

## Verified identity and package state

The authoritative npm registry record identifies the package as `opencode2-enhanced-composer`, version `0.1.0`, with the `latest` dist-tag pointing to `0.1.0`. The registry record currently exposes one published version, `0.1.0`, and links the package to the GitHub repository `P-Theo/opencode2-enhanced-composer`. [1]

The repository `package.json` independently reports version `0.1.0`, MIT licensing, author `P-Theo`, ESM mode (`"type": "module"`), and the same repository/homepage. [2] The current manifest already contains the reproducible exact target `opencode2-enhanced-composer@0.1.0`; its `needs-review` status is conservative and can be changed to a V2-reviewed status after the parent applies this report.

## Exact safe install specification and command

**Safe reproducible install specification:**

```text
opencode2-enhanced-composer@0.1.0
```

**Recommended command:**

```sh
opencode plugin add opencode2-enhanced-composer@0.1.0
```

The project README documents the same command with the unpinned package name, `opencode plugin add opencode2-enhanced-composer`, and says that it adds the entry to `cli.json`. The exact version above is the safer manifest/install form because it avoids silently moving with a future `latest` release. OpenCode V2 officially supports npm package names with versions and uses `cli.json` for CLI/TUI-only plugins. [3] [4]

A manual exact entry is also consistent with the V2 plugin configuration model:

```jsonc
{
  "plugins": [
    {
      "package": "opencode2-enhanced-composer@0.1.0",
      "options": {
        "layout": {
          "topLeft": ["spinner", "bgagent"],
          "topRight": ["tps"],
          "bottomLeft": ["directory", "branch"],
          "bottomRight": ["input", "output", "cache", "cost", "context"]
        }
      }
    }
  ]
}
```

For this particular plugin, put that entry in the OpenCode V2 terminal configuration file (`cli.json`), not only in a server/project `opencode.json(c)`: the plugin replaces `prompt.footer`, appends to `session.composer.top`, and registers an in-TUI command. The project's README explicitly calls the file `cli.json`; the official V2 docs distinguish CLI-only plugins and show them in `cli.json`. [3] [4]

## Is a real V2 plugin entrypoint present?

**Yes — verified.** The published package declares:

```json
"exports": {
  "./tui": "./dist/tui.js",
  "./options.schema.json": "./options.schema.json"
},
"files": ["dist", "options.schema.json"]
```

The published npm tarball contains `dist/tui.js`, and the repository build script deliberately compiles `src/footer.tsx` to that exact output path. The source `tui.tsx` and `src/tui.tsx` shims default-export the footer plugin definition for local-directory loading. [2] [5] [6]

The implementation is recognizably V2, not merely a package with `opencode2` in its name:

- The source declares a `Plugin.Definition` object with stable ID `opencode2.enhanced-composer`, a `setup(context)` method, and a cleanup function.
- It uses V2 TUI APIs (`context.ui.slot`, `context.keymap.layer`, `context.storage.memory`, `context.data.listen`) and registers `prompt.footer`, `session.composer.top`, and the `customize-footer` command. [7]
- The official V2 documentation defines the V2 shape as a default-exported definition with an `id` and `setup(ctx)`. [8]

### V1 indicator check

No V1 package indicator was found in the authoritative package metadata or source:

- **No `@opencode-ai/plugin` dependency/import** was found.
- The repository development dependency is **`@opencode/plugin`**, the V2 package identity. The published npm metadata pins the build/test baseline to `@opencode/plugin: 2.0.12`; the current repository `main` package file has moved that development pin to `2.0.22`. [1] [2]
- The official V2 migration guide says V1 implementations use `@opencode-ai/plugin`, while V2 uses `@opencode/plugin` and a default `Plugin.define`/definition-style entrypoint. It also warns that V1 implementations do not run in V2. [9]

The package's runtime bundle type-imports the V2 plugin types and executes against the host's V2 context. It does not list `@opencode/plugin` as a runtime dependency, which is consistent with a host-provided plugin ABI, but the exact host build must still be tested. This is a compatibility caveat, not evidence of V1 code.

## Versions and dependencies

### Published package version

- **Published package:** `opencode2-enhanced-composer@0.1.0`.
- **npm dist-tag:** `latest -> 0.1.0`.
- **Repository version:** `0.1.0`.
- **Published package creation:** the npm metadata records `2026-09-21`; this timestamp is registry metadata, not a compatibility guarantee. [1] [2]

### Direct runtime dependencies

The published package declares these direct dependencies:

- `jsonc-parser: 3.3.1`
- `string-width: 7.2.0`

The package is ESM (`"type": "module"`) and exposes only the TUI subpath and options schema. [1] [2]

### Peer dependencies

All three peers are marked **optional** in `peerDependenciesMeta`:

- `@opentui/core >=0.5.10` — optional peer.
- `@opentui/solid >=0.5.10` — optional peer.
- `solid-js ^1.9.0` — optional peer.

There is no declared peer dependency on either `@opencode/plugin` or `@opencode-ai/plugin`. The optional OpenTUI/Solid peers should normally be supplied by the OpenCode TUI host; their optional metadata does not remove the need to test the exact host runtime. [1] [2]

The repository's development-only compatibility pins are different between the published npm metadata and current `main`: the npm artifact records `@opencode/plugin: 2.0.12`, `@opentui/core: ^0.5.11`, and `@opentui/solid: ^0.5.10`; current `main` records `@opencode/plugin: 2.0.22`, `@opencode/theme: 2.0.22`, and `@opentui` development versions around `0.5.14`. Do not treat the current GitHub `main` pins as proof that the already-published `0.1.0` tarball was rebuilt with those newer pins. [1] [2]

## Runtime requirements and caveats

**Required by the package metadata:** Node.js `>=26.4.0`. This is the strongest hard runtime requirement and is the reason the current manifest note correctly calls the item environment-sensitive. [1] [2]

**Host compatibility floor documented by the project:** OpenCode 2 `2.0.11` or newer. The README calls `2.0.11` the minimum supported OpenCode 2 version. [3]

**Development-only runtime:** the development guide asks maintainers to use Node `26.4.0` and Bun `1.3.12`. Bun is not stated as an end-user runtime requirement for the published plugin; do not add Bun to the installation requirement unless the host environment independently needs it. [6]

**Terminal/font requirement:** a Nerd Font is required for the default glyphs to render correctly. Without one, use `/customize-footer` or explicit custom text values to replace/hide icons. [3] [10]

**Host surface:** this is a TUI/CLI plugin, not a server-only extension. It changes the prompt footer and composer-top slots and exposes `/customize-footer`; it should be tested in the OpenCode V2 terminal client that loads `cli.json`. [3] [7]

**Cache behavior:** OpenCode caches package plugins. The README and release runbook warn that restarting alone may reuse the newest cached generation rather than fetch a fresh release. When intentionally upgrading or retesting the exact artifact, remove the relevant cache directory and restart:

```sh
rm -rf ~/.cache/opencode/npm/opencode2-enhanced-composer@latest
```

For the exact `@0.1.0` spec, inspect the actual cache path created by the host rather than assuming that the `@latest` path is the one in use. [3] [5]

## Documented configuration options

The authoritative configuration guide and `options.schema.json` document the following top-level options. Missing values use defaults; invalid values are normalized, and unknown top-level options are preserved for future versions. [10] [11]

### `layout`

Four independent zones accept widget ID arrays: `topLeft`, `topRight`, `bottomLeft`, and `bottomRight`. If `layout` is omitted, the default is:

- `topLeft`: `spinner`, `bgagent`
- `topRight`: `tps`
- `bottomLeft`: `directory`, `branch`
- `bottomRight`: `input`, `output`, `cache`, `cost`, `context`

Valid widget IDs are `spinner`, `directory`, `branch`, `input`, `output`, `cache`, `cost`, `context`, `tps`, and `bgagent`. Each widget should occur at most once; omitted widgets are hidden. Duplicate/invalid IDs are dropped according to the documented normalization behavior. [10] [11]

### `appearance`

Documented appearance controls are:

- `spinner`: `braille`, `blocks`, or `text`.
- `directory.format`: `name` or `path`; `directory.icon`: `f115`, `f07b`, `f07c`, `none`, or custom `{ "text": "..." }`.
- `branch`: `e0a0`, `f418`, `colon`, or custom text.
- `worktree`: `e5fb`, `ec7d`, `none`, or custom text.
- `tokens`: `words`, `arrows`, or custom `{ "input": "...", "output": "..." }`.
- `cache`: `text`, `f49b`, `none`, or custom text.
- `cost`: `currency`, `labeled`, or custom text.
- `bgagent`: `arrow`, `ec20`, `text`, or custom text.
- `context.format`: `tokens`, `tokens-percent`, `percent`, `tokens-limit`, or `off`.
- `context.bar`: `solid`, `slanted`, or `off`.
- `context.label`: `none`, `ctx`, or `context`.
- `context.order`: any of the six documented permutations of bar/text/label.
- `separator`: `dot`, `pipe`, `space`, or custom text.

The documented data semantics are also important for customization: `input` and `output` are cumulative session accounting, `context` is the latest usable assistant usage, `cost` is cumulative USD cost, `tps` is live/frozen throughput, and `bgagent` is the count of running direct subagents. [10] [11]

### `overflow`

`overflow.preset` accepts `balanced` (default), `usage-first`, `location-first`, or `custom`. For `custom`, provide `overflow.hideFirst` as a list of widget IDs ordered from first hidden to last hidden. The fitting pass recomputes separators and hides whole widgets when a row is too narrow. [10] [11]

### TPS tuning fields

These are top-level fields beside `layout`, `appearance`, and `overflow`:

- `refreshHz`: number from `1` to `60`, default `8`; controls live TPS refresh frequency.
- `bytesPerToken`: number from `1` to `16`, default `4.75`; controls the streaming estimate until OpenCode reports exact step usage.

The in-TUI editor does **not** expose these two fields; edit them directly in `cli.json`. [10] [11]

## Strongest evidence-based customization plan

1. **Pin and install the published artifact.** Use `opencode2-enhanced-composer@0.1.0` and the exact `opencode plugin add` command above. Confirm that the host is OpenCode V2 and Node `>=26.4.0` before debugging UI behavior.
2. **Start with the documented default layout.** It exercises every widget and provides a baseline for diagnosing host/TUI incompatibilities. Confirm that the footer and composer-top render, that `/customize-footer` appears, and that no duplicate plugin generation is visibly active.
3. **Use `/customize-footer` for interactive changes.** The editor previews and saves the supported layout, appearance, and overflow settings back into `cli.json`. This is safer than hand-writing enum values and is the project's documented path.
4. **Edit only the fields the editor cannot expose.** Add `refreshHz` and `bytesPerToken` manually when TPS behavior needs tuning. Keep values within `1..60` and `1..16`; begin with defaults before changing estimation behavior.
5. **If the terminal lacks a Nerd Font, replace icons explicitly.** Prefer custom text or `none` for directory/branch/cache/worktree/billing/subagent labels rather than diagnosing missing glyphs as a plugin failure.
6. **Optimize for narrow terminals with an intentional layout and overflow policy.** For a compact footer, keep `directory`, `branch`, `tps`, and one usage indicator; choose `usage-first` or a custom `hideFirst` order. Keep each widget at most once across zones.
7. **Verify persistence and upgrade behavior.** Restart the TUI, confirm the saved `cli.json` entry, and inspect the OpenCode plugin cache when a newly published build does not appear. If behavior differs between source and npm, test the packed `dist/tui.js` path because the repository explicitly treats source-directory and published-package loading as different code paths. [5] [6]

A conservative example after the baseline test is:

```jsonc
{
  "plugins": [
    {
      "package": "opencode2-enhanced-composer@0.1.0",
      "options": {
        "appearance": {
          "directory": { "format": "name", "icon": { "text": "dir" } },
          "branch": { "text": "git" },
          "cache": "none",
          "separator": "space"
        },
        "overflow": { "preset": "usage-first" },
        "refreshHz": 8,
        "bytesPerToken": 4.75
      }
    }
  ]
}
```

This example uses only documented option forms. It is not a claim that these values are universally preferable; the strongest plan is to begin at defaults, then change one documented option group at a time.

## Verification checklist for the parent manifest

- [x] Exact npm package and repository resolved.
- [x] Published version and `latest` tag verified from npm registry metadata.
- [x] Published V2 TUI export `./tui -> ./dist/tui.js` verified.
- [x] Source definition and V2 slot registrations verified.
- [x] No `@opencode-ai/plugin` V1 indicator found.
- [x] `@opencode/plugin` V2 development pin verified in package metadata.
- [x] Node `>=26.4.0` and OpenCode V2 `>=2.0.11` documented.
- [x] Optional peer dependencies and direct dependencies recorded.
- [x] Configuration schema and editor limitations recorded.
- [ ] **Environment test still required:** run the exact pinned package in the target OpenCode V2/Node environment and exercise the TUI, `/customize-footer`, and a narrow terminal.

## References

[1]: https://registry.npmjs.org/opencode2-enhanced-composer "npm registry metadata for opencode2-enhanced-composer"
[2]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/package.json "Repository package.json"
[3]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/README.md "Repository README"
[4]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin configuration and management"
[5]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/docs/RELEASE.md "Repository release and package-loading runbook"
[6]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/docs/DEVELOPMENT.md "Repository development and compatibility notes"
[7]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/src/footer.tsx "Repository V2 TUI plugin implementation"
[8]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin development documentation"
[9]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official V1-to-V2 plugin migration documentation"
[10]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/docs/CONFIGURATION.md "Repository configuration guide"
[11]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/options.schema.json "Repository machine-readable options schema"
[12]: https://raw.githubusercontent.com/P-Theo/opencode2-enhanced-composer/main/scripts/build.mjs "Repository published-entrypoint build script"
