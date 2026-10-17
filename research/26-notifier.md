# Research: mohak34/opencode-notifier@1.0.0

- Compatibility: **v2-reviewed**
- Pinned artifact: `@mohak34/opencode-notifier@1.0.0`
- Install: `opencode plugin add @mohak34/opencode-notifier@1.0.0`

## Requirements
- OpenCode V2 plugin API
- Interactive CLI for local popups/sounds
- Linux notify-send/libnotify and audio player where applicable

## Customization
- notification events
- sound
- bell
- timeout
- title
- project
- focus suppression
- onClickCommand
- deferCompleteUntilChildrenIdle
- notificationSystem

## Files
- `opencode.json(c)`
- `~/.config/opencode/opencode-notifier.json`
- `opencode-notifier-state.json`
- `optional GNOME extension directory`

## Verification
- permission/completion/error/question events
- OPENCODE_NOTIFIER_DEBUG=1
- test harmless event command

## Decision
Added to the project because the research agents verified an OpenCode V2 entrypoint and an exact installation source. Runtime credentials and external services remain opt-in.
