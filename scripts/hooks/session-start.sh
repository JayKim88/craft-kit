#!/usr/bin/env bash
# UserPromptSubmit hook — dynamic context injection at session start.
# Fires before every user message. Uses a session-ID marker to run exactly once
# per session. Outputs context to stdout → Claude sees it as prepended system context.
#
# Injected: current branch, active exec-plans, pending kit improvement count,
#           CHECKLIST progress, days to deadline, last commit summary,
#           coding-style read-nudge (only when src/ exists).

set -euo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || exit 0

input=$(cat 2>/dev/null || echo "{}")
session_id=$(echo "$input" | python3 -c "
import sys, json
print(json.load(sys.stdin).get('session_id', ''))
" 2>/dev/null || echo "")

[ -z "$session_id" ] && exit 0

marker="/tmp/craft-kit-ctx-${session_id}"
[ -f "$marker" ] && exit 0
touch "$marker"

branch=$(git branch --show-current 2>/dev/null || echo "unknown")

active_plans=$(
  ls docs/exec-plans/active/*.md 2>/dev/null \
  | grep -v TEMPLATE.md \
  | xargs -I{} basename {} .md 2>/dev/null \
  | paste -sd ', ' - \
  || echo "none"
)

pending=$(ls docs/kit/improvements/pending/*.md 2>/dev/null | wc -l | tr -d ' ')

checklist_line="not found"
if [ -f docs/CHECKLIST.md ]; then
  done_count=$(grep -cE '^- \[x\]' docs/CHECKLIST.md 2>/dev/null) || done_count=0
  open_count=$(grep -cE '^- \[ \]' docs/CHECKLIST.md 2>/dev/null) || open_count=0
  total=$((done_count + open_count))
  if [ "$total" -gt 0 ]; then
    pct=$((done_count * 100 / total))
    checklist_line="${done_count} / ${total} (${pct}%) done"
  else
    checklist_line="empty"
  fi
fi

deadline_line="unknown (placeholder in CLAUDE.md)"
if [ -f CLAUDE.md ]; then
  deadline=$(grep -oE '\*\*Deadline\*\*: `?<?[0-9]{4}-[0-9]{2}-[0-9]{2}' CLAUDE.md \
    | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || true)
  if [ -n "$deadline" ]; then
    if deadline_epoch=$(date -j -f "%Y-%m-%d" "$deadline" "+%s" 2>/dev/null) || \
       deadline_epoch=$(date -d "$deadline" "+%s" 2>/dev/null); then
      today_epoch=$(date "+%s")
      days_left=$(( (deadline_epoch - today_epoch) / 86400 ))
      deadline_line="${days_left}d (${deadline})"
    fi
  fi
fi

last_commit=$(git log -1 --pretty="%s — %ar" 2>/dev/null || echo "no commits")

echo "[Session Context — craft-kit]"
echo "Branch        : ${branch}"
echo "Active plans  : ${active_plans}"
echo "CHECKLIST     : ${checklist_line}"
echo "Deadline      : ${deadline_line}"
echo "Last commit   : ${last_commit}"
[ -d src ] && echo "Coding style  : read docs/kit/CODING-STYLE.md §2 before editing src/ (§1 rules auto-enforced by eslint)"
[ "${pending}" -gt 0 ] && echo "⚠ Kit improvement proposals pending: ${pending} — trigger kit-improve to review"
