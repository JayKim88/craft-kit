#!/usr/bin/env bash
# UserPromptSubmit hook — dynamic context injection at session start.
# Fires before every user message. Uses a session-ID marker to run exactly once
# per session. Outputs context to stdout → Claude sees it as prepended system context.
#
# Injected: current branch, active exec-plans, pending kit improvement count.

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

echo "[Session Context — craft-kit]"
echo "Branch        : ${branch}"
echo "Active plans  : ${active_plans}"
[ "${pending}" -gt 0 ] && echo "⚠ Kit improvement proposals pending: ${pending} — trigger kit-improve to review"
