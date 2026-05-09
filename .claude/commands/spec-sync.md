---
description: Detect drift in PLAN/DESIGN/CHECKLIST when SPEC.md changes
---

# /spec-sync

This command verifies that changes to `docs/SPEC.md` are reflected in the other documents (PLAN/DESIGN/CHECKLIST).

> **Note**: SPEC.md itself only changes when the company updates the spec (rare but it happens). We never modify it ourselves. This command is for syncing the rest after a company-side update.

## Behavior

1. Inspect SPEC.md history with `git log --follow docs/SPEC.md`.
2. Check whether PLAN/DESIGN/CHECKLIST were updated after the most recent SPEC change.
3. Identify the SPEC change region (by section) and map which sections of other docs are impacted:
   - SPEC "Implementation scope" change → PLAN §3 (scope), CHECKLIST Phase C
   - SPEC "Rubric" change → PLAN §5 (rubric mapping), CHECKLIST `[§N]` tags
   - SPEC "API schema" change → DESIGN.md ADR (relevant data structures)
   - SPEC "Constraints" change → PLAN.md §3 (out-of-scope), DESIGN.md §6 (error handling)
4. On drift, report a table:
   ```
   SPEC change                              | Doc to update     | Status
   -----------------------------------------|-------------------|--------
   §3 bonus item added ("weekly comparison") | PLAN.md §3 table  | ❌ missing
   §5 §2 points 25→30                       | PLAN.md §5 table  | ❌ missing
   §5 §2 points 25→30                       | CHECKLIST §2 tag  | ✅ reflected
   ```

## Usage

```
/spec-sync
```

Options:
- `--since <commit-sha>` — check only changes since a specific commit
- `--diff-only` — print the drift table only (no auto-fix suggestions)

## Sample output

```
=== SPEC Drift Check ===

SPEC.md last modified: 2026-05-04 (commit a3b2c1d)
Documents checked since:
  PLAN.md       — last touched 2026-05-04 ✅
  DESIGN.md     — last touched 2026-05-03 ⚠ (before SPEC change)
  CHECKLIST.md  — last touched 2026-05-04 ✅
  README.md     — last touched 2026-05-02 ⚠

SPEC change summary:
  - §Rubric §3 added item: "Prevent duplicate save" (company addition)

Drift detected:
  | Where in SPEC                   | Required action                            |
  |---------------------------------|--------------------------------------------|
  | §3 (Stability) added "no dup"   | Add CHECKLIST §3 item with [§3] tag        |
  | §3 points (currently 20)        | Verify PLAN.md §5 score table              |
  | §3 description                  | DESIGN.md "Error handling" section update  |

Recommendation: 3 unreflected items above. Sync via dedicated docs commits before resuming work.
```

## Notes

- This command is meaningful only when SPEC.md actually changed. Otherwise it reports "all in sync".
- AI must NOT auto-edit other documents — explicit user confirmation required.
- A company-side SPEC change directly affects evaluation; never ignore it.
