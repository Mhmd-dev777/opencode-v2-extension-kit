# mohak34/opencode-notifier@1.0.0

**Status:** `v2-reviewed`

**Pinned source:** `@mohak34/opencode-notifier@1.0.0`

## Install

```bash
opencode plugin add @mohak34/opencode-notifier@1.0.0
```

## Requirements

- OpenCode V2 plugin API
- Interactive CLI for local popups/sounds
- Linux notify-send/libnotify and audio player where applicable

## Strong defaults

The sibling `options.json` contains conservative defaults. Apply them using the extension's documented config file or environment variables; do not place credentials in this file.

## Managed files

- `opencode.json(c)`
- `~/.config/opencode/opencode-notifier.json`
- `opencode-notifier-state.json`
- `optional GNOME extension directory`


## Verification

- permission/completion/error/question events
- OPENCODE_NOTIFIER_DEBUG=1
- test harmless event command


This extension is included only because its V2 entrypoint and installation source were independently verified.
