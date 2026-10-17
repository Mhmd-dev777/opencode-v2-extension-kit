# OpenCode V2 Extension Kit

A safety-first installer and removal manager for OpenCode v2 extensions. It does **not** install OpenCode itself. If `opencode` is absent, or if the detected version is not v2, the command stops and tells the user to install OpenCode v2 first.

## One-command usage

```bash
curl -fsSL https://raw.githubusercontent.com/Alqudimi/opencode-v2-extension-kit/main/bin/opencode-v2-extensions -o /tmp/opencode-v2-extensions
chmod +x /tmp/opencode-v2-extensions
/tmp/opencode-v2-extensions doctor
```

For a checkout-based installation, clone the repository and run `./bin/opencode-v2-extensions install`. The safe default installs only entries whose manifest status is `v2-reviewed`. `--allow-risky` is explicit opt-in for entries that still need review. Entries with no authoritative source are blocked and never guessed.

## Why the default is conservative

OpenCode v2 uses a new plugin API. The official migration guide states that V1 plugin implementations do not run in V2, so a package name alone is not evidence of compatibility. The manifest records the source, package version, review status, and reason for every requested item.

The user requested 20 entries. At the time of this repository build, 2 are marked `v2-reviewed`, 14 are `needs-review` or `unverified`, and 4 have no authoritative source and are blocked. This is intentional: the script must not install an unverified or unrelated package under a similar name.

## Secure source builds

Build-required extensions are opt-in and pinned to full Git commits. Preview a source build before changing OpenCode:

```bash
./bin/opencode-v2-extensions install --profile workflow --allow-risky --allow-build --dry-run
./bin/opencode-v2-extensions install --profile workflow --allow-risky --allow-build --yes
```

See [`docs/BUILD-SECURITY.md`](docs/BUILD-SECURITY.md).

## Profiles and per-extension settings

Each extension has its own folder under `extensions/<id>/` with `options.json`, `profile.json`, and a review README. Choose a profile and generate its OpenCode v2 plugin configuration:

```bash
./bin/opencode-v2-extensions list-profiles
./bin/opencode-v2-extensions render --profile safe
./bin/opencode-v2-extensions render --profile memory
./bin/opencode-v2-extensions install --profile productivity --dry-run
```

The generator emits `config/generated/opencode-v2-extensions.jsonc`. It never fabricates plugin-specific options.

## Commands

```bash
./bin/opencode-v2-extensions doctor
./bin/opencode-v2-extensions status
./bin/opencode-v2-extensions install --dry-run
./bin/opencode-v2-extensions install
./bin/opencode-v2-extensions install --allow-risky
./bin/opencode-v2-extensions remove
```

`remove` only removes plugins recorded in the script-owned state file. It does not delete the user's OpenCode configuration or unrelated plugins.

## Configuration

OpenCode v2 reads global configuration from `~/.config/opencode/opencode.json(c)` on Linux and supports `plugins` entries plus package options. Copy `config/opencode.jsonc.example` and add only plugin-specific options documented by the upstream project. Do not put API keys in this repository.

## Research sources

- [OpenCode v2 Plugins](https://opencode.ai/v2/docs/plugins)
- [OpenCode v2 Config](https://opencode.ai/v2/docs/config)
- [OpenCode v2 Migration from V1](https://opencode.ai/v2/docs/migrate-v1/)
- [OpenCode v2 Plugin Migration](https://opencode.ai/v2/docs/build/plugins/migrate-v1)

## License

MIT.
