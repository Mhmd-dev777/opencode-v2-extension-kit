# Contributing

1. Add evidence for every source change.
2. Do not mark a plugin `v2-reviewed` without checking its package entrypoint, peer dependencies, and a clean OpenCode v2 load.
3. Run `tests/test.sh` and `shellcheck bin/opencode-v2-extensions` when available.
4. Keep the install path non-destructive and fail closed.
