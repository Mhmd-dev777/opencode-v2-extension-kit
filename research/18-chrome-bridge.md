# opencode-chrome-bridge — OpenCode V2 research

**Research date:** 2026-10-18  
**Requested ID:** `chrome-bridge`  
**Resolved project:** `pmgallardodev/opencode-chrome-bridge`  
**Pinned source revision reviewed:** `8d6954c7d7d3ba953395fcfd725cc64455e7e7cc`  
**Verdict:** **V2 entrypoint is present and source-level V2 compatibility is verified, but installation is a pinned Git checkout, not an npm package. Runtime use remains conditional on the exact OpenCode V2 build, Node version, Chrome setup, and the local native bridge.**

## Identity and publication status

The repository is authoritative for this name: its package manifest names the project `opencode-chrome-bridge`, version `1.5.0`, and links back to the same GitHub repository. The manifest also sets `private: true`; the npm registry endpoint returns HTTP 404 and `npm view opencode-chrome-bridge version` reports that the package is not in the registry. Therefore the safe source is the pinned Git repository, not `opencode-chrome-bridge@...` from npm. [1] [2] [6]

There is no unresolved-name ambiguity after checking the repository, its manifest, its lockfile, and the npm registry. The existing manifest entry was marked unresolved, but the name now resolves to the repository above. That does **not** make this an ordinary self-contained npm plugin: it is a three-part local system containing a Chrome MV3 extension, a native messaging host, and an OpenCode plugin. [1]

## Real V2 plugin entrypoint

**Verified: yes.** The repository contains `src/plugin-entry-v2.js`; it re-exports the default value from `src/opencode-plugin-v2.js`. The adapter default-exports an object with:

```js
{
  id: "opencode-chrome-bridge",
  async setup(context) { /* registers tools through context.tool.transform */ }
}
```

The adapter registers the existing browser tools through `context.tool.transform`, converts the existing Zod argument definitions to JSON Schema, returns OpenCode V2 content/file results, resolves the project directory from `ctx.session.get()`, and routes approval requests through the local OpenCode service permission API. [3]

The repository's dedicated V2 test confirms that the V2 module namespace contains only `default`, that `id` is the expected stable ID, that `setup` is a function, and that setup registers every V1 tool with JSON Schema input. At this revision, the targeted test file passed all 15 tests locally after `npm ci --ignore-scripts`. This is strong source/test evidence, but it is not a substitute for testing against the target OpenCode V2 server. [4]

### V1 indicators and the important caveat

The package is **not** a clean, native `@opencode/plugin` package:

- `package.json` depends on **`@opencode-ai/plugin` exactly at `1.18.15`**, which is the V1 indicator requested for review.
- It has no dependency on **`@opencode/plugin`**, the package shown by the official V2 migration documentation.
- The ordinary package entry `main` and `exports["."]` point to `src/plugin-entry.js`, the V1 factory entrypoint.
- The V2 entry is deliberately a separate export/path: `exports["./v2"]` points to `src/plugin-entry-v2.js`.
- The repository's V2 adapter manually implements the `{ id, setup }` shape, while dynamically importing `@opencode-ai/plugin` to obtain the schema helper. It reuses V1 tool implementations and their approval wrapper rather than porting the whole implementation to `@opencode/plugin`. [2] [3] [7] [8] [9]

The project's README explicitly says that OpenCode 2 must point at `src/plugin-entry-v2.js`, because resolving the repository directory through `main`/`exports["."]` would load the V1 entrypoint. This is the critical configuration fact: **do not configure the repository root as the V2 plugin.** [1]

## Exact safe install specification and command

### Safe install specification

```text
github:pmgallardodev/opencode-chrome-bridge#8d6954c7d7d3ba953395fcfd725cc64455e7e7cc
```

This is a source pin, not an npm package version. Keep the V2 config target as the checked-out absolute file:

```text
/path/to/opencode-chrome-bridge/src/plugin-entry-v2.js
```

### Recommended pinned install command

```bash
git clone https://github.com/pmgallardodev/opencode-chrome-bridge.git /path/to/opencode-chrome-bridge
cd /path/to/opencode-chrome-bridge
git checkout --detach 8d6954c7d7d3ba953395fcfd725cc64455e7e7cc
npm ci
npm run install:native
npm run install:opencode
```

The repository installer is the safest supported configuration path because it writes both generations' entries. For V2 it writes the explicit file path, equivalent to:

```jsonc
{
  "plugins": [
    "/path/to/opencode-chrome-bridge/src/plugin-entry-v2.js"
  ]
}
```

It also writes the V1-compatible `plugin` entry unless the operator removes that entry intentionally. Restart the V2 background service after installation:

```bash
opencode2 service restart
```

The Chrome half is a required manual step: enable Developer mode at `chrome://extensions` and load the repository's `extension/` directory as an unpacked extension. Run `npm run verify` after the native host, extension, and config are in place. [1]

A bare `opencode2 plugin add opencode-chrome-bridge` command is **not safe or valid**: the package is absent from npm. A Git package add without selecting the explicit V2 file is also unsafe because the package root resolves to the V1 entrypoint, and installing only the plugin does not register the native host or load the Chrome extension. [1] [2] [6] [7]

## Versions, dependencies, and runtime requirements

- Repository/package version: **`1.5.0`**.
- Current reviewed Git revision: **`8d6954c7d7d3ba953395fcfd725cc64455e7e7cc`**.
- Direct runtime dependency: **`@opencode-ai/plugin` `1.18.15`**.
- Lockfile also pins `@opencode-ai/sdk` `1.18.15`, `zod` `4.1.8`, `effect` `4.0.0-beta.83`, `@ai-sdk/provider` `3.0.8`, and other transitive packages. The root lockfile has lockfile version 3. [2] [5]
- Root package peer dependencies: **none declared**.
- The direct dependency `@opencode-ai/plugin@1.18.15` declares optional peers `@opentui/core >=0.4.5`, `@opentui/keymap >=0.4.5`, and `@opentui/solid >=0.4.5`. These are transitive package peers, not peers declared by `opencode-chrome-bridge` itself. [5]
- Node.js: **`^22.22.2 || ^24.15.0 || >=26.0.0`**, exactly as declared in `package.json` and documented in the README.
- Google Chrome stable with Developer mode enabled and the unpacked extension loaded.
- OpenCode CLI: the README names OpenCode 1 (`opencode`) and OpenCode 2 (`opencode2`); this report targets V2.
- Supported OSes: macOS, Linux, and Windows 10/11. Native Windows support is for native Windows OpenCode/Node; WSL-to-host Chrome bridging is explicitly not supported by the automatic installer.
- The V2 permission bridge expects the shared local OpenCode service registration and fails closed if that service cannot be reached. `opencode2 --standalone` cannot use the shared service for approval requests. [1] [2] [3]

During local verification, the sandbox had Node `22.13.0`, below the declared minimum `22.22.2`; npm emitted `EBADENGINE` warnings. The targeted tests still passed, but this should be treated as a real runtime warning, not as evidence that the unsupported Node version is safe.

## Documented configuration options

No plugin option schema is documented, and the V2 adapter does not read `ctx.options`. Therefore an OpenCode V2 object entry such as `{ "package": "...", "options": {...} }` should not be represented as a supported customization mechanism for the upstream plugin at this revision. [1] [3] [7]

Documented installer/configuration controls are:

- `OPENCODE_CONFIG_DIR`: set before `npm run install:opencode` to choose a non-default OpenCode config directory.
- `XDG_STATE_HOME`: honored by the V2 service client when locating the OpenCode service registration; the effective file is `$XDG_STATE_HOME/opencode/service.json`.
- `npm run install:native -- --node=/absolute/path/to/node`: explicitly choose a supported Node executable for the native host installer.
- Windows setup flags: `setup-windows.cmd --no-pause` and optionally `--no-open`.
- OpenCode V1 uses the singular `plugin` key; OpenCode V2 uses the plural `plugins` key. The V2 value must be the direct `src/plugin-entry-v2.js` path for this repository. [1] [3]

The source additionally supports `OPENCODE_CHROME_BRIDGE_STATE_DIR` for tests or isolated bridge state, but this is a source-level environment variable rather than a README-documented end-user plugin option. Do not expose it as a normal OpenCode plugin option without testing the complete native/extension stack. [1] [3]

## Strongest evidence-based customization plan

1. **Keep the upstream checkout pinned and separate from user modifications.** Use the exact commit above, `npm ci`, and retain the repository lockfile. Do not turn the project into an npm-only install.
2. **Customize at the V2 adapter boundary, not by pointing V2 at the package root.** If behavior must change, fork the repository or maintain a small patch that preserves `src/plugin-entry-v2.js` and the stable `id: "opencode-chrome-bridge"`; the repository already has a focused V2 test suite for this boundary. [3] [4]
3. **Add options only as an explicit fork feature.** A fork can read `context.options` inside `setup` and the OpenCode V2 config can then use the documented object form. Upstream currently ignores `ctx.options`, so claiming options such as `enabled`, `origins`, or `verbose` work would be unsupported.
4. **Prefer policy customization through the existing approval wrapper.** The upstream design is deny-by-default and includes per-origin approval scopes. Preserve that wrapper and add allowlists or tool filtering only after reviewing and testing the relevant tool definitions in `src/opencode-plugin.js` and the V2 conversion in `src/opencode-plugin-v2.js`.
5. **Test every customized build with the repository checks** (`npm run check`, `npm test`, `npm run verify`, `npm run check:chrome-extension`, and `npm run smoke:native`), then restart `opencode2 service` and verify that `opencode2 plugin list` contains the plugin. This plan follows the repository's own verification path and the official V2 guidance to test the installed package/entrypoint, not only a linked workspace. [1] [4] [8]

## Verification steps for the parent manifest

- Confirm the source checkout is at commit `8d6954c7d7d3ba953395fcfd725cc64455e7e7cc`.
- Confirm `package.json` reports `1.5.0`, `private: true`, and `exports["./v2"] = "./src/plugin-entry-v2.js"`.
- Confirm the V2 config uses the absolute `src/plugin-entry-v2.js` path, not the repository root.
- Run `npm ci` using a supported Node version, then `npm run install:native` and `npm run install:opencode`.
- Load `extension/` unpacked in Chrome and run `npm run verify`.
- Restart `opencode2 service`; check `opencode2 plugin list` and exercise `chrome_status`, then a low-risk read-only tool such as `chrome_tabs`.
- Confirm that permission requests are local and fail closed if the service is unavailable; do not validate with `opencode2 --standalone` because the README documents that approval path as unsupported.

## Warnings and unresolved points

- **Not published to npm:** the registry lookup is authoritative 404, so no npm version/install command can be claimed.
- **V1 dependency remains:** `@opencode-ai/plugin@1.18.15` is a clear V1 indicator. V2 support is implemented by a separate manual adapter, not by migrating the repository to `@opencode/plugin`.
- **Two entrypoints are intentional:** V1 root path and V2 direct file path must not be conflated.
- **Runtime stack is larger than a plugin:** Chrome, Developer mode, native messaging registration, local service authentication, and the extension must all be healthy.
- **Node minimum matters:** the local sandbox test used Node 22.13.0 and passed only with engine warnings; production should use Node 22.22.2+, 24.15.0+, or 26.0.0+ as declared.
- **Current HEAD is unsigned:** the GitHub API reports the reviewed commit as unsigned. Pinning the commit improves reproducibility but is not a cryptographic release signature.
- **No upstream plugin options are documented or consumed:** do not add options to the manifest and assume they affect behavior.

## References

[1]: https://github.com/pmgallardodev/opencode-chrome-bridge/blob/8d6954c7d7d3ba953395fcfd725cc64455e7e7cc/README.md "Official opencode-chrome-bridge README at reviewed commit"
[2]: https://raw.githubusercontent.com/pmgallardodev/opencode-chrome-bridge/8d6954c7d7d3ba953395fcfd725cc64455e7e7cc/package.json "Official package.json at reviewed commit"
[3]: https://raw.githubusercontent.com/pmgallardodev/opencode-chrome-bridge/8d6954c7d7d3ba953395fcfd725cc64455e7e7cc/src/opencode-plugin-v2.js "Official OpenCode V2 adapter source at reviewed commit"
[4]: https://raw.githubusercontent.com/pmgallardodev/opencode-chrome-bridge/8d6954c7d7d3ba953395fcfd725cc64455e7e7cc/test/opencode2-plugin.test.mjs "Official OpenCode V2 plugin tests at reviewed commit"
[5]: https://raw.githubusercontent.com/pmgallardodev/opencode-chrome-bridge/8d6954c7d7d3ba953395fcfd725cc64455e7e7cc/package-lock.json "Official package-lock.json at reviewed commit"
[6]: https://registry.npmjs.org/opencode-chrome-bridge "npm registry metadata endpoint for opencode-chrome-bridge"
[7]: https://opencode.ai/v2/docs/plugins "Official OpenCode V2 plugin configuration documentation"
[8]: https://opencode.ai/v2/docs/build/plugins "Official OpenCode V2 plugin build documentation"
[9]: https://opencode.ai/v2/docs/build/plugins/migrate-v1 "Official OpenCode V2 V1 migration documentation"
