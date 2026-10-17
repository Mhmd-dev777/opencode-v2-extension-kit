# Research: opencode-tavily

- Compatibility: **v2-reviewed**
- Pinned artifact: `opencode-tavily@1.0.0`
- Install: `opencode plugin add opencode-tavily@1.0.0`

## Requirements
- OpenCode V2
- tvly on PATH
- Tavily account and TAVILY_API_KEY or OAuth
- Network access
- Writable .tavily/

## Customization
- tvly CLI flags
- search depth
- max-results
- domains
- time-range
- extract depth
- crawl breadth/depth
- output directory

## Files
- `opencode.json(c)`
- `skills/tavily/`
- `.tavily/`
- `tvly executable`

## Verification
- tvly --status
- search with --client-name opencode
- extract/map/crawl smoke tests

## Decision
Added to the project because the research agents verified an OpenCode V2 entrypoint and an exact installation source. Runtime credentials and external services remain opt-in.
