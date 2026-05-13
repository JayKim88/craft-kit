---
name: checklist-trace
description: Per-§N rubric coverage trace — count commits and checklist items per category, flag low-coverage rubric areas.
triggers:
  - "§N coverage"
  - "어디 부족"
  - "rubric trace"
  - "checklist trace"
---

# Checklist trace

Run [CLAUDE.md "Procedure 2 — Checklist trace"](../../CLAUDE.md).

**One-line invocation**:

```bash
git log --pretty=%s | grep -oE '\[§[0-9-]+(,§[0-9-]+)*\]' | tr -d '[]§' | tr ',' '\n' | sort | uniq -c
```

Cross-reference with rubric in `docs/SPEC.md "Rubric (detail)"`. Output the per-§N coverage table per Procedure 2 step 4. Flag any §N with 0 commits as point-leakage risk (unless auto-evaluated like Git history).
