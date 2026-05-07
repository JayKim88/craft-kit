#!/usr/bin/env bash
# Smoke test for recruit-kit init.mjs
# Verifies: scaffold runs, 9 docs created, .claude/ copied, git init + commit, placeholders preserved (quiet mode).

set -euo pipefail

KIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="/tmp/recruit-kit-smoke-$$"

cleanup() {
  rm -rf "$TARGET"
}
trap cleanup EXIT

echo "[smoke] target: $TARGET"
mkdir -p "$TARGET"

echo "[smoke] running init.mjs --quiet ..."
node "$KIT_ROOT/bin/init.mjs" --quiet --target "$TARGET" > /tmp/recruit-kit-smoke.log 2>&1 || {
  echo "[smoke] FAIL: init.mjs exited non-zero"
  cat /tmp/recruit-kit-smoke.log
  exit 1
}

echo "[smoke] checking 9 expected files ..."
EXPECTED=(
  "CLAUDE.md"
  "AGENTS.md"
  "README.md"
  ".gitignore"
  "docs/SPEC.md"
  "docs/PLAN.md"
  "docs/DESIGN.md"
  "docs/PROCESS.md"
  "docs/CHECKLIST.md"
  "docs/AI_USAGE.md"
)

MISSING=()
for f in "${EXPECTED[@]}"; do
  if [ ! -f "$TARGET/$f" ]; then
    MISSING+=("$f")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "[smoke] FAIL: missing files: ${MISSING[*]}"
  exit 1
fi
echo "[smoke] OK: all 10 files present"

echo "[smoke] checking .claude/ copied ..."
if [ ! -d "$TARGET/.claude/commands" ] || [ ! -d "$TARGET/.claude/agents" ]; then
  echo "[smoke] FAIL: .claude/ structure not copied"
  exit 1
fi
COMMANDS_COUNT=$(ls "$TARGET/.claude/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
AGENTS_COUNT=$(ls "$TARGET/.claude/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
echo "[smoke] OK: .claude/commands ($COMMANDS_COUNT files), .claude/agents ($AGENTS_COUNT files)"

echo "[smoke] checking git init + first commit ..."
cd "$TARGET"
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "[smoke] FAIL: not a git repo"
  exit 1
fi
COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
if [ "$COMMIT_COUNT" -lt 1 ]; then
  echo "[smoke] FAIL: no commits"
  exit 1
fi
LAST_MSG=$(git log -1 --pretty=%s)
echo "[smoke] OK: git initialized, $COMMIT_COUNT commit(s), last: \"$LAST_MSG\""

echo "[smoke] checking quiet mode preserved {{VAR}} placeholders ..."
PLACEHOLDER_FILES=$(grep -lc "{{" "$TARGET/CLAUDE.md" "$TARGET/docs/SPEC.md" "$TARGET/docs/PLAN.md" 2>/dev/null | wc -l | tr -d ' ')
if [ "$PLACEHOLDER_FILES" -lt 3 ]; then
  echo "[smoke] FAIL: quiet mode should preserve placeholders, but only $PLACEHOLDER_FILES files have {{ markers"
  exit 1
fi
echo "[smoke] OK: $PLACEHOLDER_FILES files contain {{VAR}} placeholders (quiet mode behavior)"

echo "[smoke] checking no stray .tpl files ..."
TPL_LEFTOVER=$(find "$TARGET" -name "*.tpl" 2>/dev/null | wc -l | tr -d ' ')
if [ "$TPL_LEFTOVER" -ne 0 ]; then
  echo "[smoke] FAIL: $TPL_LEFTOVER .tpl files left in target"
  find "$TARGET" -name "*.tpl"
  exit 1
fi
echo "[smoke] OK: no .tpl files in target"

echo ""
echo "[smoke] === ALL CHECKS PASSED ==="
echo "[smoke] target preserved at $TARGET for inspection — will be removed on exit"
ls "$TARGET" "$TARGET/docs" "$TARGET/.claude" 2>&1 | head -20
