# Secure build-from-source workflow

Build-required plugins are never built by the normal `safe` profile. Use an explicit opt-in:

```bash
./bin/opencode-v2-extensions install \
  --profile workflow \
  --allow-risky \
  --allow-build \
  --dry-run
```

After reviewing the exact operations:

```bash
./bin/opencode-v2-extensions install \
  --profile workflow \
  --allow-risky \
  --allow-build \
  --yes
```

## What the script verifies

For each build entry the manifest contains an immutable repository URL, full commit SHA, explicit build commands, entrypoint, and runtime type. The script:

1. Requires OpenCode v2, Git, and npm.
2. Clones into the script-owned state directory, not the project working tree.
3. Fetches and checks out the exact full commit.
4. Runs `npm ci --ignore-scripts` before the explicitly reviewed build command.
5. Requires the declared entrypoint to exist.
6. Searches source/dist for a V2 setup marker before adding the local entrypoint.
7. Adds a local object entry transactionally to `opencode.json`.
8. Records the local entrypoint and source commit in managed state.
9. Removes the local config entry and the script-owned checkout on uninstall.

The build command is still arbitrary code from the pinned repository. `--allow-build` is therefore a deliberate trust boundary, and should be run in a disposable or reviewed environment. Do not place provider tokens or other secrets in the build environment.

## Why no automatic GitHub build is used

A branch or tag can move. Full commit pinning plus a lockfile and npm audit output gives a reproducible review point. OpenCode's package installer also accepts registry/Git package specs but does not accept an arbitrary local directory through `opencode plugin add`, so source-built plugins are inserted using the official V2 object-form local package configuration.

## Current example

`opencode-spec` is pinned to commit `74723f567967c6c68805e8b7eb93f2df5c1c0ce5`. Its build is `npm ci --ignore-scripts` followed by `npm run build`, and its checked entrypoint is `dist/index.js`. This exact flow was tested with OpenCode v2.0.32: the server started, a real `opencode run` returned `OK`, and the managed uninstall removed the local entry and source checkout.
