# opencode-server-image — V2 plugin research / بحث إضافة V2

**Research status: `unresolved` (غير محسوم).** The exact identifier `opencode-server-image` could not be tied to an authoritative npm package or an exact-name Git repository. Do **not** add it to the V2 manifest or install it by guessing a similarly named project.

## Identity and source resolution / تحديد الهوية والمصدر

- The exact npm registry endpoint returns `{"error":"Not found"}` with HTTP 404 for `opencode-server-image`. The npm CLI independently reports `E404`, “`opencode-server-image@*` is not in this registry.” [1]
- The exact npm package page also does not resolve to an authoritative package page. [2]
- GitHub repository search for `opencode-server-image` in the repository name returns one near-match: `QiuweiLiu/opencode-image-server`, not the requested name. [3]
- The near-match repository is a small, single-file local plugin. Its authoritative README calls the project **`opencode-image-server`**, not `opencode-server-image`, and documents copying `image-server.js` into the local OpenCode plugin directory. [4] [5]
- The near-match repository contents are `LICENSE`, `README.md`, and `image-server.js`; there is no `package.json`. [7] Consequently, there is no authoritative package manifest from which to derive a version, exports, peer dependencies, engines, or a published entrypoint for that near-match. Its direct npm registry endpoint also returns 404. [8]

**Conclusion:** The requested name is ambiguous or may be an image/deployment label rather than a published OpenCode extension. The near-match is not evidence that it is the requested extension, so this report does not substitute it.

## V2 entrypoint check / فحص نقطة دخول V2

**Verified fact:** No real V2 entrypoint can be verified for the exact `opencode-server-image`, because no authoritative package or exact repository was found.

OpenCode V2 requires a default export based on `Plugin.define`, with a stable `id` and `setup(ctx)`, and the V2 package import is `@opencode/plugin`. The official V2 example is:

```ts
import { Plugin } from "@opencode/plugin"

export default Plugin.define({
  id: "example",
  async setup(ctx) {
    // register tools, hooks, transforms, or subscriptions
  },
})
```

[9]

The only name-near repository has a source function shaped as `export const ImageServerPlugin = async () => { ... return { tool: ... } }`; it does not use `Plugin.define`, does not default-export a V2 definition, and does not import either OpenCode plugin package. [6] The official migration guide identifies the function-returning object style as V1 and says V1 implementations do not run in V2; V2 uses the `@opencode/plugin` import and a default export with `id` and `setup(ctx)`. [10]

This is a warning about the **near-match only**, not proof about the unresolved requested name. No `@opencode-ai/plugin` import was found in the near-match source, but it still lacks the V2 `@opencode/plugin` entrypoint. There is therefore no basis to claim V2 compatibility for `opencode-server-image`.

## Safe installation / التثبيت الآمن

- **Exact safe install specification:** none verified. There is no exact package version, Git repository, commit, tarball, or package manifest to pin.
- **Exact safe command:** do not run an install command for this identifier. In particular, do not invent or execute `opencode plugin add opencode-server-image`, because the npm registry returns 404 and no exact repository was identified. [1] [11]
- OpenCode V2 does support exact package specs, ranges/tags, and npm-compatible Git specs, but those forms are only safe after the package/repository identity and V2 entrypoint have been verified. The official examples include `opencode plugin add opencode-acme-plugin@1.2.0` and Git selectors. [11]
- The near-match README's copy command—`cp image-server.js ~/.config/opencode/plugins/`—is a local-file installation instruction for `opencode-image-server`, **not** a safe install specification for the requested item and not a V2 package install. [5]

## Versions, peers, and runtime / الإصدارات والاعتماديات ومتطلبات التشغيل

### Exact requested identifier

- **Package version(s):** none available; npm 404. [1]
- **Peer dependencies:** none verifiable for the requested identifier.
- **Runtime requirements:** none verifiable for the requested identifier. No `package.json`, `engines`, exports map, or entrypoint is available.

### V2 host baseline (not target-package metadata)

For orientation only, the current npm metadata for the official V2 API package reports `@opencode/plugin` version `2.0.32`; this is a host API baseline and must not be mistaken for an `opencode-server-image` release. [12] The official V2 build documentation says published plugins should depend on an `@opencode/plugin` version compatible with the targeted OpenCode release and should be tested as an installed package. [9] The documentation does not establish a Node engine for the unresolved target.

The `@opencode/plugin` package metadata includes peer dependencies for optional TUI-related APIs (`solid-js`, `@opentui/core`, `@opentui/solid`, and `@opencode/theme`). These are metadata of the host V2 plugin API package, **not** verified peer dependencies of `opencode-server-image`; do not copy them into the target manifest as target requirements. [12]

## Documented configuration options / خيارات الإعداد الموثقة

- **Exact requested extension:** none documented, because no authoritative source exists.
- **Near-match only, not transferable:** its README documents a loopback server on `127.0.0.1`, port `8899`, a platform-specific data directory, supported image extensions, and two tools (`serve_image` and `view_image`). It does not document a V2 `ctx.options` schema or package configuration object. [5]
- OpenCode V2 supports passing plugin options with an object entry in `opencode.json(c)` and reading them from `ctx.options` during `setup`. [9] [11] This is a platform capability, not evidence that the unresolved target accepts any particular option names.

## Strongest evidence-based customization plan / أقوى خطة تخصيص قائمة على الدليل

Because the exact extension is unresolved, the strongest plan is **verification-first, not installation-first**:

1. Obtain the missing authoritative identity from the requester or maintainer: exact GitHub URL, npm scope/name, or immutable Git commit.
2. Inspect that source's `package.json` and default export. Accept it as V2 only if it exports a V2 definition with a stable `id` and `setup(ctx)` or the documented Effect entrypoint, and uses `@opencode/plugin` rather than only `@opencode-ai/plugin`. [9] [10]
3. Pin an exact npm version or full Git commit. Record the package's actual `exports`, dependencies, peer dependencies, engines, and README options; do not infer them from a name or from `opencode-image-server`.
4. If the intended project really is the near-match `QiuweiLiu/opencode-image-server`, treat it as a separate V1/local-plugin port. Its likely useful customization surface, based on its README, is an explicit options layer for bind address, port, serve directory, allowed image extensions, and whether `view_image` is enabled. These are **recommended design targets for a maintainer port**, not documented options of the existing file. A V2 port should expose only confirmed options through the object-form config and read them via `ctx.options`, while preserving loopback-only binding and path/extension validation. [5] [9]
5. Test the installed package, not a workspace copy. Verify that the ID/source appears in the active plugin list, exercise every tool/hook, test options with a clean project, and verify reload/cleanup. These checks follow the official V2 migration verification guidance. [10]

## Verification checklist / قائمة التحقق

- [x] Exact npm registry lookup: HTTP 404 for `opencode-server-image`. [1]
- [x] Exact npm CLI lookup: `E404`, package not in registry. [1]
- [x] Exact-name GitHub repository search: no exact `opencode-server-image`; one reversed-name near-match. [3]
- [x] Near-match README and source inspected; no package.json and no V2 default `Plugin.define` entrypoint. [4] [5] [6] [7]
- [x] Official V2 docs checked for `@opencode/plugin`, default export, `id`, `setup(ctx)`, options, install syntax, and V1 migration rules. [9] [10] [11]
- [ ] Install/test the requested extension: blocked until its exact authoritative identity is supplied.

## Warnings / التحذيرات

- **Name collision:** `opencode-server-image` and `opencode-image-server` are different identifiers. Do not silently normalize or reverse the name.
- **V1 risk:** the near-match function-returning tool object is not a V2 entrypoint. OpenCode's migration guide explicitly warns that V1 implementations do not run in V2. [10]
- **No package metadata:** absent package.json and npm publication mean versions, peers, engines, and exports cannot be responsibly guessed.
- **Manifest action:** keep this item `unresolved` and uninstalled; do not replace its `source` with the near-match repository without explicit confirmation.

## References

[1]: https://registry.npmjs.org/opencode-server-image "npm registry metadata for the exact requested name"
[2]: https://www.npmjs.com/package/opencode-server-image "npm package page for the exact requested name"
[3]: https://github.com/search?q=opencode-server-image%20in%3Aname&type=repositories "GitHub repository search for the requested name"
[4]: https://github.com/QiuweiLiu/opencode-image-server "Near-match GitHub repository"
[5]: https://raw.githubusercontent.com/QiuweiLiu/opencode-image-server/main/README.md "Near-match repository README"
[6]: https://raw.githubusercontent.com/QiuweiLiu/opencode-image-server/main/image-server.js "Near-match plugin source"
[7]: https://api.github.com/repos/QiuweiLiu/opencode-image-server/contents "Near-match repository contents API"
[8]: https://registry.npmjs.org/opencode-image-server "npm registry metadata for the reversed-name near-match"
[9]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin build documentation"
[10]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1-to-V2 migration guide"
[11]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin management documentation"
[12]: https://registry.npmjs.org/@opencode%2fplugin "npm registry metadata for the official V2 plugin API package"
