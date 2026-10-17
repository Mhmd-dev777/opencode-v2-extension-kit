# Research: open-codebase-index@0.36.3

- Compatibility: **v2-reviewed**
- Pinned artifact: `open-codebase-index@0.36.3`
- Install: `opencode plugin add open-codebase-index@0.36.3`

## Requirements
- OpenCode V2
- Node >=22.13.0
- Embedding provider: Ollama, OpenAI, Google, or custom endpoint
- Writable .opencode/index/

## Customization
- embeddingProvider
- embeddingModel
- autoIndex
- watchFiles
- maxFileSize
- maxChunksPerFile
- include
- exclude
- maxResults
- hybridWeight
- rerankTopN
- knowledgeBases

## Files
- `.opencode/codebase-index.json`
- `~/.config/opencode/codebase-index.json`
- `.opencode/index/`
- `~/.opencode/global-index/`

## Verification
- index_status or /status
- index_codebase or /index
- codebase_search and codebase_context

## Decision
Added to the project because the research agents verified an OpenCode V2 entrypoint and an exact installation source. Runtime credentials and external services remain opt-in.
