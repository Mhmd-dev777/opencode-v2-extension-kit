# Research: opencode-supermemory@2.0.17

- Compatibility: **v2-reviewed**
- Pinned artifact: `opencode-supermemory@2.0.17`
- Install: `bunx opencode-supermemory@2.0.17 install --no-tui`

## Requirements
- OpenCode V2 plugin API
- Bun for bunx installer
- SUPERMEMORY_API_KEY or login
- Network access to api.supermemory.ai

## Customization
- similarityThreshold
- maxMemories
- maxProjectMemories
- maxProfileItems
- injectProfile
- filterPrompt
- compactionEnabled
- recallMode
- captureEveryNTurns
- projectContainerTag
- userContainerTag

## Files
- `opencode.json(c)`
- `supermemory.json(c)`
- `~/.supermemory-opencode/credentials.json`
- `~/.config/opencode/commands/`
- `.opencode-supermemory.log`

## Verification
- supermemory status
- inspect v2 plugin registered log
- safe remember then recall in a new session

## Decision
Added to the project because the research agents verified an OpenCode V2 entrypoint and an exact installation source. Runtime credentials and external services remain opt-in.
