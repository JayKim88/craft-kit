#!/usr/bin/env bash
# PostToolUse hook — instant lint advisory after Write/Edit to src/ files.
# Non-blocking: always exits 0. Gates 1-5 in .githooks/pre-commit are authoritative.
# Only surfaces ERRORS (not warnings) to avoid noise during normal development.
#
# Supported stacks: TypeScript/TSX (eslint), Python (ruff).

set -uo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || exit 0

input=$(cat 2>/dev/null || echo "{}")
file=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('tool_input', {}).get('file_path', ''))
" 2>/dev/null || echo "")

[ -z "$file" ] || [ ! -f "$file" ] && exit 0

# Only check files inside src/
echo "$file" | grep -q '/src/' || exit 0

case "$file" in
  *.ts|*.tsx)
    if [ -f package.json ] && grep -q '"lint"' package.json 2>/dev/null; then
      result=$(npx --no-install eslint "$file" --format compact --max-warnings 0 2>&1 || true)
      errors=$(echo "$result" | grep ': error' || true)
      [ -n "$errors" ] && echo "[lint:error] $(basename "$file") — ${errors}" >&2
    fi
    ;;
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      result=$(ruff check "$file" 2>&1 || true)
      [ -n "$result" ] && echo "[lint] $(basename "$file") — ${result}" >&2
    fi
    ;;
esac

exit 0
