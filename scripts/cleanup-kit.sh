#!/usr/bin/env bash
# Run once before making the repository public.
# Removes local tooling that was never committed.
# This script deletes itself on completion.
set -euo pipefail

TARGETS=(
  .claude/
  .githooks/
  docs/procedures/
  docs/exec-plans/
  docs/HARNESS.md
  docs/OVERVIEW.md
  docs/GUIDE.md
  CLAUDE.md
  AGENTS.md
)

echo "Removing local tooling..."
for t in "${TARGETS[@]}"; do
  if [ -e "$t" ]; then
    rm -rf "$t"
    echo "  removed $t"
  fi
done

# Remove this script last
rm -f scripts/cleanup-kit.sh
rmdir scripts 2>/dev/null || true   # remove scripts/ if now empty

echo ""
echo "Done. Next steps:"
echo "  git status          — confirm only expected files remain"
echo "  git add . && git commit -m 'chore: pre-submission cleanup'"
echo "  (make repo public)"
