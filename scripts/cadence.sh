#!/usr/bin/env bash
# scripts/cadence.sh — observability digest for take-home progress.
# Read-only. Prints commits today/7d, §N distribution, CHECKLIST progress,
# days to deadline, likely phase. No recommendations.
#
# Triggered by AI Procedure 5 (CLAUDE.md) — also runnable directly.
set -euo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

today=$(date +%Y-%m-%d)
echo "=== Cadence check ($today) ==="

# 1. Commits today
commits_today=$(git log --since="$today 00:00" --pretty=oneline 2>/dev/null | wc -l | tr -d ' ')
echo "Commits today          : $commits_today"

# 2. Commits last 7 days
commits_7d=$(git log --since='7 days ago' --pretty=oneline 2>/dev/null | wc -l | tr -d ' ')
echo "Commits last 7 days    : $commits_7d"

# 3. §N distribution (all-time)
echo
echo "§N distribution (all-time):"
dist=$(git log --pretty=%s 2>/dev/null \
  | grep -oE '\[§[0-9-]+(,§[0-9-]+)*\]' \
  | tr -d '[]§' \
  | tr ',' '\n' \
  | sort \
  | uniq -c \
  | sort -rn \
  | awk '{printf "  §%-3s %s\n", $2, $1}')
if [ -n "$dist" ]; then
  echo "$dist"
else
  echo "  (no §N-tagged commits yet)"
fi

# 4. CHECKLIST progress
echo
if [ -f docs/CHECKLIST.md ]; then
  open_count=$(grep -cE '^- \[ \]' docs/CHECKLIST.md 2>/dev/null) || open_count=0
  done_count=$(grep -cE '^- \[x\]' docs/CHECKLIST.md 2>/dev/null) || done_count=0
  total=$((open_count + done_count))
  if [ "$total" -gt 0 ]; then
    pct=$((done_count * 100 / total))
    echo "CHECKLIST              : $done_count / $total ($pct%) done, $open_count open"
  else
    echo "CHECKLIST              : empty"
  fi
else
  echo "CHECKLIST              : docs/CHECKLIST.md not found"
fi

# 5. Days to deadline (parsed from CLAUDE.md "Assignment overview")
deadline=""
if [ -f CLAUDE.md ]; then
  deadline=$(grep -oE '\*\*Deadline\*\*: `?<?[0-9]{4}-[0-9]{2}-[0-9]{2}' CLAUDE.md \
              | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' \
              | head -1 || true)
fi

if [ -n "$deadline" ]; then
  # macOS BSD date first, then GNU date fallback
  if deadline_epoch=$(date -j -f "%Y-%m-%d" "$deadline" "+%s" 2>/dev/null); then
    :
  elif deadline_epoch=$(date -d "$deadline" "+%s" 2>/dev/null); then
    :
  else
    deadline_epoch=""
  fi

  if [ -n "$deadline_epoch" ]; then
    today_epoch=$(date "+%s")
    days_left=$(( (deadline_epoch - today_epoch) / 86400 ))
    echo "Days to deadline       : $days_left  (deadline: $deadline)"
  else
    echo "Days to deadline       : unknown (date parse failed)"
  fi
else
  echo "Days to deadline       : unknown (deadline placeholder in CLAUDE.md)"
fi

# 6. Phase guess from latest non-docs commit
last_feat=$(git log --pretty=%s 2>/dev/null | grep -E '^(feat|fix|refactor|test)' | head -1 || true)
if [ -z "$last_feat" ]; then
  echo "Likely current phase   : Phase A (doc alignment) — no feat/fix/refactor/test commits yet"
else
  echo "Likely current phase   : Phase C+ (last impl commit: $last_feat)"
fi
