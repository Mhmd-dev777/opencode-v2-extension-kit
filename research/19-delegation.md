# `opencode-delegation` — OpenCode V2 compatibility report

**Research status:** `v1-only` / **blocked for direct V2 use**  
**Package identity:** unambiguous: the public npm package `opencode-delegation` exists, with latest version `0.1.2`.  
**الخلاصة:** الحزمة موجودة وموثقة على npm، لكن نقطة الدخول المنشورة هي V1 وليست V2؛ لا ينبغي تفعيلها في OpenCode V2 قبل port حقيقي إلى API الجديد.

## Verified conclusion

There is **no real V2 plugin entrypoint** in the published `opencode-delegation@0.1.2` artifact.

Evidence from the authoritative npm registry metadata and downloaded tarball:

- `package.json` declares `main: "dist/plugin.js"`, ESM (`"type": "module"`), and exports `./dist/plugin.js`.
- The published `dist/plugin.js` uses `export default (async () => { return { ... } })`. It returns V1 string-keyed hooks: `"tool.definition"`, `"tool.execute.after"`, and `event`.
- The declaration file has the same V1 shape: `declare const _default: () => Promise<{ ... }>`.
- The package declares the peer `@opencode-ai/plugin: "*"`; it does **not** declare or import `@opencode/plugin`.
- There is no `Plugin.define({ id, setup })` entrypoint, which the official V2 migration guide identifies as the V2 form.

The official OpenCode V2 migration guide says V1 plugin implementations do not run in V2 and shows the required V2 shape as `import { Plugin } from "@opencode/plugin"` plus a default `Plugin.define({ id, async setup(ctx) { ... } })`. Therefore this package is not V2-compatible merely because its npm name, ESM format, or package installation succeeds. [4]

The package's README also documents the old singular `"plugin"` configuration key and V1-style hook names. OpenCode V2 configuration uses `"plugins"`; the V2 docs support exact npm versions such as `package@1.2.0`. [1] [3]

## Safe package specification and command

**Exact safe resolution/pin:** `opencode-delegation@0.1.2`

The npm registry lists exactly three published versions: `0.1.0`, `0.1.1`, and `0.1.2`; `latest` is `0.1.2`. No version in the registry metadata is identified as a V2 port. [1]

For the OpenCode V2 package manager, the exact command corresponding to that pin is:

```sh
opencode plugin add opencode-delegation@0.1.2
```

This is the **correct V2 installation syntax**, but it is **not activation-safe for V2** because the installed package is V1-only. Treat the command as a reproducible package-resolution test, not approval to enable the plugin in a V2 runtime. Do not put it in an active V2 `plugins` list until a port is produced and tested. The official V2 docs state that exact npm versions remain pinned and document `opencode plugin add <package>@<version>`. [3]

The package README instead says `npm install --save-dev opencode-delegation` and uses `"plugin": ["opencode-delegation"]`; that is package-authored V1 guidance, not the native V2 installation/configuration form. [1] [2]

## Package versions and metadata

- **Latest / recommended for reproducibility:** `0.1.2` (published 2026-06-01 according to registry metadata).
- **Other published versions:** `0.1.0`, `0.1.1`.
- **License:** MIT.
- **Module:** ESM (`"type": "module"`).
- **Entrypoint:** `dist/plugin.js`; declarations at `dist/plugin.d.ts`.
- **Exports:** `.` maps to `./dist/plugin.js` for `import` and `./dist/plugin.d.ts` for types.
- **Runtime dependencies:** none listed.
- **Development dependency:** `typescript: ^5.4.0` (not a runtime dependency).
- **Engines:** no `engines` field is declared. The registry's `_nodeVersion: 24.14.0` is the publisher environment, **not** a minimum runtime requirement.
- **Repository:** no public `repository` field appears in the registry metadata or package manifest. The npm page exposes the package README but no authoritative source repository link. The registry `gitHead` values are commit hashes without a repository URL; they are not sufficient to identify a source repository.

## Peer dependency and V1 indicator

The exact peer dependency is:

```json
{
  "@opencode-ai/plugin": "*"
}
```

This is a strong V1 indicator. The official V2 migration example replaces the V1 import `@opencode-ai/plugin` with `@opencode/plugin` and replaces the returned hook object with `Plugin.define({ id, setup })`. [4]

The absence of a runtime import in `dist/plugin.js` does not make the package V2-compatible: the exported implementation itself is the old V1 return-object contract, and its type declaration references V1 SDK types (`@opencode-ai/sdk` for the event type).

## Runtime requirements

**Verified requirements:**

1. An OpenCode plugin loader that can load an ESM package with `dist/plugin.js` as the default export.
2. The V1 OpenCode plugin API, specifically the returned hook-object contract and the V1 hook names used by the package.
3. A model/provider configuration that supplies the worker agent's configured model; the README defaults that model to `opencode/big-pickle`.
4. Project access to the bundled agent and skill files if the documented delegation workflow is desired.

**Not declared:** no Node version, Bun version, OS, CPU, memory, or network minimum appears in the package manifest. OpenCode V2 itself has separate installation/runtime requirements; the V2 intro documents the V2 CLI installation methods but does not turn this V1 package into a V2 plugin. [5]

## What the package actually does

The published code is a hook-only V1 plugin. It does not register a custom `delegate_task` tool. Instead it:

- appends a delegation reminder to the `bash` tool description through `tool.definition`;
- for `bash` results over **300 lines**, truncates the output and adds test-summary, first-error, and stderr indicators through `tool.execute.after`;
- records `session.error` events for debug monitoring;
- relies on OpenCode's built-in `task` tool with `subagent_type: "worker"`.

The bundled `worker.md` defines a subagent with model `opencode/big-pickle`, `steps: 20`, command/read/search permissions, and denied edit/task/user-interaction permissions. The bundled `delegation-manager` skill tells the main agent when to delegate and gives prompt-crafting rules. These are package-authored behaviors, not proof of V2 API support. [1] [2]

## Documented configuration options

The following are documented by the package README or bundled files. They are separated from native V2 syntax because the README examples use V1 names.

- **Worker model:** `agent.worker.model`, default `opencode/big-pickle`; README says it may be changed to another inexpensive model.
- **Worker agent description:** `agent.worker.description`.
- **Worker mode:** `agent.worker.mode: "subagent"`.
- **Worker step budget:** `agent.worker.steps: 20`.
- **Worker permissions:** `bash`, `read`, `glob`, and `grep` allowed; `edit`, `task`, `todowrite`, `question`, and `webfetch` denied in the bundled definition.
- **Skill discovery:** README documents `skills.paths: ["./node_modules/opencode-delegation/skill"]` and says the path is additive.
- **Alternative file installation:** copy `agent/worker.md` to `.opencode/agents/worker.md` and the delegation skill directory to `.opencode/skills/delegation-manager`.
- **Delegation hint policy:** README says quick commands are generally for less than 30 seconds and less than 200 output lines; longer/high-output work should use `task({ subagent_type: "worker" })`.
- **Output trimming threshold:** implementation constant is 300 lines. This threshold is not exposed as a documented config option.
- **Plugin options object:** no package-level options schema or option-reading code is documented. Do not invent an `options` object for this package.

## Strongest evidence-based customization plan

Because the published package is V1-only, the strongest plan is a **source port/fork**, not a configuration workaround:

1. **Do not enable `opencode-delegation@0.1.2` in V2.** Keep the exact version only as a forensic/reproducibility reference.
2. **Port the entrypoint to the official V2 contract:** import `Plugin` from `@opencode/plugin`; default-export `Plugin.define({ id: "opencode-delegation", async setup(ctx) { ... } })`. The stable ID is required by the V2 guide. [4]
3. **Map hooks using the official migration destinations:**
   - `tool.definition` → `ctx.tool.transform(...)` to augment the bash definition;
   - `tool.execute.after` → `ctx.tool.hook("execute.after", ...)` to trim bash output;
   - `event` → `ctx.event.subscribe(...)` for session-error monitoring.
   The migration guide explicitly lists these mappings. [4]
4. **Keep the behavior in source, not undocumented package options.** Preserve the 300-line truncation constant and the summary extraction logic, but expose a threshold only if the fork intentionally adds and documents a V2 `options` schema.
5. **Use V2 file discovery for the worker assets:** put the worker definition at `.opencode/agents/worker.md` and the skill at `.opencode/skills/delegation-manager/SKILL.md`. The V2 migration guide prefers the `.opencode/skills/<skill-id>/SKILL.md` layout and says agent/skill definitions continue to work in V2. [4]
6. **Configure the worker model and permissions in the V2 agent definition**, starting from the package's documented defaults. Select the actual cheap model available to the deployment; `opencode/big-pickle` is a package default, not a guaranteed provider entitlement.
7. **Install the fork with an exact V2 pin** (a full Git commit or a versioned package) and configure it under the plural V2 `plugins` key. Test loading, bash definition transformation, long-output trimming, and session-error handling in the target OpenCode V2 build before marking it reviewed.

This plan is evidence-based because it changes precisely the API elements the official migration guide identifies as incompatible, while preserving the package's documented agent/skill behavior. A simple rename from `plugin` to `plugins`, a package reinstall, or changing only the peer dependency would not be sufficient: the official documentation explicitly warns that V1 implementations do not run in V2. [4]

## Verification steps for a future V2 port

1. Inspect the built artifact and confirm `@opencode/plugin` plus `Plugin.define` are present and `@opencode-ai/plugin` is absent.
2. Confirm the default export has a stable V2 plugin ID and a `setup(ctx)` function.
3. Install the exact build with `opencode plugin add <exact-package-or-git-commit>` and run `opencode plugin list` / `opencode plugin check` as appropriate for the target build. [3]
4. Start OpenCode V2 with a test project and verify the plugin loads without an API/peer error.
5. Inspect the bash tool description and verify the delegation hint is appended once.
6. Run a synthetic bash command with more than 300 output lines and verify the output is truncated with summary metadata while short output is unchanged.
7. Emit or reproduce a session error and verify the V2 event subscription handles it without crashing the host.
8. Verify the worker agent and delegation skill are discovered from `.opencode/agents` and `.opencode/skills` and that permissions prevent editing and nested delegation.

## Warnings and uncertainty

- **V2 compatibility:** verified negative. No real V2 entrypoint is present in the published latest package.
- **Source repository:** unresolved/not exposed. Do not infer an owner or Git URL from the npm maintainer name or `gitHead` hash.
- **Package quality/release freshness:** npm shows 0 weekly downloads and only three versions at the time of research; this is context, not a security judgment.
- **Model availability:** `opencode/big-pickle` is documented as the default, but availability depends on the configured provider/account.
- **Threshold discrepancy:** README guidance mentions a quick-command cutoff of `<30s` and `<200 lines`, while the implementation truncates only after `>300` lines. Treat these as separate guidance and behavior thresholds.
- **Installation versus compatibility:** `opencode plugin add opencode-delegation@0.1.2` is syntactically the correct exact V2 package-install command, but installing it does not establish V2 compatibility and should not be treated as approval to activate it.

## References

[1]: https://registry.npmjs.org/opencode-delegation "npm registry metadata for opencode-delegation"
[2]: https://www.npmjs.com/package/opencode-delegation "npm package page and published README for opencode-delegation"
[3]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin configuration and management"
[4]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 plugin migration guide"
[5]: https://opencode.ai/v2/docs "Official OpenCode V2 introduction and installation methods"
[6]: https://registry.npmjs.org/opencode-delegation/-/opencode-delegation-0.1.2.tgz "Published opencode-delegation 0.1.2 tarball inspected for entrypoint contents"
