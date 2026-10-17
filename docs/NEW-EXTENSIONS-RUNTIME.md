# Runtime verification: six newly reviewed extensions

The six new entries were installed in an isolated OpenCode v2.0.32 configuration using the repository installer. The first batch encountered a transient HTTPS fetch error while OpenCode was fetching Ensemble's dependency graph; isolated retry of Ensemble succeeded, and a clean full retry then installed all six.

Installed exact entries:

- `@slkiser/opencode-quota@5.0.3`
- `open-codebase-index@0.36.3`
- `opencode-supermemory@2.0.17`
- `@hueyexe/opencode-ensemble@0.18.0`
- `opencode-tavily@1.0.0`
- `@mohak34/opencode-notifier@1.0.0`

All six were added to `opencode.json`. The complete safe profile contained 14 server plugins plus the two existing TUI plugins. A real OpenCode v2 server loaded the configuration and a live `opencode run` returned `OK` with no plugin loader exception.

External-service warnings were not treated as compatibility failures: Hindsight reported a missing token as expected, while the new extensions remained loadable without credentials. Full feature verification still requires the corresponding provider/CLI credentials described in each extension directory.

The test configuration was isolated and is not the user's live configuration. Use the per-extension verification commands before enabling provider-backed features in production.
