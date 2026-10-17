# falentio/opencode-pstack — OpenCode V2 extension research

**Item ID:** `pstack`  
**Requested name:** `falentio/opencode-pstack`  
**Resolved package:** `@falentio/opencode-pstack`  
**Status:** **V2-compatible for the pinned current release `1.1.0`; do not treat the older `0.x` releases as V2-compatible.**

> **الخلاصة:** الحزمة الحالية لها مدخل V2 حقيقي (`Plugin.define({ id, setup })`) وتستورد `@opencode/plugin`. لكن سجل npm يحتوي أيضاً على إصدارات أقدم (`0.1.0` إلى `0.7.0`) تعتمد على `@opencode-ai/plugin` الخاص بـ V1. استخدم الإصدار المثبت `@falentio/opencode-pstack@1.1.0` فقط.

## Authoritative identity and package resolution

The official repository is [falentio/opencode-pstack](https://github.com/falentio/opencode-pstack). Its README describes the project as an OpenCode port of pstack and explicitly says that it targets OpenCode V2 and `@opencode/plugin` 2.x.[1] The repository `package.json` identifies the package as `@falentio/opencode-pstack`, version `1.1.0`, with the same GitHub repository URL.[2]

The npm registry metadata resolves the scoped package unambiguously. Its `latest` dist-tag is `1.1.0`; published versions are `0.1.0`, `0.1.1`, `0.1.2`, `0.2.0`, `0.3.3`, `0.4.0`, `0.5.0`, `0.5.1`, `0.5.2`, `0.5.3`, `0.6.0`, `0.6.1`, `0.6.2`, `0.7.0`, `1.0.1`, `1.0.4`, `1.0.5`, `1.0.6`, and `1.1.0`.[3]

## Real V2 plugin entrypoint

**Verified: yes, in the current repository and the published `1.1.0` bundle.** The official source entrypoint imports `Plugin` from `@opencode/plugin` and exports:

```ts
export default Plugin.define({
  id: "pstack",
  async setup(ctx) {
    // registers skills, agents, tools, and session hooks
  },
})
```

This is the V2 shape documented by OpenCode: a default export produced by `Plugin.define`, with an `id` and `setup(ctx)`.[4] The published package exports `.` and `./server`, both resolving to `./dist/src/index.js` with corresponding type declarations.[2][3] The published tarball's compiled `dist/src/index.js` also imports `@opencode/plugin` and calls `Plugin.define`, so this is not only a source-level claim.

The plugin's setup registers the bundled skills through `ctx.skill.transform`, upserts `poteto-agent` and `comment-sicko` through `ctx.agent.transform`, adds native `poteto_*` tools, and installs session compaction/context hooks.[1][5] The README says that `poteto-mode` or `poteto-mode-compact` can be invoked after startup and that a live session loading `poteto-mode` is the registration proof.[1]

## Exact safe install specification and command

Use the exact npm specification:

```text
@falentio/opencode-pstack@1.1.0
```

Recommended install command:

```sh
opencode plugin add @falentio/opencode-pstack@1.1.0
```

OpenCode V2 documents `opencode plugin add <npm-name>@<version>` and recommends exact package versions when a reproducible install is required.[6] The equivalent project configuration is:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": ["@falentio/opencode-pstack@1.1.0"]
}
```

Do **not** use the unpinned package name in a reproducibility-sensitive manifest. Do not select a `0.x` tag or version. A Git repository shortcut is not needed because an authoritative npm publication exists; if a Git source is ever required, pin a full commit hash rather than a moving branch.

## Versions, V1 indicators, dependencies, and requirements

The npm metadata shows a clean API-generation boundary:

- `0.1.0` through `0.7.0`: dependency `@opencode-ai/plugin` at `1.18.25`. This is a **V1 indicator**.
- `1.0.1`, `1.0.4`, `1.0.5`, `1.0.6`, and `1.1.0`: dependency `@opencode/plugin` at `2.0.12`. These are the V2 line.[3]
- Current `latest`: `1.1.0`, published under the npm `latest` dist-tag.[3]
- Package module format: ESM (`"type": "module"`).[2][3]
- Exact runtime dependency: `@opencode/plugin: "2.0.12"`.[2][3]
- **Peer dependencies:** none are declared in the repository manifest or npm metadata.[2][3]
- Node engine: `>=20`.[2][3]
- The repository declares `pnpm@11.18.0` as its package manager for development; this is not an end-user runtime peer requirement when installing through `opencode plugin add`.[2]

Operational requirements documented by the project are narrower than npm dependencies: its stacking and PR workflows use ordinary `git` branches plus `gh`, and the full live verification flow needs model authentication. These are workflow prerequisites, not package-manager peer dependencies.[1]

OpenCode's V2 migration guide states that V1 plugin implementations do not run in V2 and must be ported to the new API.[7] Therefore, the package name alone is insufficient evidence: the V1/V2 dependency split above is material.

## Documented configuration options

**No plugin-specific configuration options are documented or implemented for the current entrypoint.** The README documents a string package entry in `opencode.json`, not an options object.[1] The source entrypoint accepts `ctx` and uses the plugin context for registration, but does not read `ctx.options` or define an options schema.[5]

The available behavior is therefore fixed by the bundled skills, agents, tools, and hooks. OpenCode itself supports an object form with an `options` value for plugins, but that generic facility does not create pstack options automatically; passing undocumented keys would be speculative.[4][6]

**Documented options array:**

- None for `@falentio/opencode-pstack@1.1.0`.

## Strongest evidence-based customization plan

1. **Pin the package at `1.1.0` first.** Keep the package entry as the exact string above. This preserves the verified V2 dependency and avoids accidentally selecting the old V1 line.
2. **Layer project-specific behavior with native OpenCode files.** Add project-specific skills under the V2-preferred `.opencode/skills/<skill-id>/SKILL.md` layout and add local project definitions where appropriate. This is safer than attempting undocumented pstack options. OpenCode V2 discovers local plugin and file-based definitions from `.opencode/`.[6][7]
3. **Do not overwrite pstack IDs casually.** The pstack README says its transforms add to the session catalog and do not replace existing skills or clobber them; its `agents/` directory is the source of truth for the two bundled subagents.[1] Use distinct local IDs unless an intentional shadowing test proves the desired precedence.
4. **For changes to the bundled playbooks, fork or maintain a downstream package.** Edit the repository's `skills/`, `agents/`, or source transforms, run the project's `pnpm check`, publish an internal package, and pin that package to an exact version or full Git commit. This is the strongest plan because it follows the repository's stated source-of-truth layout and avoids relying on nonexistent runtime options.[1]
5. **Preserve V2 API boundaries.** Any downstream code should continue to export a default V2 `Plugin.define({ id, setup })` object and import `@opencode/plugin`, not `@opencode-ai/plugin`.[4][5][7]

**Recommended options array:**

- `Use no options object; configure by adding distinct native `.opencode` skills/agents.`
- `For bundled-skill or bundled-agent edits, maintain a fork/internal republish and pin its exact release or full commit.`
- `Keep the V2 entrypoint on @opencode/plugin and Plugin.define; do not back-port the 0.x V1 dependency.`

## Verification steps for the parent manifest

1. Confirm the manifest source is the npm package, with exact value `@falentio/opencode-pstack@1.1.0`.
2. Run `opencode plugin add @falentio/opencode-pstack@1.1.0` in a disposable V2 config, or add the exact string to `opencode.json`.
3. Run `opencode plugin list` and `opencode plugin check` to confirm the package is installed and recognized by the V2 CLI.[6]
4. Start a fresh OpenCode V2 session and invoke `/poteto-mode` or `/poteto-mode-compact`; the README identifies loading `poteto-mode` in a live session as the registration proof.[1]
5. Confirm the two subagents `poteto-agent` and `comment-sicko` are available with `mode: subagent`, and exercise at least one `poteto_*` tool.[1]
6. If testing a checkout rather than npm, use the repository's documented symlink layout under `.opencode/plugins/`; do not assume the package directory's `package.json` exports are used for checkout discovery.[1]
7. For a reproducible release audit, verify the resolved package version is `1.1.0`, Node is `>=20`, and the installed dependency is `@opencode/plugin@2.0.12` rather than `@opencode-ai/plugin`.[2][3]

## Warnings and unresolved edges

- **Historical V1 trap:** `@falentio/opencode-pstack@0.x` is not the same compatibility line. Its metadata declares `@opencode-ai/plugin@1.18.25`; do not mark those releases V2-compatible.[3]
- The current V2 package has a hard dependency on exactly `@opencode/plugin@2.0.12`, not a peer range. OpenCode's plugin-build documentation advises using versions compatible with the targeted OpenCode release and testing the installed package, so test against the exact V2 build used by the project.[4]
- No plugin-specific options are documented or consumed. Treat any claimed option such as model selection, strict mode, or tool toggles as **unverified** unless a future source release adds `ctx.options` handling.
- The port intentionally cannot reproduce Cursor's per-subagent model selection; the README says all subagents inherit the parent chat model.[1]
- The plugin does not port Cursor's Slack `automations/benny` runtime. It also uses `git`/`gh` conventions rather than Graphite/`gt` for stacking workflows.[1]
- This report verifies source and package metadata. A live OpenCode session was not launched in this research pass; perform the runtime verification steps above before enabling it in production.

## References

[1]: https://github.com/falentio/opencode-pstack/blob/main/README.md "Official opencode-pstack README"
[2]: https://raw.githubusercontent.com/falentio/opencode-pstack/main/package.json "Official opencode-pstack package.json"
[3]: https://registry.npmjs.org/@falentio%2fopencode-pstack "npm registry metadata for @falentio/opencode-pstack"
[4]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin build documentation"
[5]: https://raw.githubusercontent.com/falentio/opencode-pstack/main/src/index.ts "Official V2 source entrypoint"
[6]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin installation and configuration documentation"
[7]: https://opencode.ai/v2/docs/migrate-v1/ "Official OpenCode V2 V1 migration documentation"
