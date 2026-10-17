# opencode-shell-magazine — OpenCode V2 Extension Research

## النتيجة / Conclusion

**Status: `v2-reviewed` (CLI/TUI-only; not a server plugin).** The package has a real V2 entrypoint: the published `./tui` export points to `tui/index.js`, whose default export is `{ id: "opencode-shell-magazine", setup: mod.setup }`. The repository build script explicitly describes this as the V2 `opencode2` `{ id, setup }` entrypoint, and the implementation registers V2 UI slots, commands, storage, shell data, and cleanup. [1] [2] [3] [4] [5]

Use the exact pinned npm package **`opencode-shell-magazine@0.1.4`**. The strongest V2 installation path is:

```sh
opencode plugin add opencode-shell-magazine@0.1.4
```

Because this is a CLI/TUI plugin, verify that it is active in the V2 terminal client’s `cli.json`, not only in a server/project plugin list. The official V2 CLI-plugin documentation says CLI-only packages are configured in `cli.json` and should expose `./tui`; this package does exactly that. [6]

## Identity and authoritative sources

- Requested/manifest ID: `shell-magazine`; requested package: `opencode-shell-magazine`.
- Official repository: `https://github.com/aiev/opencode-shell-magazine`.
- npm package: `https://www.npmjs.com/package/opencode-shell-magazine`.
- npm registry metadata: package name is `opencode-shell-magazine`; `latest` is `0.1.4`; the registry lists versions `0.1.1`, `0.1.2`, `0.1.3`, and `0.1.4`. [3] [4]
- Repository metadata in both `package.json` and npm metadata points to `git+https://github.com/aiev/opencode-shell-magazine.git`. [2] [3]

The current manifest already requests `opencode-shell-magazine@0.1.4` but marks it `needs-review`. This report supplies the missing V2 entrypoint and installation verification; it does not modify the manifest.

## Exact safe install specification and command

**Safe install specification:** `opencode-shell-magazine@0.1.4`.

**Recommended V2 command:**

```sh
opencode plugin add opencode-shell-magazine@0.1.4
```

OpenCode V2 accepts npm package names with exact versions, and its CLI documentation shows `opencode plugin add <package>@<version>` for package plugins. Exact npm versions remain pinned rather than being updated as unpinned packages. [6]

The upstream README also documents a global npm installer:

```sh
npm install -g opencode-shell-magazine@0.1.4
opencode-shell-magazine
```

The package binary is `opencode-shell-magazine`, and `install.mjs` adds the unversioned string `opencode-shell-magazine` to `~/.config/opencode/cli.json` or `$XDG_CONFIG_HOME/opencode/cli.json`. That upstream path is valid, but it is less reproducible because the generated config entry is unpinned. Prefer `opencode plugin add opencode-shell-magazine@0.1.4` for a managed, exact V2 install. [1] [7] [3]

If configuring manually, the package README shows the CLI configuration shape:

```json
{
  "plugins": ["opencode-shell-magazine@0.1.4"]
}
```

The upstream installer writes the same array with the unversioned package name. Use an exact version when reproducibility matters. [1] [7]

## Package metadata and runtime requirements

### Verified package metadata

- Package version: **`0.1.4`**; npm `latest` currently resolves to `0.1.4`. [3] [4]
- Published versions found in the registry: **`0.1.1`, `0.1.2`, `0.1.3`, `0.1.4`**. [4]
- Module format: ESM (`type: "module"`). The package has no `engines` field, so the publisher does **not** declare a minimum Node.js version. The registry `_nodeVersion` value is publication metadata, not a runtime guarantee. [2] [3]
- Published entrypoint: the only package export is `./tui` → `./tui/index.js`; there is no root `.` export. The published archive contains `tui/index.js`, `dist/tui.js`, `install.mjs`, and the source tree. [2] [3]
- Binary: `opencode-shell-magazine` → `install.mjs`. [2] [3]
- License: MIT. [1] [2] [3]
- No `@opencode/plugin` or `@opencode-ai/plugin` dependency/peer is declared. The package has only the three OpenTUI/Solid peer dependencies below; OpenCode supplies the host API at runtime. [2] [3]

### Peer dependencies

The exact peer ranges declared by both the repository `package.json` and npm `0.1.4` metadata are:

- `@opentui/core >=0.5.8`
- `@opentui/solid >=0.5.8`
- `solid-js >=1.9.0`

There are no declared OpenCode package peers and no declared `engines` range. OpenCode V2 itself is a runtime requirement because the README explicitly says “OpenCode V2 only (`opencode2` / `@opencode/cli` 2.x).” [1] [2] [3]

### Runtime requirements

1. A V2 OpenCode terminal client (`opencode2` / `@opencode/cli` 2.x), with a CLI/TUI plugin loader that supports `./tui`. This is an explicit upstream claim, not an inferred version range. [1] [6]
2. OpenTUI core/solid and Solid JS compatible with the peer ranges above. The plugin renders Solid/OpenTUI components and uses OpenCode UI slots. [2] [5] [6]
3. An ESM-capable Node runtime supplied by the OpenCode/npm environment. The package uses Node built-ins such as `node:fs/promises`, `node:crypto`, `node:zlib`, `node:os`, and `node:path`, but publishes no `engines` field; therefore no exact Node minimum should be guessed. [2] [10] [11]
4. A writable OpenCode state area. By default, history payloads are written under `$XDG_STATE_HOME/opencode/<channel>/shell-magazine/text`, or `$HOME/.local/state/opencode/<channel>/shell-magazine/text` when `XDG_STATE_HOME` is unset. Files are written with private directory/file modes and atomically renamed. [10] [11]
5. For legacy history migration, read access to the old state file is required. The default legacy path is derived from `XDG_STATE_HOME` and the OpenCode channel; the path can be overridden by the documented `legacyHistoryFile` option. [1] [10]

## V2 compatibility and entrypoint evidence

### Real V2 entrypoint: verified

The repository contains `tui/index.js` with this default export:

```js
import mod from "./../dist/tui.js"

export default {
  id: "opencode-shell-magazine",
  setup: mod.setup,
}
```

The wrapper’s comment identifies the host protocol as the V2 `{ id, setup }` protocol. The build script separately identifies `src/tui.tsx` as the V2 `opencode2` entrypoint and bundles it to `dist/tui.js`. [7] [8]

The implementation’s `mod` object has `id: "opencode-shell-magazine"`, a `setup(context)` function, UI slot registrations for `app`, `sidebar.content`, and `prompt.footer.status`, and a cleanup function that flushes history. It consumes V2-style host data, client, storage, attention, theme, renderer, and UI APIs. [5] [9] [10]

OpenCode’s official V2 CLI-plugin guide says a TUI package should publish a `./tui` export, use the V2 `Plugin.define`/`setup` shape, and declare OpenTUI peers when it renders JSX. The package’s wrapper is an equivalent explicit `{ id, setup }` object and its package metadata matches the documented `./tui` and OpenTUI-peer convention. [6]

### V1 indicator check

The package does **not** show the classic V1 indicator `@opencode-ai/plugin` in `dependencies`, `devDependencies`, `peerDependencies`, or the published package metadata. Its source also does not import `@opencode-ai/plugin`; it uses local minimal V2 context types and a V2 TUI adapter. [2] [3] [9] [10]

The build script’s `external` array mentions wildcard module patterns including `@opencode-ai/*` and `@opencode/plugin/*`. That is a bundler externalization rule, not a package dependency or V1 entrypoint, and should not be treated as evidence that the package uses the V1 API. [8]

The official migration guide says V1 implementations use the old `@opencode-ai/plugin` style and do not run in V2; V2 implementations use a stable `id` and `setup` and the `@opencode/plugin` API. This package’s explicit V2-only README claim plus the verified `./tui` `{id, setup}` wrapper support V2 compatibility. [12] [13]

**Qualification:** the package does not publish an OpenCode peer version or a formal compatibility matrix. Compatibility is therefore evidenced by the entrypoint, source contract, README claim, and official CLI/TUI convention; it is not a claim that every future V2 build is compatible. The source context comment says its local types mirror `@opencode/plugin` 2.0.15’s TUI context, which is useful provenance but not a supported-version range. [9]

## Documented configuration options

The README documents settings as an interactive menu and slash commands, not as a JSON schema. The settings are persisted through OpenCode host storage under `shell_magazine.*` keys by the adapter. [1] [5] [10]

### UI settings and defaults

- **Max entries:** `10` (`/shell-magazine-max`).
- **Order:** `Descending` / newest first (`/shell-magazine-order`); selectable `asc` or `desc`.
- **Scroll:** `Wheel` (`/shell-magazine-scroll`); selectable wheel or click paging.
- **Time format:** `short` (`/shell-magazine-time-format`); supported choices are `short`, `decimal`, `clock`, `compact`, and `seconds`.
- **Show elapsed time:** on (`/shell-magazine-show-time`).
- **Show working directory:** off (`/shell-magazine-show-cwd`).
- **Show exit code:** on (`/shell-magazine-show-exit`).
- **Show subagent commands:** on (`/shell-magazine-show-subagents`).
- **Footer running indicator:** off (`/shell-magazine-footer-status`).
- **Panel border:** on (`/shell-magazine-border`).
- **Notify when a command finishes:** on (`/shell-magazine-notify`).
- **Notification threshold:** `30s` (`/shell-magazine-threshold`); choices are `10s`, `30s`, `1m`, `2m`, and `5m`.
- **Language:** selectable through `/shell-magazine-lang`; the README documents the command but does not define a JSON configuration key or a fixed list in its settings table.

The command surface also includes `/shell-magazine` for the interactive settings menu, `/shell-magazine-config` for a summary, `/shell-magazine-clear` to remove finished records, and `/shell-magazine-version` to show the installed version. These names and the setting mappings are implemented in `src/v2/commands.ts`. [1] [10]

### Documented path options

The README documents two plugin options for nonstandard/legacy state handling:

- `legacyHistoryFile`: full path to the old monolithic legacy JSON file.
- `historyDirectory`: directory for separate immutable history payloads.

The adapter reads `context.options.historyDirectory` and `context.options.legacyHistoryFile`, and otherwise uses the default state/channel paths. The README specifically recommends these options when migrating old monolithic history or using a nonstandard state directory. [1] [10] [11]

There is no authoritative JSON schema listing arbitrary plugin options, and the UI settings should not be invented as config-file keys. Use the menu/commands for the UI settings; use the two path options only for their documented storage/migration purpose.

## Strongest evidence-based customization plan

1. **Pin and install the package through the V2 CLI plugin manager.** Use `opencode plugin add opencode-shell-magazine@0.1.4`, then confirm the package appears in `opencode plugin list` and `opencode plugin check`. This preserves the exact tested package version. [6]
2. **Keep it in the CLI/TUI configuration surface.** Do not treat it as a server plugin. Confirm the exact package entry is present in the V2 terminal client’s global `cli.json`; the package is intentionally exposed through `./tui`, and the official docs say CLI-only plugins belong there. [6]
3. **Customize through the supported UI first.** Open `/shell-magazine` and use the menu, or use the documented slash commands. These controls persist using host storage and survive TUI restarts without editing package source. [1] [5] [10]
4. **For history migration or a nonstandard state root, use only the documented path options.** Configure an object-form plugin entry with `package: "opencode-shell-magazine@0.1.4"` and `options.legacyHistoryFile` and/or `options.historyDirectory`, if the target V2 CLI build accepts the generic object form in `cli.json`. The generic V2 plugin docs define the object-and-options form and the TUI context exposes `context.options`; because the CLI-specific example only shows string entries, verify this exact config shape in the target build before relying on it. [6] [9] [12]

Example for a controlled test of the path options:

```json
{
  "$schema": "https://opencode.ai/v2/cli.json",
  "plugins": [
    {
      "package": "opencode-shell-magazine@0.1.4",
      "options": {
        "historyDirectory": "/absolute/path/to/shell-magazine/text",
        "legacyHistoryFile": "/absolute/path/to/legacy-session-data.json"
      }
    }
  ]
}
```

This object form is a **recommended test plan**, not a claim that the package provides a separate schema or that every V2 CLI release accepts option objects in `cli.json`. If the target CLI rejects object entries there, keep the package string entry and use the documented interactive settings instead.

5. **Do not patch generated `dist/tui.js` or rely on undocumented storage keys.** If deeper visual or behavioral customization is required, fork the repository, change `src/tui.tsx` or the panel/command sources, run the documented build/typecheck/test commands, and load the local repository path only in a controlled development profile. The README explicitly supports a local repository path for development. [1] [8]

## Verification steps

1. Check registry metadata: `npm view opencode-shell-magazine@0.1.4 version peerDependencies engines exports bin repository` and confirm version `0.1.4`, the three peers, no `engines` field, `./tui`, and the installer binary. [3] [4]
2. Install the exact version with `opencode plugin add opencode-shell-magazine@0.1.4`; do not substitute the unpinned latest tag for a reproducible test. [6]
3. Run `opencode plugin list` and confirm the configured package is present in the terminal client’s active list. Run `opencode plugin check` to ensure the package is recognized as a package plugin. [6]
4. Restart/reload the V2 TUI and run `/shell-magazine-version`; it should show `opencode-shell-magazine v0.1.4`. Confirm the Shell panel appears in the sidebar and `/shell-magazine-config` reports settings. [1] [10]
5. Execute both a foreground shell command and a background shell command. Confirm running/completed status, elapsed time, exit code, history backfill, output expansion, and the documented kill/open-output actions. The implementation consumes `context.data.shell`, `session.shell.started`, `session.shell.ended`, session messages, and the official shell client. [1] [9] [10]
6. Exercise the settings menu and every documented toggle/select command, then restart the TUI and confirm the changed values persist through host storage. [1] [10]
7. If using path options, test with a clean profile and verify the history payload directory is writable and that legacy import reads without deleting or modifying the original legacy file. [1] [10] [11]
8. Test cleanup by disabling/removing the package and reloading OpenCode. The plugin’s setup returns a cleanup function that flushes pending history writes; verify no stale panel remains. [5] [6]

## Warnings and uncertainty

- **CLI/TUI-only:** this package should be loaded as a V2 terminal client plugin through `cli.json` and its `./tui` export. Do not classify it as a general server-side plugin merely because the package name contains `opencode`. [3] [6]
- **No root export:** the package exports `./tui` but not `.`. This is expected for a CLI/TUI-only package under the official V2 convention, but a generic loader that only tries the root export would not load it. [2] [6]
- **No OpenCode peer range:** neither `@opencode/plugin` nor `@opencode-ai/plugin` is declared, and no OpenCode version range is published. The README’s V2-only statement and source entrypoint are strong evidence, but exact compatibility with a future V2 release still needs an integration test. [1] [2] [3] [9]
- **No Node engine declaration:** do not report a specific Node minimum. The package uses Node APIs and ESM, but the metadata does not declare `engines`. [2] [3]
- **OpenTUI peers are runtime-sensitive:** `@opentui/core >=0.5.8`, `@opentui/solid >=0.5.8`, and `solid-js >=1.9.0` must resolve compatibly with the exact OpenCode V2 build. [2] [3] [6]
- **Unpinned upstream installer:** the README’s `npm install -g opencode-shell-magazine` and installer script write an unversioned plugin name. Use the exact `@0.1.4` spec for reproducibility. [1] [7]
- **Options caveat:** `legacyHistoryFile` and `historyDirectory` are documented and read by the adapter, but the package publishes no formal options schema. UI settings are command/menu-driven, not documented as JSON fields. [1] [10]
- **State migration caveat:** after upgrading from a version using monolithic history, the README says existing TUIs should be reopened once; the old file remains intact, and OpenCode 2.0.22–2.0.24 may retain an old registered store after hot reload. Plan a controlled restart if that migration applies. [1]

## Structured handoff fields

- **id:** `shell-magazine`
- **name:** `opencode-shell-magazine`
- **status:** `v2-reviewed`
- **authoritative_source:** Official repository README/package.json/source plus npm registry metadata and official OpenCode V2 plugins/CLI/migration documentation.
- **install_spec:** `opencode-shell-magazine@0.1.4`
- **install_command:** `opencode plugin add opencode-shell-magazine@0.1.4`
- **v2_compatibility:** Verified real V2 CLI/TUI entrypoint via `./tui` and `{ id, setup }`; V2-only claim in README; no server-plugin/root-export claim.
- **peer_dependencies:** `@opentui/core >=0.5.8`; `@opentui/solid >=0.5.8`; `solid-js >=1.9.0`
- **requirements:** OpenCode V2 terminal client; CLI/TUI loader supporting `./tui`; compatible OpenTUI/Solid peers; ESM-capable Node runtime; writable OpenCode state directory; legacy-file read access when migrating.
- **documented_options:** Interactive settings and slash commands listed above; `legacyHistoryFile`; `historyDirectory`.
- **recommended_options:** Pin `0.1.4`; use the menu/commands for UI settings; use only the two documented path options for storage migration; do not invent JSON setting keys.
- **verification_steps:** Registry metadata check; exact install; `plugin list/check`; TUI panel/version/config check; foreground/background shell test; settings persistence; path-option test; cleanup/reload test.
- **warnings:** No `@opencode-ai/plugin` or `@opencode/plugin` dependency/peer; no OpenCode peer range; no Node `engines`; only `./tui` export; OpenTUI peer/runtime sensitivity; upstream installer is unpinned; object-form `cli.json` options need target-build verification.

## References

[1]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/README.md "Official repository README"
[2]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/package.json "Official repository package.json"
[3]: https://registry.npmjs.org/opencode-shell-magazine/0.1.4 "npm registry metadata for version 0.1.4"
[4]: https://registry.npmjs.org/opencode-shell-magazine "npm registry package metadata and versions"
[5]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/src/tui.tsx "Official V2 TUI source entrypoint"
[6]: https://opencode.ai/v2/docs/build/plugins/cli "Official OpenCode V2 CLI plugin documentation"
[7]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/install.mjs "Official package installer script"
[8]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/build.tui.mjs "Official TUI build script"
[9]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/tui/index.js "Official published TUI export wrapper"
[10]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/src/v2/adapter.ts "Official V2 adapter source"
[11]: https://raw.githubusercontent.com/aiev/opencode-shell-magazine/master/src/core/text-blobs.ts "Official history payload storage source"
[12]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin documentation"
[13]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1-plugin migration documentation"
