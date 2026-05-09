---
description: Verify [§N] tag mapping between commit messages and CHECKLIST.md
---

# /checklist-trace

This command verifies that every commit in `git log` carries a `[§N]` tag, and that those tags align with the `[§N]` items in CHECKLIST.md.

The system makes it possible for the reviewer to instantly see which work contributed to each rubric §N (e.g. Code Structure 25 pts, Git Trail 10 pts).

## Behavior

1. **Commit scan**: collect every commit message with `git log --pretty=%H|%s`.
2. **Tag extraction**: extract `[§N]` or `[§N,§M]` patterns from each message. No tag → untagged.
3. **CHECKLIST scan**: extract `[§N]`-tagged items from `docs/CHECKLIST.md`.
4. **Mapping verification**:
   - Per §N: count commits + count checklist items
   - Report **untagged commits** (warn if not infrastructure/chore)
   - Report any §N with 0 commits (point-leakage risk)

## Sample output

```
=== Checklist Trace ===

Total commits: 61
Tagged commits: 58
Untagged commits: 3
  - 79ed36e chore(init): scaffold ... [acceptable: chore]
  - a3b2c1d docs: typo fix [⚠ should have [§5] or [§-]]
  - 5f7e9d2 fix: revert breaking change [⚠ missing tag]

Per-criterion mapping:

| §N | Category                    | Points | Commits | Checklist items | Status |
|----|-----------------------------|--------|---------|-----------------|--------|
| §1 | Requirements understanding  | 20     | 8       | 12              | ✅ healthy |
| §2 | Code structure + design     | 25     | 24      | 35              | ✅ healthy |
| §3 | Stability + exceptions      | 20     | 11      | 18              | ✅ healthy |
| §4 | UI/UX                       | 15     | 9       | 14              | ✅ healthy |
| §5 | Documentation               | 10     | 4       | 8               | ⚠ low coverage |
| §6 | Git history                 | 10     | 0       | 0               | (auto-evaluated) |

Untagged risk:
  - 3 untagged commits: 2 acceptable (chore/init), 1 concerning (a3b2c1d)
  - Recommendation: amend a3b2c1d with [§5] tag if not yet pushed; otherwise add the tag in the next commit body

Coverage gap:
  - §5 (Documentation) has few commits — consider isolating README/docs updates into their own `docs:` commits.
```

## Usage

```
/checklist-trace
```

Options:
- `--strict` — exit 1 if any untagged commits exist
- `--criterion <N>` — list only the commits for a given §N

## Notes

- `[§-]` deliberately marks "does not directly contribute to the rubric" (e.g. `chore(deps)`, `chore(format)`).
- A commit contributing to multiple §N uses `[§2,§3]`, etc.
- When git history itself is a rubric item (§Git), splitting refactor/test into separate commits earns extra credit.
