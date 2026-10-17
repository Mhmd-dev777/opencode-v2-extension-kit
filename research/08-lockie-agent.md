# oh-y-lockie-agent — OpenCode V2 extension research

**Item / العنصر:** `lockie-agent`  
**Requested name:** `oh-y-lockie-agent`  
**Research date:** 2026-10-18  
**Scope:** verify the npm package, repository README/package manifest, V2 entrypoint, install pin, dependencies, runtime requirements, configuration, and a safe customization path.

## Conclusion / الخلاصة

`oh-y-lockie-agent@2.0.1` is a **real OpenCode V2 plugin** and has a concrete V2 entrypoint. The published artifact exports `dist/index.js`; that file imports `Plugin` from `@opencode/plugin` and returns `Plugin.define({ id: "oh-y-lockie-agent", setup: setupLockie })`.[1] The repository source says the same thing.[2] This is the V2 package name, not the V1 package name: the current 2.x package uses `@opencode/plugin`, whereas the registry metadata for the earlier 1.x releases uses `@opencode-ai/plugin` and `@opencode-ai/sdk`.[1]

Use an **exact version pin** so an unpinned install cannot silently move between the V1-era and V2-era release lines:

```bash
opencode plugin add oh-y-lockie-agent@2.0.1
```

The equivalent configuration entry is:

```jsonc
{
  "plugins": ["oh-y-lockie-agent@2.0.1"]
}
```

The exact CLI form follows the official OpenCode V2 plugin-management syntax for versioned packages.[3] The repository README documents the unpinned form `opencode plugin add oh-y-lockie-agent`, but the pinned form is safer for a reproducible V2 manifest.[4]

## Authoritative identity and version evidence

- **npm registry:** `latest` is `2.0.1`; the registry record lists the 2.0.1 tarball and package metadata.[1]
- **Published package:** `oh-y-lockie-agent@2.0.1` has `type: "module"`, `main: "./dist/index.js"`, TypeScript declarations at `./dist/index.d.ts`, and an `exports` entry whose import target is `./dist/index.js`.[5]
- **Repository:** `https://github.com/ddddjaak/oh-y-lockie-agent` is linked by the README and exposes the V2 source entrypoint.[2][4] The package manifest itself does **not** declare a `repository` field, so the GitHub association is supported by the project README/source URL rather than by an npm `repository` field.
- **Version mismatch to record:** the repository `main` branch currently reports package version `2.0.0` and describes 63 skills, while the published npm 2.0.1 artifact reports 56 skills. The installed-package facts in this report (version, dependencies, entrypoint, configuration schema) are taken from the 2.0.1 artifact; do not merge the two skill counts.[1][2][5]
- **Stale README line:** the published 2.0.1 README's final version section still says “Plugin version: 1.0.0 (V2 API migration)” even though its package manifest and registry record say `2.0.1`. Treat the package manifest/registry as authoritative for the release version and the README as useful but partially stale.[1][4][5]

## V2 compatibility and V1 indicators

### Verified V2 entrypoint

The published entrypoint is not merely a README claim:

```js
import { Plugin } from "@opencode/plugin";
import { setupLockie } from "./v2/runtime.js";
export default Plugin.define({ id: "oh-y-lockie-agent", setup: setupLockie });
```

The repository TypeScript source is equivalent:

```ts
import { Plugin } from "@opencode/plugin";
import { setupLockie } from "./v2/runtime.js";

export default Plugin.define({ id: "oh-y-lockie-agent", setup: setupLockie });
```

This matches the official V2 plugin contract: import `Plugin` from `@opencode/plugin`, export the default result of `Plugin.define`, and provide `setup(ctx)`.[2][6]

The published runtime registers agents, skills, MCP definitions, and a tool through V2 transforms, and installs V2 session hooks for prompt/context routing. The package's runtime comments and implementation use `ctx.agent.transform`, `ctx.skill.transform`, `ctx.mcp.transform`, `ctx.tool.transform`, and `ctx.session.hook`, which are V2 concepts.[5] This is stronger evidence than the README label alone.

### V1 check

- **Current 2.0.1:** package dependency is `@opencode/plugin: ^2.0.6`; there is no `@opencode-ai/plugin`, no `@opencode-ai/sdk`, and no `peerDependencies` field.[5]
- **Historical 1.x releases:** registry metadata for 1.0.0 through 1.2.1 lists `@opencode-ai/plugin: ^1.17.0` and `@opencode-ai/sdk: ^1.18.9` as dependencies.[1]
- **Decision:** do not install a 1.x release for this V2 manifest. Pin `2.0.1`.
- **No dual V1/V2 export was found** in the published 2.0.1 entrypoint. It is a direct V2 `Plugin.define` export. The official V2 documentation explains that a dual-compatible package would visibly also export a V1 `server()` function; this package's published entrypoint does not do that.[5][6]

## Exact package/dependency facts

**Safe install specification:** `oh-y-lockie-agent@2.0.1`  
**Safe command:** `opencode plugin add oh-y-lockie-agent@2.0.1`

Published 2.0.1 `package.json`:

- `name`: `oh-y-lockie-agent`
- `version`: `2.0.1`
- `type`: `module`
- `main`: `./dist/index.js`
- `exports["."]`: import `./dist/index.js`, types `./dist/index.d.ts`
- `bin`: `oh-y-lockie-agent -> scripts/setup-mcp.mjs`
- **Runtime dependencies:** `@opencode/plugin ^2.0.6`, `jsonc-parser ^3.3.1`, `zod ^4.1.8`.[5]
- **Development dependencies:** `@types/node ^22`, `typescript ^5.8`, `vitest ^4.1.10`.[5]
- **Peer dependencies:** none declared. There is no `peerDependencies` key in the published manifest.[5]
- **Engine field:** none declared. The README states Node.js `>=20`, but npm metadata does not enforce that through an `engines` field.[1][4][5]

## Runtime requirements / متطلبات التشغيل

Verified or explicitly documented requirements are:

1. **OpenCode >= 2.0 / V2 API.** This is stated in the published README.[4]
2. **Node.js >= 20.** This is stated in the published README. The package itself does not declare `engines`, so the requirement is documented rather than npm-enforced.[4][5]
3. **A configured OpenCode provider.** The README lists a provider configured in `opencode.json` as a prerequisite.[4]
4. **A V2-compatible OpenCode release matching the `@opencode/plugin` API.** Official OpenCode guidance says published plugins should use versions compatible with the target OpenCode release and should be tested against the installed package, not only a workspace-linked copy.[6]
5. **Optional network/runtime dependencies:** the plugin's default update check calls the npm registry; its default MCP definitions invoke local commands such as `codegraph` and `npx`. Disable or replace these if the environment is offline or does not have those commands.

## Documented configuration options

Configuration files are loaded in this order, with later/higher-priority values overriding lower-priority values: project `.opencode/oh-y-lockie-agent.jsonc`, user `~/.config/opencode/oh-y-lockie-agent.jsonc`, then the package default config.[4][5]

### Agent overrides

```jsonc
{
  "agent": {
    "firmware": { "model": "provider/model-name" },
    "code-reviewer": { "disable": true }
  }
}
```

The published schema accepts `agent.<name>.model` (non-empty string) and `agent.<name>.disable` (boolean). Built-in definitions are protected from being overwritten by user-defined IDs; the runtime skips an existing agent and only creates missing registrations.[4][5]

### MCP definitions

The default package configuration documents four local servers: `codegraph`, `context7`, `memory`, and `sequential-thinking`. Each MCP entry supports `type` (`local` or `remote`), `command` (string array), `url` (string), and `enabled` (boolean) in the published schema.[5] Runtime injection is additive: an existing server with the same name is not overwritten.[4][5]

### Update checks

`updateCheck.enabled` disables/enables the notify-only npm update check; `updateCheck.intervalHours` accepts an integer from 1 to 720, with a documented default of 24 hours. The check does not auto-update the package; it shows a toast or writes a notice log.[4][5]

### Target context (reserved / currently ineffective)

The schema accepts `target.chip`, `target.family`, `target.sdk`, and `target.toolchain`. The comments describe this as a reserved embedded-domain context, for example Chipsea part number, Cortex-M/RISC-V family, SDK, and compiler. However, static inspection of the published 2.0.1 runtime shows that the value is loaded and merged but is not passed into agent prompts or registration. Therefore this is a **validated but currently reserved option**, not a verified way to customize agent behavior.[5]

### Telemetry and environment controls

The published schema accepts top-level `telemetry: boolean`. The runtime enables telemetry unless the value is explicitly `false`, and records routing metadata (not prompt text) under `~/.opencode/oh-y-lockie-agent/telemetry-routes.jsonl`. The README architecture comment says telemetry is “default off,” but the published runtime initializes it as enabled and calls `setTelemetryEnabled(cfg.telemetry !== false)`. This is a material documentation/implementation contradiction; set `"telemetry": false` explicitly for privacy-sensitive use.[4][5]

The README also documents `LOCKIE_DUMP_SNAPSHOT=snapshot.json` for registration smoke tests. The runtime honors that variable and writes a snapshot on the first context cycle.[4][5]

## Strongest evidence-based customization plan

1. **Install the pinned V2 artifact.** Run `opencode plugin add oh-y-lockie-agent@2.0.1`; do not use the floating package name in a reproducible manifest.
2. **Create a project-local override.** Use `<project>/.opencode/oh-y-lockie-agent.jsonc`, so the customization is reviewable and does not alter the global OpenCode configuration.
3. **Start with supported, effective controls:** assign models per agent, disable agents that are not wanted, and disable/replace MCP entries that are not installed or trusted. Set `telemetry: false` explicitly unless route telemetry is desired. Keep `updateCheck.enabled: false` in air-gapped or privacy-sensitive environments.
4. **Do not rely on `target` yet.** It is schema-supported but reserved and not consumed by the 2.0.1 runtime. If chip-specific behavior is required, use a source fork and add target-context injection to the runtime/agent prompt path rather than assuming the field changes responses.
5. **For behavior changes, fork the identified GitHub repository** and edit the evidence-backed extension points: `src/agents/` for agent definitions/prompts, `skills/` for skill content/routing, and `src/v2/runtime.ts` for registrations/hooks. Build and test the fork, then load it through a local `.opencode/plugins/` entry or a pinned Git revision. Do not patch the cached npm package in place.
6. **Smoke-test the installed V2 plugin** with:

   ```bash
   LOCKIE_DUMP_SNAPSHOT=snapshot.json \
   opencode run --standalone --agent firmware "Reply with exactly: OK"
   ```

   For the published 2.0.1 artifact, inspect that the snapshot contains the firmware primary agent plus 14 subagents, 56 skills, and the `lockie_list_agents` tool. Also test a routing prompt and verify that a pre-existing user agent/MCP/skill is not overwritten. The README documents this validation pattern, while the repository `main` branch currently reports a different skill count, so test the **installed pinned artifact**, not the branch count.[4][5]

## Warnings / uncertainty

- **Resolved name:** the npm package exists and the repository name matches `oh-y-lockie-agent`; this item is not unresolved.
- **Version line warning:** `1.x` is V1-oriented because it uses `@opencode-ai/plugin`; `2.0.1` is the V2 line because it uses `@opencode/plugin`.
- **No npm peer dependency contract:** consumers should not infer a peer range from metadata; compatibility is expressed as a runtime dependency on `@opencode/plugin ^2.0.6` and the README's OpenCode `>=2.0` claim.
- **No npm `engines` enforcement:** Node `>=20` is documented but not encoded in `package.json`.
- **Repository/package drift:** GitHub `main` package metadata says `2.0.0` and 63 skills, while npm 2.0.1 says 56 skills. Pin and verify the npm artifact used by the manifest.
- **Stale README version text:** the published README says “1.0.0” in its final version section; this conflicts with the registry and package manifest.
- **Telemetry default conflict:** comments say default off, but runtime behavior is default on unless `telemetry:false`; use the explicit setting.
- **Reserved target context:** `target.*` validates and merges but is not verified to affect agent prompts in 2.0.1.

## References

[1]: https://registry.npmjs.org/oh-y-lockie-agent "npm registry metadata for oh-y-lockie-agent"
[2]: https://raw.githubusercontent.com/ddddjaak/oh-y-lockie-agent/main/src/index.ts "oh-y-lockie-agent V2 source entrypoint"
[3]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin installation and management documentation"
[4]: https://raw.githubusercontent.com/ddddjaak/oh-y-lockie-agent/main/README.md "oh-y-lockie-agent repository README"
[5]: https://registry.npmjs.org/oh-y-lockie-agent/-/oh-y-lockie-agent-2.0.1.tgz "Published oh-y-lockie-agent 2.0.1 package artifact"
[6]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin development documentation"
