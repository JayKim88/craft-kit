# Procedure 2 — Checklist Trace (§N Coverage)

**Trigger**: "§N coverage" / "어디 부족" / "rubric trace" / "checklist trace" / D-1 polish phase.

---

## Steps

1. Extract per-§N commit counts:
   ```
   git log --pretty=%s | grep -oE '\[§[0-9-]+(,§[0-9-]+)*\]' | tr -d '[]§' | tr ',' '\n' | sort | uniq -c
   ```

2. Extract per-§N CHECKLIST item counts:
   ```
   grep -oE '\[§[0-9-]+\]' docs/CHECKLIST.md | sort | uniq -c
   ```

3. Cross-reference with rubric in `docs/SPEC.md` "Rubric (detail)" → category names + max points.

4. Output table:
   ```
   | §N | Category | Points | Commits | Checklist items | Status      |
   |----|----------|--------|---------|-----------------|-------------|
   | §1 | ...      | 20     | 6       | 12              | ✅ healthy   |
   | §5 | Docs     | 10     | 1       | 3               | ⚠ low       |
   ```

5. Flag any §N with 0 commits as a point-leakage risk (unless auto-evaluated, e.g. "Git history").
