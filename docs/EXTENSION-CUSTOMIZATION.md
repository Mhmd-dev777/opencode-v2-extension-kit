# Per-extension customization

Every requested extension has a dedicated directory under `extensions/<id>/`. This prevents one large opaque configuration file from hiding incompatible settings. Each directory contains `options.json`, `profile.json`, and a README with the extension-specific review notes.

## Safe configuration model

`options.json` has four sections:

```json
{
  "enabled": true,
  "options": {},
  "environment": {},
  "permissions": []
}
```

Only put documented upstream options inside `options`. Use `{env:NAME}` references in generated OpenCode configuration for secrets instead of committing values. Permissions are explicit OpenCode rules and should be narrow.

## Profiles

Available profiles are stored in `config/profiles.json`:

- `safe`: only entries marked `v2-reviewed`.
- `productivity`: reviewed todo and task entries.
- `memory`: memory and context entries, with explicit risky opt-in.
- `ui`: TUI and composer entries.
- `workflow`: specification, delegation, and agent workflow entries.
- `all-known`: all entries with a source, excluding unresolved names.

Render a profile without changing OpenCode:

```bash
./bin/opencode-v2-extensions render --profile memory
```

The generated file is `config/generated/opencode-v2-extensions.jsonc`. Review it, then either merge it into the user's OpenCode config or use the installer, which invokes the official `opencode plugin add` command.

## Strong customization workflow

1. Choose a profile.
2. Edit only the selected extension's `options.json`.
3. Run `render --profile <name>` and inspect the generated plugin objects.
4. Run `install --profile <name> --dry-run`.
5. Install after reviewing the exact sources.
6. Restart the OpenCode service if the package or config watcher does not reload automatically.

The repository does not invent options for extensions whose authors have not documented them. This is a deliberate compatibility and supply-chain safeguard.
