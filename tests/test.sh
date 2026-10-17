#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
cat > "$TMP/opencode" <<'EOF'
#!/usr/bin/env bash
case "${1:-}" in --version) echo "OpenCode 2.0.99";; plugin) case "${2:-}" in --help) exit 0;; add) echo "ADD ${3:-}" >> "$FAKE_LOG";; remove) echo "REMOVE ${3:-}" >> "$FAKE_LOG";; esac;; esac
EOF
chmod +x "$TMP/opencode"; export PATH="$TMP:$PATH"; export FAKE_LOG="$TMP/log"; export XDG_STATE_HOME="$TMP/state"; export XDG_CONFIG_HOME="$TMP/config"
"$ROOT/bin/opencode-v2-extensions" doctor
"$ROOT/bin/opencode-v2-extensions" install --dry-run --yes
"$ROOT/bin/opencode-v2-extensions" install --allow-risky --yes
"$ROOT/bin/opencode-v2-extensions" status
"$ROOT/bin/opencode-v2-extensions" remove --yes
grep -q 'ADD opencode-todolist@0.6.1' "$FAKE_LOG"
grep -q 'REMOVE opencode-todolist@0.6.1' "$FAKE_LOG"
printf 'CLI simulation tests passed.\n'
