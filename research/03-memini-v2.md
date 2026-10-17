# eleboucher/opencode-memini-v2 — OpenCode V2 extension research

**Research status:** `v2-reviewed-with-caveats`  
**Requested identifier:** `eleboucher/opencode-memini-v2`  
**Resolved install package:** `@eleboucher/opencode-memini-v2`  
**Report language:** English with Arabic-compatible Markdown/text (النص قابل للقراءة بالعربية والإنجليزية).

## Identity and authoritative-source resolution

The exact GitHub repository named in the manifest, `eleboucher/opencode-memini-v2`, does **not** resolve: GitHub's repository API returns HTTP 404. Therefore, the requested GitHub slug is not an authoritative repository identity and must not be treated as a clone/install target. [1]

A current, authoritative upstream repository does exist at `eleboucher/memini`. It contains the V2 OpenCode implementation at `integrations/opencode/plugin/memini-v2.js`, a dedicated V2 package directory at `integrations/opencode/plugin-v2/`, and a V2 README that explicitly documents the package `@eleboucher/opencode-memini-v2`. [2] [3] [4] The npm registry independently confirms that package and publishes version `0.7.36` as the `latest` dist-tag. [5]

**Conclusion on ambiguity:** the repository name in the original request is unresolved as a GitHub repository, but the intended extension is strongly identifiable from the official upstream `eleboucher/memini` repository and the npm package. Do not write `github:eleboucher/opencode-memini-v2` into an enablement manifest; use the npm package below.

## V2 entrypoint and V1 indicators

A real V2 entrypoint is present and published. The upstream source exports a default plain object with `id: "memini"` and `setup(ctx)`. It wires recall through `ctx.session.hook(...)`, capture through `ctx.event.subscribe()`, and a read-only `memini_status` tool through `ctx.tool.transform(...)`. [6] The published package maps both `exports["."]` and `exports["./server"]` to `./dist/index.js`; its packaging script stages `index.js` as a re-export of the V2 `memini-v2.js` source. [4] [7]

The package is intentionally dependency-free. It does not import either `@opencode-ai/plugin` (the V1 SDK indicator) or `@opencode/plugin` (the documented V2 SDK name). Instead, it relies on the fact that the upstream `Plugin.define` helper is an identity function and exports the equivalent `{ id, setup }` shape directly. This is a valid V2 entrypoint shape, but the absence of an SDK dependency means package metadata alone cannot enforce a compatible host API. [3] [6] [8]

The V1 sibling is a different package, `@eleboucher/opencode-memini`, and uses the V1 `{ id, server }` contract and singular `plugin` configuration. The upstream V2 README explicitly says the V1 and V2 packages are not interchangeable. OpenCode's official migration documentation confirms that V1 implementations do not run in V2, that V2 uses `plugins` (plural), and that a V2 plugin uses a stable `id` plus `setup(ctx)`. [3] [8] [9]

## Safe installation specification and command

### Recommended exact pin

Use this exact npm specification for reproducibility:

```text
@eleboucher/opencode-memini-v2@0.7.36
```

The registry reports `0.7.36` as the current `latest` dist-tag and identifies the package as an ES module with `main: ./dist/index.js` and exports for `.` and `./server`. [5] The exact pin is safer than the bare name because OpenCode checks unpinned npm plugins for updates, while exact npm versions remain pinned. [10]

### V2 config entry

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": [
    "@eleboucher/opencode-memini-v2@0.7.36"
  ]
}
```

### CLI command

For the current official OpenCode V2 CLI syntax, use:

```bash
opencode plugin add @eleboucher/opencode-memini-v2@0.7.36
```

The official V2 documentation defines `opencode plugin add <package>@<version>` and supports scoped npm packages and exact versions. [10] The upstream extension README refers to the beta executable as `opencode2 plugin add @eleboucher/opencode-memini-v2`; that is historical beta wording, not a reason to use the unresolved GitHub slug. [3]

For a checkout-only test, the upstream documents a path entry, but this is not the preferred manifest install because it bypasses package installation and update checks:

```jsonc
{
  "plugins": [
    "/absolute/path/to/memini/integrations/opencode/plugin/memini-v2.js"
  ]
}
```

## Versions, dependencies, and runtime requirements

- **Published package:** `@eleboucher/opencode-memini-v2`.
- **Verified version:** `0.7.36`.
- **npm dist-tag:** `latest -> 0.7.36`. [5]
- **Module format:** ESM (`type: "module"`).
- **Entrypoint:** `./dist/index.js`; `exports["."]` and `exports["./server"]` both point there. [5] [7]
- **Runtime dependencies:** none declared in the authoritative package manifest/registry metadata. [5] [7]
- **Peer dependencies:** none declared (`peerDependencies` is absent; therefore the structured peer-dependency list is empty).
- **Engines:** none declared in package metadata. Do not invent a Node or Bun minimum from this package alone.
- **Host requirement:** an OpenCode V2 host that supports the V2 `plugins` array and the V2 plugin shape (`id` + `setup`). Official V2 documentation uses `@opencode/plugin` in source examples, but this package avoids importing it. [8] [9]
- **Service requirement:** a running memini server. Set `MEMINI_BASE_URL` when it is not the default `http://localhost:8080`. The package README calls this out as a requirement. [3]
- **Authentication:** if the memini server requires auth, set `MEMINI_API_KEY` in the environment of the process launching OpenCode; the upstream docs say secrets should not be placed in `opencode.json`. [4]

## Documented configuration options

The upstream integration README documents object-form plugin options. Inline options take precedence over their corresponding environment variables. The same settings apply to the V2 package; in V2, recalled context is injected into the request `system` prompt rather than a synthetic message part. [4]

| Option | Environment variable | Documented default / behavior |
|---|---|---|
| `base_url` | `MEMINI_BASE_URL` | `http://localhost:8080`; memini REST base URL |
| `namespace` | `MEMINI_NAMESPACE` | server handshake; scopes memory to a project |
| `home` | `MEMINI_HOME` | unset; caller personal namespace |
| `recall` | `MEMINI_RECALL` | on; `false` disables recall before a turn |
| `capture` | `MEMINI_CAPTURE` | on; `false` disables capture after a turn |
| `capture_child_sessions` | `MEMINI_CAPTURE_CHILD_SESSIONS` | off; opt in to child/unknown ancestry capture |
| `recall_limit` | `MEMINI_RECALL_LIMIT` | `3`; maximum memories injected per turn |
| `recall_max_tokens` | `MEMINI_INJECT_RECALL_MAX_TOK` | `0`; unlimited recall-block token budget |
| `recall_min_score` | `MEMINI_INJECT_RECALL_MIN_SCORE` | server default `0.5` after handshake |
| `inject_cooldown_ms` | `MEMINI_INJECT_COOLDOWN_MS` | `1800000` ms (30 minutes) |
| `inject_cooldown_prompts` | `MEMINI_INJECT_COOLDOWN_PROMPTS` | `3` user-message/request-hook prompts |
| `recall_budget_ms` | `MEMINI_RECALL_BUDGET_MS` | `2000`; `0` waits for full request timeout |
| `timeout_ms` | `MEMINI_TIMEOUT_MS` | `30000` per memini request |
| `fallback_on_error` | `MEMINI_FALLBACK` | on; `false` surfaces errors instead of silent degradation |
| `auto_update` | `MEMINI_AUTO_UPDATE` | on; `false` disables npm update checks |
| *(no inline option)* | `MEMINI_INJECT_LABELS` | comma-separated labels: `tier`, `confidence`, `age`, `reason` |
| *(secret; env only)* | `MEMINI_API_KEY` | bearer token for memini auth |
| *(security; env only)* | `MEMINI_REQUIRE_HTTPS` | `1` refuses sending the token over plaintext HTTP |

Example with explicit project scoping and conservative recall:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": [
    {
      "package": "@eleboucher/opencode-memini-v2@0.7.36",
      "options": {
        "namespace": "my-project",
        "recall_limit": 5,
        "recall_budget_ms": 1500,
        "fallback_on_error": true
      }
    }
  ]
}
```

## Strongest evidence-based customization plan

1. **Pin and isolate the package first.** Install the exact npm version above. Do not use the missing GitHub repository slug. Keep the V2 package separate from the V1 `@eleboucher/opencode-memini` package; do not put either package under the wrong config key.
2. **Pin `namespace` for multi-project or global use.** The V2 service is documented as hosting projects in one process with service-global hooks/events, and the source notes that the plugin process cwd can otherwise cause sessions from different projects to share a namespace. Set an explicit `namespace` option (or `MEMINI_NAMESPACE`) when a global OpenCode config serves more than one repository. [6]
3. **Keep secrets in the environment.** Set `MEMINI_API_KEY` outside JSON, and set `MEMINI_REQUIRE_HTTPS=1` when the memini endpoint is not loopback. Use `base_url` only for non-secret routing; do not place the bearer token in plugin options. [4]
4. **Bound latency before increasing recall.** The plugin waits up to `recall_budget_ms` for recall and proceeds without memories when the budget expires; leave the default behavior or lower it for interactive work. Raise `recall_limit` only after measuring prompt size and relevance. Use `recall_max_tokens` as a hard ceiling if injected context becomes too large. [4]
5. **Control repetition deliberately.** The default cooldown is 30 minutes or 3 prompts. Set both cooldown values to `0` only if whole-session suppression is desired; otherwise retain defaults to allow relevant memories to reappear after the windows lapse. [4]
6. **Start with root-session capture only.** `capture_child_sessions` defaults off and fail-closes on unknown ancestry. Enable it only when child-agent memories are wanted and the namespace/metadata policy is understood. [4]
7. **Use `memini_status` as the first smoke test.** The plugin registers a no-argument read-only `memini_status` tool that reports the effective namespace source, connection settings, and warnings without printing the API key. Then test one recall and one completed-turn capture against the memini server. [4] [6]
8. **Test against the exact OpenCode V2 build.** The upstream marks the V2 API as beta and reports compatibility checks through `opencode2 v0.0.0-beta-18050`. It feature-detects hook APIs and supports observed `context`/event-shape variants, but official docs and beta builds have differed. Treat upgrades of OpenCode or this plugin as compatibility changes, not just package refreshes. [3] [4] [6]

## Verification steps for the parent manifest

- Confirm the active config uses `plugins` (plural), not V1 `plugin` (singular). [9] [10]
- Confirm the active package is exactly `@eleboucher/opencode-memini-v2@0.7.36` and not `github:eleboucher/opencode-memini-v2`.
- Run `opencode plugin list` and `opencode plugin check`; verify the package is loaded and the exact revision is present. [10]
- Ensure a memini server is reachable at `MEMINI_BASE_URL` and exercise `memini_status`.
- Send a test prompt and verify that recall is either injected or cleanly skipped within `recall_budget_ms`.
- Complete a turn, then verify the memini server receives the capture; separately test `capture_child_sessions` if enabled.
- Verify logs/diagnostics and cleanup after reload or restart. Official V2 guidance recommends testing every hook/tool and testing the installed package rather than only a workspace-linked copy. [9]

## Warnings and uncertainty boundaries

- **Repository ambiguity:** `https://github.com/eleboucher/opencode-memini-v2` is a 404. The npm package and `eleboucher/memini` monorepo are authoritative substitutes, but the manifest should record the npm package, not the nonexistent repository.
- **Beta host API:** the upstream integration says the V2 API is beta and documents tested beta build identifiers. It also says the working request hook in tested builds was `context`, while the docs call it `request`; the implementation feature-detects these differences. [4] [6]
- **No SDK peer guard:** no `@opencode/plugin` or `@opencode-ai/plugin` dependency/peer dependency is declared. Compatibility is runtime/behavioral, so test the exact OpenCode build.
- **No package engine declaration:** do not claim a minimum Node/Bun version from the package metadata. The host's supported runtime is the governing requirement.
- **V1 confusion risk:** `@eleboucher/opencode-memini` is the V1 sibling. `@opencode-ai/plugin` is a V1 indicator in OpenCode's migration guide; V2 examples use `@opencode/plugin`. This V2 package imports neither, because it exports the plain V2 shape directly. [8] [9]
- **Server dependency:** the plugin is not a standalone memory database. Without a reachable memini server, recall/capture will degrade or fail according to `fallback_on_error`.

## References

[1]: https://api.github.com/repos/eleboucher/opencode-memini-v2 "GitHub API response for the requested repository slug (HTTP 404)"
[2]: https://github.com/eleboucher/memini "Official eleboucher/memini repository"
[3]: https://raw.githubusercontent.com/eleboucher/memini/main/integrations/opencode/plugin-v2/README.md "Official V2 plugin README"
[4]: https://raw.githubusercontent.com/eleboucher/memini/main/integrations/opencode/README.md "Official OpenCode integration README"
[5]: https://registry.npmjs.org/@eleboucher/opencode-memini-v2/0.7.36 "npm registry metadata for @eleboucher/opencode-memini-v2 0.7.36"
[6]: https://raw.githubusercontent.com/eleboucher/memini/main/integrations/opencode/plugin/memini-v2.js "Official V2 source entrypoint"
[7]: https://raw.githubusercontent.com/eleboucher/memini/main/integrations/opencode/plugin-v2/package.json "Official V2 package.json"
[8]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin build documentation"
[9]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V1-to-V2 migration documentation"
[10]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin installation and management documentation"
