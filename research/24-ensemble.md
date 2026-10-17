# Research: hueyexe/opencode-ensemble@0.18.0

- Compatibility: **v2-reviewed**
- Pinned artifact: `@hueyexe/opencode-ensemble@0.18.0`
- Install: `opencode plugin add @hueyexe/opencode-ensemble@0.18.0`

## Requirements
- OpenCode V2
- Node >=24 or Bun >=1.0
- Writable ~/.config/opencode/ensemble.db
- Git for worktree agents

## Customization
- mergeOnCleanup
- stallThresholdMs
- stallMinSteps
- stallTokenThreshold
- timeoutMs
- rateLimitCapacity
- dashboardPort
- peerMessageLimit
- defaultModel
- modelPool
- modelsByAgent
- modelAssignment

## Files
- `~/.config/opencode/ensemble.json`
- `<project>/.opencode/ensemble.json`
- `~/.config/opencode/ensemble.db`
- `~/.local/share/opencode/worktree/`

## Verification
- /api/health on localhost:4747 if enabled
- team_create/team_spawn with worktree:false
- database rehydration after restart

## Decision
Added to the project because the research agents verified an OpenCode V2 entrypoint and an exact installation source. Runtime credentials and external services remain opt-in.
