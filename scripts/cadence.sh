#!/usr/bin/env bash
# scripts/cadence.sh — observability digest for project progress.
# Read-only. No recommendations. Triggered by Procedure 5 or run directly.
set -euo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

today=$(date +%Y-%m-%d)
echo "=== Cadence check ($today) ==="

# 1. Commits today / 7d
commits_today=$(git log --since="$today 00:00" --pretty=oneline 2>/dev/null | wc -l | tr -d ' ')
commits_7d=$(git log --since='7 days ago' --pretty=oneline 2>/dev/null | wc -l | tr -d ' ')
echo "Commits today          : $commits_today"
echo "Commits last 7 days    : $commits_7d"

# 2. §N distribution
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

# 3. CHECKLIST progress
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

# 4. Days to deadline
deadline=""
if [ -f CLAUDE.md ]; then
  deadline=$(grep -oE '\*\*Deadline\*\*: `?<?[0-9]{4}-[0-9]{2}-[0-9]{2}' CLAUDE.md \
              | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' \
              | head -1 || true)
fi

days_left=""
if [ -n "$deadline" ]; then
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

# 5. Phase guess
last_feat=$(git log --pretty=%s 2>/dev/null | grep -E '^(feat|fix|refactor|test)' | head -1 || true)
if [ -z "$last_feat" ]; then
  echo "Likely current phase   : Phase A (no feat/fix/refactor/test commits yet)"
else
  echo "Likely current phase   : Phase C+ (last impl: $last_feat)"
fi

# 6. Quality grades (v0.9)
echo
echo "Quality grades:"
if [ -f docs/CHECKLIST.md ]; then
  # Extract rows from the Quality grades table (lines between the header row and the next ---)
  grades=$(awk '/^\| Domain \/ Layer/{found=1; next} found && /^\|---/{next} found && /^---/{exit} found && /^\|/{print}' docs/CHECKLIST.md)
  if [ -n "$grades" ]; then
    echo "$grades" | while IFS='|' read -r _ domain grade notes _; do
      domain=$(echo "$domain" | xargs)
      grade=$(echo "$grade" | xargs)
      if [ -n "$domain" ] && [ "$domain" != "Domain / Layer" ]; then
        printf "  %-28s %s\n" "$domain" "$grade"
      fi
    done
  else
    echo "  (not yet assessed)"
  fi
else
  echo "  (CHECKLIST.md not found)"
fi

# 7. Tech-debt open count (v0.9)
echo
if [ -f docs/exec-plans/tech-debt-tracker.md ]; then
  td_open=$(grep -cE '^\| TD-[0-9]' docs/exec-plans/tech-debt-tracker.md 2>/dev/null | tr -d ' ') || td_open=0
  td_red=$(grep -E '^\| TD-[0-9]' docs/exec-plans/tech-debt-tracker.md 2>/dev/null | grep -c '🔴' || true)
  echo "Tech debt open         : $td_open items ($td_red 🔴 critical)"
  # Also grep src/ for inline TODOs not yet tracked
  if [ -d src ]; then
    inline_todos=$(grep -rn 'TODO\|FIXME\|fix later' src/ 2>/dev/null | wc -l | tr -d ' ') || inline_todos=0
    if [ "$inline_todos" -gt 0 ]; then
      echo "  ⚠ $inline_todos inline TODO/FIXME in src/ (consider adding to tracker)"
    fi
  fi
else
  echo "Tech debt              : tracker not found"
fi

# 8. Stale docs check (v0.9) — docs/ files not touched in 3+ days
echo
echo "Stale docs (> 3 days since last commit):"
stale_found=0
for f in docs/*.md docs/exec-plans/*.md; do
  [ -f "$f" ] || continue
  last_commit=$(git log -1 --pretty='%ar' -- "$f" 2>/dev/null || echo "never")
  if [ "$last_commit" = "never" ]; then
    printf "  %-40s  (never committed)\n" "$f"
    stale_found=1
  else
    # Check if the age is more than 3 days by looking for 'days', 'weeks', 'months', 'years'
    if echo "$last_commit" | grep -qE '[4-9] days|[0-9]{2} days|weeks|months|years'; then
      printf "  %-40s  %s\n" "$f" "$last_commit"
      stale_found=1
    fi
  fi
done
if [ "$stale_found" -eq 0 ]; then
  echo "  ✅ all docs updated within 3 days"
fi

# 9. D-2 warning: recommend doc-gardening (v0.9)
if [ -n "$days_left" ] && [ "$days_left" -le 2 ] 2>/dev/null; then
  echo
  echo "⚠ D-$days_left WARNING: Consider running doc-gardening scan."
  echo "  Say \"가든\" or \"stale docs\" in chat to trigger Procedure 7."
fi

echo
echo "=== end ==="
