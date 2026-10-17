# Direct tests for previously unverified candidates

Tested against OpenCode `v2.0.32` in isolated temporary configurations on 2026-10-18. No user configuration was used.

## Results

| Candidate | Install/start result | V2 conclusion | Decision |
|---|---|---|---|
| `@tarquinen/opencode-dcp@3.2.0` | npm install succeeded; real server stayed alive; real `opencode run` returned `OK` | Runtime startup compatible, but package metadata still declares the V1-oriented peer `@opencode-ai/plugin`; V2 implementation is present and requires exact-host regression testing | Keep outside safe profile as `needs-review` |
| `@lansya/opencode-plugin-claude-memory@1.0.7` | npm install and server startup succeeded; request returned `OK` | Not V2. Package engines are `>=1.4.3 <2`, source uses V1 `@opencode-ai/plugin` and `server()` and has no V2 `Plugin.define/setup` entrypoint. The host can silently ignore it | Keep `v1-blocked`; never enable |
| `opencode-engram-learning@1.15.1` | npm install succeeded; real server stayed alive; request returned `OK` | V2 adapter exists, but the package remains dual-generation and declares a V1 peer; current target-host behavior needs continued validation | Keep outside safe profile as `needs-review` |
| `opencode-headroom@0.1.0` | npm install and server startup succeeded; request returned `OK` | Not V2. Published entrypoint is a V1 `server` export using `@opencode-ai/plugin`; no V2 setup contract | Keep `v1-blocked`; never enable |
| `opencode-delegation@0.1.2` | npm install and server startup succeeded; request returned `OK` | Not V2. Published `dist/plugin.js` is a V1 factory with V1 hook keys and a V1 peer | Keep `v1-blocked`; never enable |
| `@morphllm/opencode-morph-plugin@2.0.17` | npm install and server startup succeeded; request returned `OK` | Not V2. Version number does not indicate OpenCode major compatibility; published source uses `@opencode-ai/plugin` and V1 hook/function exports | Keep `v1-blocked`; never enable |
| `opencode-spec` at commit `74723f567967c6c68805e8b7eb93f2df5c1c0ce5` | clone, checkout, `npm ci`, and `npm run build` succeeded; local V2 entrypoint loaded in OpenCode and request returned `OK` | V2 source works only when built from the pinned commit; published npm artifact is V1 | Keep build-required and outside the normal npm safe profile |
| `opencode-chrome-bridge` at commit `8d6954c7d7d3ba953395fcfd725cc64455e7e7cc` | clone, checkout, and `npm ci` succeeded; root build script does not exist; direct `src/plugin-entry-v2.js` loaded in OpenCode and request returned `OK` | Conditional V2 adapter works when loaded by its direct file path, but the root package remains V1 and the full Chrome/native messaging stack was not installed | Keep conditional/build-required |

## Important interpretation

A V1 package can be accepted by `opencode plugin add` and a generic text request can still return `OK`, because OpenCode may skip a package that lacks the V2 `default { id, setup }` contract. That is not evidence of compatibility. The entrypoint contract and package API were inspected separately.

The installer therefore continues to reject V1-blocked entries and does not promote them merely because the host process remains alive.

## Unresolved names

`opencode-timeline-viewer` and `opencode-server-image` still have no authoritative exact package/repository source, so there is no safe artifact to install or test. Near-match names were not substituted.

All temporary candidate configurations and source checkouts used for this test were outside the repository and are disposable.
