# opencode-engram-learning — OpenCode V2 extension review

**الحكم / decision:** The name resolves unambiguously to the official GitHub repository `nagisanzenin/engram` and the npm package `opencode-engram-learning`. A real V2 entrypoint is present in the published `1.15.1` package, but the package still declares the V1 SDK peer `@opencode-ai/plugin` and the maintainer's V2 verification is tied to an older OpenCode 2.0 beta. Therefore this is **V2 source-compatible with material runtime-validation caveats**, not a clean, natively V2-only package.

## Verified identity and package version

- **Package:** `opencode-engram-learning`.
- **Latest npm dist-tag observed:** `1.15.1`.
- **Exact published package reviewed:** `opencode-engram-learning@1.15.1`.
- **Repository:** `https://github.com/nagisanzenin/engram`.
- The official README describes the OpenCode integration as supporting both OpenCode V1 and “2.0 beta,” using the same package name. It also describes Engram as a learning system for the human, not an agent-memory plugin. [1]
- npm metadata for `1.15.1` confirms the package name, version, repository, tarball, integrity metadata, and latest package manifest. [3]

## Is a real V2 plugin entrypoint present?

**Yes, verified from the published tarball and repository source.** This is not merely a README claim.

The package manifest has these entrypoints:

```json
{
  "main": "./.opencode-plugin/entry.ts",
  "exports": {
    ".": "./.opencode-plugin/entry.ts",
    "./server": "./.opencode-plugin/entry.ts",
    "./v2": "./.opencode-plugin/v2.ts"
  }
}
```

The published combined entrypoint default-exports:

```ts
{
  id: "engram",
  server,
  setup,
}
```

Thus V1 can use `server()` while V2 can use `id` plus `setup()`. The separate `./v2` export points to `.opencode-plugin/v2.ts`; that file default-exports `{ id: "engram", setup }` and implements V2-domain registration. [2] [3] [5] [6]

The V2 adapter source explicitly states that it has **zero `@opencode-ai/*` imports** and uses a plain `{ id, setup }` object to avoid beta SDK export churn. It feature-detects V2 domains and hook call forms, and its `setup()` wires command/skill/agent reloads, the update tool, session context, shell environment, and cleanup registrations. [5]

This matches the official V2 contract: a V2 plugin default export needs a stable `id` and `setup(ctx)`, while V1 implementations do not run in V2. [7] [9]

## V1 indicators and V2 caveat

The strongest V1 indicator is the published manifest:

```json
"peerDependencies": {
  "@opencode-ai/plugin": "^1.4.3"
}
```

There is **no declared `@opencode/plugin` peer or dependency**. The V1 implementation in `.opencode-plugin/index.ts` imports the V1 package as a type and dynamically loads the V1 update tool from `server()`. [2] [3]

This does **not** prove that the V2 adapter is absent: the V2 file intentionally avoids an SDK import and the combined entry contains a genuine `setup()`. It does mean npm may report a peer mismatch or install warning in a V2-only environment, and the package is not a clean example of the current V2 publishing shape. The official V2 publishing guidance normally shows a package depending on `@opencode/plugin`; Engram instead deliberately avoids that runtime import to survive beta SDK reshuffles. [5] [8]

The repository's V2 guide says the adapter was verified against `opencode2 v0.0.0-next-17444` and that later changes had been source-checked/import-tested but **not re-smoke-tested under a live `opencode2`**. That is the material uncertainty. [4]

## Safe install specification and command

### Recommended pinned specification

```text
opencode-engram-learning@1.15.1
```

This is safer than an unpinned `latest` install because it gives a reproducible package revision. The npm registry identifies `1.15.1` as the current latest release and exposes the exact tarball/integrity metadata. [3]

### Exact CLI command

```sh
opencode plugin add opencode-engram-learning@1.15.1
```

The official OpenCode V2 plugin documentation supports versioned npm package targets and documents the `opencode plugin add <package>@<version>` command. [7]

### Equivalent V2 configuration

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": ["opencode-engram-learning@1.15.1"]
}
```

The Engram V2 installation guide shows the V2 key as `plugins` and the package name as the bare package target. **Do not configure `opencode-engram-learning/v2`**: the package's own guide says OpenCode V2 does not split subpaths from config entries and that npm-package-arg can misparse that form as a GitHub repository specification. The `./v2` export is real for direct/local reference, but it is not the safe package string for the `plugins` array. [4]

If V1 and V2 must run side by side, the repository documents keeping both keys during the transition:

```jsonc
{
  "plugin": ["opencode-engram-learning"],
  "plugins": ["opencode-engram-learning@1.15.1"]
}
```

For a V2-only deployment, use only `plugins`.

## Peer dependencies, engines, and runtime requirements

### Declared package metadata

- **Peer dependency:** `@opencode-ai/plugin ^1.4.3` — a V1 indicator; no `@opencode/plugin` declaration. [2] [3]
- **Runtime package dependencies:** none are declared in the published manifest. `vitest`, `@types/bun`, and `typescript` are development dependencies only. [2] [3]
- **Package engine:** `opencode >=1.0.0 || >=0.0.0-0`, which is broad and does not give a meaningful V2 compatibility floor. [2] [3]
- **Module format:** ESM via `"type": "module"`. [2] [3]

### Operational requirements documented by the project

- An OpenCode V2 runtime, referred to by the project as the `opencode2` binary installed from `@opencode-ai/cli@beta`. OpenCode V2 is itself documented as beta in the Engram guide. [4]
- `python3`; the README says a stock macOS/Linux Python is sufficient and that the engine uses the standard library only. [1]
- A writable local extraction/state location. On first start, the adapter extracts its commands, skills, agents, scripts, and related files into the project `.opencode/`, or into `~/.config/opencode/` when no project OpenCode config exists. [4]
- A configured model provider for real `/learn` sessions. The Engram guide reports that bundled `opencode/*-free` models can fail with `Error: Transport` during the curriculum-architect subagent spawn. This is a beta-runtime/model limitation, not a package peer dependency. [4]
- The package guide reports live smoke testing against `opencode2 v0.0.0-next-17444`; current V2/GA behavior remains a verification item rather than a guaranteed fact. [4]

## Documented configuration and user controls

The project says onboarding needs **“No config”** beyond enabling the plugin. It does not document an Engram-specific `ctx.options` schema, and the V2 adapter does not read `ctx.options`. Do not invent plugin option names. [1] [5]

Documented controls are:

- **OpenCode enablement:** V2 uses the `plugins` array; the OpenCode V2 platform also supports pinned package strings and an object form with `options`, but no Engram-specific option keys are documented. [4] [7] [8]
- **State location:** `ENGRAM_HOME` overrides the default `~/.claude/learning/` state directory. [1]
- **Learning commands:** `/learn`, `/review` or the generated V2 `/review-loop`, and `/coach`, depending on the platform/command surface. The V2 installation guide specifically describes `/learn`, `/review-loop`, and `/coach`. [1] [4]
- **Focus profile:** `python3 scripts/engram.py focus on`, `off`, or `status`, also exposed through the learning/coach flow. [1]
- **Visual encoding preference:** `visuals eager`, `threshold`, or `off`, or request a visual during a lesson. [1]
- **Injected shell variables:** the V2 adapter sets `ENGRAM_ROOT` and `OPENCODE_PLUGIN_ROOT` for shell executions. These are adapter-provided paths, not user configuration options. [4] [5]

`ENGRAM_TODAY` is forwarded by the adapter when already present in the process environment, but the reviewed user README does not present it as a normal configuration option. Treat it as an internal/testing time override, not a stable public setting. [5]

## Strongest evidence-based customization plan

1. **Start with the pinned package and no undocumented options.** Use `opencode-engram-learning@1.15.1` and the V2 `plugins` key. Do not add an options object until a future Engram release documents one. This follows the package's “No config” statement and avoids confusing OpenCode's generic options mechanism with an Engram-supported schema. [1] [4] [7]

2. **Customize data location through `ENGRAM_HOME`.** If state must be isolated per project, backed up, or placed on persistent storage, set `ENGRAM_HOME` in the environment inherited by OpenCode. This is the only explicit state-location override documented by the project. Validate that the chosen directory is writable and that the shell environment reaches the V2 process. [1] [5]

3. **Use the supported command-level controls before changing code.** Prefer `/learn`, `/review-loop`, `/coach`, the `focus` command, and the documented visual modes. These are maintained surfaces and are less fragile than editing generated `.opencode/` files. [1] [4]

4. **For adapter behavior changes, use a local fork rather than patching npm cache files.** The project documents a local-checkout V2 entry as:

   ```jsonc
   {
     "plugins": ["./path/to/engram/.opencode-plugin/v2.ts"]
   }
   ```

   For V2-only customization, edit the fork's `v2.ts` and keep its stable `id` plus `setup(ctx)` contract. If V1 support must remain, preserve the combined `entry.ts` shape `{ id, server, setup }` and the root/`./server` exports. [4] [6] [7]

5. **Keep customizations on documented V2 surfaces.** The adapter already maps session context, shell creation, tool transforms, command reloads, and cleanup into V2. Any fork should use the official V2 context domains and return cleanup from `setup()`, rather than trying to translate V1 hook names directly. [5] [8] [9]

6. **Re-test the installed package, not only a linked checkout.** The official V2 docs require testing the installed package. Verify plugin activation, project-local extraction, command/skill/agent discovery, `/learn`, `/review-loop`, `/coach`, shell variables, and cleanup after reload/removal. Repeat on the exact `opencode2` build intended for deployment because the package's last documented live test is an older beta. [4] [7] [9]

## Verification checklist

- Run `opencode plugin add opencode-engram-learning@1.15.1`.
- Confirm the generated config uses `plugins`, not only V1's `plugin`.
- Run `opencode plugin list` and `opencode plugin check` using the official CLI workflow. [7]
- Start the target `opencode2` binary and confirm the plugin is active rather than merely installed.
- Confirm the first start extracts into the intended project `.opencode/` directory and does not unexpectedly write a different workspace.
- Exercise `/learn`, `/review-loop`, and `/coach`; use a configured provider rather than a bundled `opencode/*-free` model for the subagent path. [4]
- Confirm `~/.claude/learning/` or the chosen `ENGRAM_HOME` contains the expected local JSON state.
- Confirm shell executions receive `ENGRAM_ROOT` and `OPENCODE_PLUGIN_ROOT`.
- Reload/remove the plugin and verify registrations are disposed and do not stack. This follows the official V2 verification guidance. [9]

## Final classification

**Resolved name:** yes.

**Real V2 entrypoint:** yes — verified in the published package: root/`main`/`./server` combined adapter plus explicit `./v2` source, with a V2 `setup()` export.

**V2 status:** **compatible by source and project documentation, but needs validation on the target/current OpenCode V2 runtime**.

**Do not claim:** that it is a native V2-only package, that `@opencode/plugin` is declared, that an Engram `options` schema exists, or that current V2 GA behavior is live-verified.

## References

[1]: https://github.com/nagisanzenin/engram/blob/main/README.md "Official Engram README"
[2]: https://raw.githubusercontent.com/nagisanzenin/engram/main/package.json "Official Engram package.json"
[3]: https://registry.npmjs.org/opencode-engram-learning/1.15.1 "npm registry metadata for opencode-engram-learning 1.15.1"
[4]: https://raw.githubusercontent.com/nagisanzenin/engram/main/INSTALL-OPENCODE-V2.md "Official Engram OpenCode V2 installation guide"
[5]: https://raw.githubusercontent.com/nagisanzenin/engram/main/.opencode-plugin/v2.ts "Official Engram V2 adapter source"
[6]: https://raw.githubusercontent.com/nagisanzenin/engram/main/.opencode-plugin/entry.ts "Official Engram combined V1 and V2 entrypoint"
[7]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin documentation"
[8]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin build documentation"
[9]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1 migration documentation"
