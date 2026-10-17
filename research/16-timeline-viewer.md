# `opencode-timeline-viewer` — OpenCode V2 research

**Research status: unresolved / blocked.** No authoritative npm package, public GitHub repository, README, or `package.json` could be established for the exact name `opencode-timeline-viewer`. The current manifest already marks this item as unresolved; the evidence below supports keeping it blocked rather than inventing an install target.

## Verified identity and availability

The exact npm registry endpoint `https://registry.npmjs.org/opencode-timeline-viewer` returns HTTP `404` with the body `{"error":"Not found"}`. `npm view opencode-timeline-viewer ...` likewise returns `E404` and says that `opencode-timeline-viewer@*` is not in the registry. Therefore there is no verified npm version, dist-tag, tarball, README, repository field, dependency list, peer dependency list, or engine declaration for this exact name. [1]

The exact npm package page does not resolve to a package record, and a GitHub repository search for `opencode-timeline-viewer` returned `total_count: 0`. These checks do not prove that no private, unpublished, renamed, or newly created project exists, but they do mean that no public authoritative source was available for this research item. [2] [3]

A similarly named viewer or a built-in OpenCode timeline feature must not be substituted for this requested extension. The name is therefore **unresolved**, not a verified package alias.

## V2 entrypoint and V1 indicators

There is **no package source to inspect**, so a real V2 entrypoint is not present or absent in evidence; it is simply **unverified**. In particular, no `package.json` `exports` field, source `index.ts`, default export, plugin ID, or `setup(ctx)` function can be attributed to `opencode-timeline-viewer`.

The official OpenCode V2 migration guide defines the distinction that should be applied if a source is later found:

- V1 uses `import type { Plugin } from "@opencode-ai/plugin"` and an exported plugin function.
- V2 uses `import { Plugin } from "@opencode/plugin"` and a default export such as `Plugin.define({ id, setup(ctx) { ... } })`.
- V2 requires a stable plugin `id`; configuration renaming or moving a V1 file is not sufficient to make it run under V2. [4]

Because the requested package cannot be fetched, there is no evidence that it imports either `@opencode-ai/plugin` or `@opencode/plugin`. Consequently, no V1/V2 classification can be made for this package. If a future repository is found, an `@opencode-ai/plugin` import or peer dependency should be treated as a V1 indicator requiring a port review, while `@opencode/plugin` plus a default `Plugin.define`/`setup` export is the relevant V2 evidence. This is a verification rule, not a claim about the missing package.

## Versions, installation, dependencies, and requirements

### Package version

- **Verified package versions:** none.
- **Verified latest version or dist-tag:** none.
- **Verified commit, tag, or repository revision:** none.

### Safe install specification and command

- **Safe install specification:** **none / unresolved**. Do not record `opencode-timeline-viewer`, a guessed GitHub URL, or an unverified version as an installable source.
- **Safe install command:** **none — do not run** `opencode plugin add opencode-timeline-viewer`; the npm registry currently returns 404 for that exact package.

OpenCode V2 does support exact npm package versions, for example `opencode plugin add opencode-acme-plugin@1.2.0`, and supports npm-compatible Git specifications. Its documentation also says that exact npm versions and full Git commit hashes stay pinned. Those rules are relevant only after an authoritative package or repository is identified. [5]

### Peer dependencies and runtime requirements

- **Peer dependencies:** none can be verified because the exact package metadata does not exist in the public npm registry.
- **Package runtime requirement:** unknown; no `engines` field or runtime declaration is available.
- **OpenCode host requirement:** a future candidate must be tested in the targeted OpenCode V2 release using the V2 plugin API. The official V2 docs show package plugins depending on a compatible version of `@opencode/plugin` and publishing an ESM package with an `exports` entry, but those are OpenCode's requirements for a valid V2 package, not evidence about this missing package. [6]
- The official V2 introduction documents how to install the OpenCode CLI, but it does not supply a Node version requirement for this missing extension. Do not infer one. [7]

## Documented configuration options

**None verified.** There is no authoritative README or package source for `opencode-timeline-viewer`, so no option name, type, default, config file location, environment variable, command, UI behavior, storage path, or timeline filter can be documented for it.

OpenCode V2 itself permits a package plugin entry to be either a string or an object with `package` and `options`, for example:

```jsonc
{
  "plugins": [
    {
      "package": "@acme/opencode-plugin",
      "options": {
        "strict": true
      }
    }
  ]
}
```

A plugin reads that object from `ctx.options` during `setup`. This is a host-level configuration mechanism, not evidence that `opencode-timeline-viewer` accepts `strict` or any other option. [5] [6]

## Strongest evidence-based customization plan

There is no safe customization plan for the unverified extension itself. The strongest plan is a **conditional verification and local-fork plan**:

1. **Resolve identity first.** Obtain an official repository URL or a published npm package page from the extension author. Capture the exact repository owner, package name, version/tag or commit, and the README plus `package.json`. Do not use search-result snippets as proof.
2. **Inspect the entrypoint.** Confirm `package.json` `type`, `exports`, and the resolved source file. For V2, require a default export with a stable `id` and `setup(ctx)` or the documented Effect equivalent. Record whether the package imports `@opencode/plugin` or the V1 package `@opencode-ai/plugin`. [4] [6]
3. **Check compatibility before installation.** Record `dependencies`, `peerDependencies`, `engines`, and the package's stated OpenCode version range. Test the published artifact rather than only a workspace-linked copy, as the official build docs recommend. [6]
4. **Pin only the verified artifact.** Once the exact package/version is confirmed, use `opencode plugin add <exact-package>@<exact-version>` and configure the same exact package/version in `opencode.json(c)`. If only a repository is authoritative, use a full commit hash or an explicitly documented subdirectory selector; do not guess a GitHub owner or branch. [5]
5. **Use documented options only.** If the future README documents options, pass them through the V2 object form and verify that the implementation reads `ctx.options`. If no options are documented, use no options. [6]
6. **Prefer a local fork for customization.** If the source is later found but lacks a needed setting, fork or copy it into `.opencode/plugins/` and modify the V2 `setup` implementation. V2 supports local plugin files/directories and automatically discovers immediate plugin package directories under `.opencode/plugins/`; this is safer than patching an unknown registry artifact. [5]
7. **Validate load behavior.** Run the host's plugin listing/check commands, start the targeted OpenCode V2 build, and inspect plugin diagnostics. Confirm that the package's stable ID appears and that its documented behavior works. A source that exports only the V1 function must not be enabled as a V2 plugin; the official migration guide explicitly warns that V1 implementations do not run in V2. [4] [5]

Until step 1 succeeds, the manifest should remain `unresolved` with no `source` and no install command.

## Evidence summary for the manifest

- **Status:** `unresolved`
- **Authoritative source:** no authoritative package/repository source found; npm exact-name lookup is 404 and GitHub exact repository search is empty.
- **V2 compatibility:** unverified; no real V2 plugin entrypoint can be inspected.
- **Install:** blocked; no safe package/version/repository specification.
- **Peer dependencies:** unknown, not an empty declared list.
- **Options:** none verified.
- **Warning:** do not conflate this unresolved name with a similarly named viewer or OpenCode's own timeline functionality.

## References

[1]: https://registry.npmjs.org/opencode-timeline-viewer "npm registry metadata for opencode-timeline-viewer"
[2]: https://www.npmjs.com/package/opencode-timeline-viewer "npm package page for opencode-timeline-viewer"
[3]: https://api.github.com/search/repositories?q=opencode-timeline-viewer "GitHub repository search for opencode-timeline-viewer"
[4]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "OpenCode V2 guide for migrating V1 plugins"
[5]: https://opencode.ai/v2/docs/plugins "OpenCode V2 plugin configuration and installation"
[6]: https://opencode.ai/v2/docs/build/plugins "OpenCode V2 plugin build and publish documentation"
[7]: https://opencode.ai/v2/docs/ "OpenCode V2 introduction and CLI installation"
