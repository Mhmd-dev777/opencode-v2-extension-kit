# opencode-tasks — OpenCode V2 extension research

**الحالة / Status:** **Verified V2 package; safe to treat as V2-compatible at the pinned 1.0.0 release.** The name resolves unambiguously to the public npm package `opencode-tasks`, maintained in the official repository `jdormit/opencode-tasks`. The evidence below separates published-package facts from repository claims and from conclusions.

## Identity and authoritative sources

- **Package:** `opencode-tasks`
- **Current npm version / dist-tag:** `1.0.0` / `latest`.
- **Authoritative repository:** `https://github.com/jdormit/opencode-tasks`
- **Maintainer shown by npm:** Jeremy Dormitzer (`jdormit`).
- **License:** MIT.
- **Purpose:** scheduled recurring tasks, one-off tasks, and session loops for OpenCode 2.

The npm page describes version `1.0.0` as targeting OpenCode 2 and links to the repository. The registry metadata independently confirms the package name, `latest: 1.0.0`, repository, published package manifest fields, and version history. [1] [2]

## V2 plugin entrypoint: verified

A real V2 entrypoint is present; this is not only a CLI or a README-only integration.

1. The published package manifest maps `main`, `module`, and the package export to `./dist/index.js`, with TypeScript declarations at `./dist/index.d.ts`. It also publishes a separate `opencode-tasks` binary at `dist/cli.js`. [3]
2. The repository build config explicitly labels the plugin entrypoint and builds `src/plugin.ts` as `dist/index.js` in ESM format. The CLI is a separate `dist/cli.js` build. [4]
3. `src/plugin.ts` imports `Plugin` from **`@opencode/plugin`** and exports `default Plugin.define({ id: "opencode-tasks", async setup(ctx) { ... } })`. The setup registers tools through `ctx.tool.transform` and slash/code commands through `ctx.command.transform`; it also uses V2 session APIs. [5]
4. Inspecting the published `opencode-tasks@1.0.0` tarball shows `dist/index.js` beginning with the same `Plugin` import from `@opencode/plugin` and the generated plugin implementation. This confirms that the V2 source is actually shipped, not merely present in the source tree.

This matches the official OpenCode V2 plugin contract: a package plugin uses a default export based on `Plugin.define`, and published package exports should point to the plugin implementation. [6]

**V2 conclusion:** `opencode-tasks@1.0.0` has a genuine V2 server-plugin entrypoint at `dist/index.js`, not an unresolved or guessed entrypoint.

## Safe install specification and commands

### Recommended pinned specification

Use the exact npm version:

```text
opencode-tasks@1.0.0
```

For a project/global OpenCode configuration, use the V2 package-plugin form:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": ["opencode-tasks@1.0.0"]
}
```

OpenCode V2 accepts versioned npm package entries and also provides the package-plugin CLI. [6] Pinning `1.0.0` is safer than the README's unpinned `"opencode-tasks"` because OpenCode can update unpinned npm plugins in the background; exact npm versions stay pinned. [6]

### Exact install commands

Use the official V2 package installer to add the plugin:

```sh
opencode plugin add opencode-tasks@1.0.0
```

The package also requires its scheduler daemon/launch agent to be installed. Run the **pinned** CLI, not an unpinned `bunx` request:

```sh
bunx opencode-tasks@1.0.0 --install
```

Optionally install the supplied agent skill:

```sh
bunx opencode-tasks@1.0.0 --install-skill
```

The repository README documents the plugin config, the scheduler installer, service discovery, and the optional skill installer. [7] The scheduler ticks every 60 seconds through launchd on macOS or a user systemd timer on Linux. After adding or upgrading the plugin, restart the OpenCode service as documented by the package. [7]

## Versions and V1 indicators

The npm registry reports these published versions:

```text
0.1.0, 0.1.1, 0.1.2, 0.2.0, 0.3.0, 0.4.0,
0.5.0, 0.5.1, 0.5.2, 0.5.3, 1.0.0
```

The repository README explicitly identifies `0.5.3` as the last V1-compatible npm release and gives `github:jdormit/opencode-tasks#v1` as the V1 source. [7] Registry metadata confirms the V1/V2 package-shape change:

- `opencode-tasks@0.5.3`: main/export `dist/plugin.js`; optional peer **`@opencode-ai/plugin >=0.15.0`**.
- `opencode-tasks@1.0.0`: main/export `dist/index.js`; optional peer **`@opencode/plugin ^2.0.29`**; dependency **`@opencode/client ^2.0.29`**. [2]

Therefore, `@opencode-ai/plugin` is a clear historical V1 indicator. Do **not** install `opencode-tasks@0.5.3` when the target is OpenCode V2. The V2 release uses the new **`@opencode/plugin`** package. The latest source has no V1 `server()` export; its compatibility language concerns legacy V1 task-file permission syntax and old V1 command cleanup, not a V1 plugin entrypoint. [5] [7]

## Package versions, dependencies, and runtime requirements

### Published `1.0.0` manifest

Verified from the repository `package.json` and the npm registry metadata:

- `name`: `opencode-tasks`
- `version`: `1.0.0`
- `type`: `module`
- `main` and `module`: `./dist/index.js`
- `types`: `./dist/index.d.ts`
- `exports["."]`: ESM `./dist/index.js` plus types `./dist/index.d.ts`
- `bin.opencode-tasks`: `dist/cli.js`
- runtime dependencies:
  - `@opencode/client: ^2.0.29`
  - `cron-parser: ^5.0.0`
  - `gray-matter: ^4.0.3`
- optional peer dependency:
  - `@opencode/plugin: ^2.0.29`
- dev-only V2 package: `@opencode/plugin: ^2.0.29`

The peer is marked optional in `peerDependenciesMeta`; it is still the compatibility contract for the V2 plugin API. [2] [3]

### Runtime requirements

Verified or explicitly documented requirements are:

- **OpenCode 2.0.29 or later.** The README states this directly, and both `@opencode/plugin` and `@opencode/client` target `^2.0.29`. [3] [7]
- **Bun.** The README explicitly requires Bun. The published CLI has a Bun shebang, and the bundled plugin imports `bun:sqlite`; do not assume a Node-only runtime is supported. [7]
- **OpenCode 2 must be discoverable on the scheduler's captured `PATH`.** The installer captures a sanitized environment and chooses a stable Bun executable; the README says to re-run `--install` after PATH or XDG/HOME changes. [7]
- **A running/discoverable OpenCode shared service.** The daemon discovers the shared service and starts it with `opencode service start` if necessary. Secrets, MCP tokens, environment, port, and other service settings belong in `$XDG_CONFIG_HOME/opencode/service.json` (normally `~/.config/opencode/service.json`). [7]
- **OS scheduler:** launchd on macOS or a user systemd timer on Linux. [7]

The `1.0.0` package manifest has **no `engines` field**. Thus no Node version support should be inferred from npm metadata. The Bun requirement and `bun:sqlite` usage are the safer runtime boundary.

## Documented configuration options

There are no documented package-specific `Plugin.define` options. OpenCode V2 generally supports an object plugin entry with an `options` object, but this package's `setup(ctx)` does not read `ctx.options`; it registers its tools and commands directly. Supplying arbitrary plugin options should therefore not be represented as supported configuration for `opencode-tasks`. [5] [6]

The package documents configuration through task files, CLI flags, and the service environment instead:

### Recurring task frontmatter

Create files under `~/.config/opencode/tasks/*.md`; the filename becomes the task name. Documented fields are:

- `schedule` — required, standard five-field cron expression in the system local timezone.
- `cwd` — required working directory; `~` expands to `HOME`.
- `description` — optional human-readable description.
- `session_name` — optional named session reused across runs.
- `model` — optional `provider/model#variant`; service default otherwise.
- `agent` — optional agent name; service default otherwise.
- `timeout` — default `1h`; examples include `30m`, `2h`, `1d`; bare numbers mean seconds.
- `permission` — V2 ordered ruleset, with legacy V1 permission objects also accepted.
- `enabled` — default `true`; set `false` to disable.

The last matching V2 permission rule wins. Broad denies should come first and narrow allows later; unattended runs cannot wait for an `ask` approval. [7]

### CLI and commands

The README documents these CLI operations:

- `--install`, `--uninstall`
- `--install-skill`
- `--status [--limit N]`
- `--list [--limit N]`
- `--schedule-task --help`
- `--run-once`
- `--help`

One-off scheduling supports `--prompt`, `--description`, `--cwd`, `--at` or `--now`, `--task`, `--session-name`, `--model`, `--agent`, and `--permission`. The plugin exposes V2 Code Mode tools named `schedule_task`, `list_tasks`, `cancel_task`, `task_history`, `get_task_instructions`, `start_loop`, `list_loops`, and `stop_loop`. It also registers `/loop`, `/loop-list`, and `/loop-stop`. [5] [7]

### Service/daemon settings

The daemon shares OpenCode's service. Put secrets, MCP tokens, environment, port, and other service settings in `service.json`; the daemon does not forward task-specific environments or the obsolete `background-subagents` flag. The installer stores the staged daemon under `~/.local/share/opencode-tasks/`. [7]

## Strongest evidence-based customization plan

1. **Prefer supported, configuration-first customization.** Keep `opencode-tasks@1.0.0` pinned and express behavior in task markdown frontmatter. Start with `schedule`, `cwd`, `description`, `agent`, `model`, `session_name`, `timeout`, `enabled`, and an explicit V2 ordered `permission` ruleset. This is the package's documented customization surface and avoids maintaining a fork. [7]
2. **Use CLI/Code Mode for dynamic task creation.** Use `schedule_task` or the pinned `bunx opencode-tasks@1.0.0 --schedule-task ...` flow for one-off jobs. Use `--task <name>` when a one-off should copy a recurring task's prompt/settings. Use the loop commands for session-bound recurring prompts. [5] [7]
3. **Do not claim arbitrary plugin options are supported.** Although OpenCode V2 supports `{ "package": ..., "options": ... }` entries generally, `opencode-tasks` does not consume `ctx.options`. A config object is not a demonstrated customization mechanism for this package. [5] [6]
4. **For code-level changes, fork the official repository and preserve the V2 contract.** Keep a default `Plugin.define({ id: "opencode-tasks", async setup(ctx) { ... } })` export, build it to an ESM `dist/index.js`, retain the `@opencode/plugin` V2 dependency and `@opencode/client` V2 range, and expose a package export matching the OpenCode loader. Test the installed packed artifact rather than only a workspace-linked copy. This follows OpenCode's official published-plugin guidance. [4] [5] [6]
5. **Customize the scheduler separately from the plugin.** The plugin has no timers or event subscriptions; the daemon is the separate `dist/cli.js` component. Changes to scheduling cadence, service environment, or worker behavior belong in the daemon/installer layer, not in a fictitious plugin-options block. [4] [7]

## Verification steps before enabling

1. Confirm the exact package metadata:

   ```sh
   npm view opencode-tasks@1.0.0 version main exports dependencies peerDependencies peerDependenciesMeta
   ```

2. Add the pinned package with OpenCode V2:

   ```sh
   opencode plugin add opencode-tasks@1.0.0
   opencode plugin list
   opencode plugin check
   ```

3. Install the pinned daemon and verify it:

   ```sh
   bunx opencode-tasks@1.0.0 --install
   bunx opencode-tasks@1.0.0 --status
   ```

4. Restart the service after installation or upgrade, then verify that the plugin's V2 tools and `/loop` commands are visible. The package README specifically states that slash-command files do not need to be installed separately. [7]
5. Create a harmless test task with a temporary `cwd`, restrictive V2 permissions, and `enabled: false` first. Use `get_task_instructions` or `--run-once` only after checking the service and path environment.
6. If using a fork, run the repository's Bun build/typecheck/tests and install the packed tarball in a clean OpenCode V2 environment. Verify that the package export resolves to `dist/index.js` and that the loaded default export exposes the V2 plugin definition.

## Warnings and uncertainty boundaries

- **Do not mix V1 and V2 versions.** `0.5.3` is explicitly the last V1 release and uses `@opencode-ai/plugin`; `1.0.0` is the V2 release and uses `@opencode/plugin`. [2] [7]
- The V2 peer is declared **optional** in npm metadata, but the plugin source imports it and the V2 contract requires it. Treat it as required for a functioning V2 host, not as evidence of Node compatibility. [2] [5]
- The package has no `engines` declaration in `1.0.0`; Bun is required by the README and implementation evidence, so Node-only installation is unsupported/uncertain.
- The scheduler installer can remove **unmodified** legacy V1 `loop.md`, `loop-stop.md`, and `loop-list.md` files. Customized command files are preserved but may shadow the plugin commands; review them before running `--install`. [7]
- `permission` accepts legacy V1 task-file shapes for migration, but that does not make the package's plugin entrypoint V1-compatible.
- No package-specific plugin `options` schema or documented `ctx.options` behavior was found. Do not add an options object to the manifest unless a future package release documents and implements one.

## References

[1]: https://www.npmjs.com/package/opencode-tasks "npm package page for opencode-tasks"
[2]: https://registry.npmjs.org/opencode-tasks "npm registry metadata for opencode-tasks"
[3]: https://raw.githubusercontent.com/jdormit/opencode-tasks/main/package.json "Official opencode-tasks package.json"
[4]: https://raw.githubusercontent.com/jdormit/opencode-tasks/main/tsup.config.ts "Official opencode-tasks build configuration"
[5]: https://raw.githubusercontent.com/jdormit/opencode-tasks/main/src/plugin.ts "Official opencode-tasks V2 plugin source"
[6]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin development documentation"
[7]: https://raw.githubusercontent.com/jdormit/opencode-tasks/main/README.md "Official opencode-tasks README"
