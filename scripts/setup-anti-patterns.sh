#!/bin/bash
# Install Waza Anti-Patterns rules into Claude Code or Codex.
set -e

TARGET="${1:-claude-code}"
RAW="https://raw.githubusercontent.com/tw93/Waza/main/rules/anti-patterns.md"

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required but not installed." >&2
  exit 1
fi

case "$TARGET" in
  claude-code|claude)
    mkdir -p "$HOME/.claude/rules"
    curl -fsSL "$RAW" -o "$HOME/.claude/rules/anti-patterns.md"
    echo "Waza Anti-Patterns installed for Claude Code."
    ;;

  codex)
    if ! command -v python3 >/dev/null 2>&1; then
      echo "Error: python3 is required but not installed." >&2
      exit 1
    fi

    mkdir -p "$HOME/.codex"
    tmp="$(mktemp)"
    trap 'rm -f "$tmp"' EXIT
    curl -fsSL "$RAW" -o "$tmp"

    python3 - "$tmp" "$HOME/.codex/AGENTS.md" <<'PYEOF'
from pathlib import Path
import sys

source = Path(sys.argv[1]).read_text().strip()
target = Path(sys.argv[2])
start = "<!-- Waza Anti-Patterns: start -->"
end = "<!-- Waza Anti-Patterns: end -->"
block = f"{start}\n{source}\n{end}\n"
text = target.read_text() if target.exists() else ""

if start in text and end in text:
    before = text.split(start, 1)[0].rstrip()
    after = text.split(end, 1)[1].lstrip()
    text = f"{before}\n\n{block}\n{after}".rstrip() + "\n"
else:
    text = text.rstrip() + "\n\n" + block

target.write_text(text)
PYEOF
    echo "Waza Anti-Patterns installed for Codex."
    ;;

  *)
    echo "Usage: setup-anti-patterns.sh [claude-code|codex]" >&2
    exit 1
    ;;
esac
