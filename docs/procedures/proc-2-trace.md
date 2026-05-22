# Procedure 2 — Checklist Trace (§N Coverage)

**Trigger**: "§N coverage" / "어디 부족" / "criteria trace" / "checklist trace" / D-1 polish phase.

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

3. Cross-reference with criteria in `docs/SPEC.md` "Requirements (detail)" → category names. Include point weights only if SPEC defines them.

4. Output table:
   ```
   | §N | Category | Commits | Checklist items | Status       |
   |----|----------|---------|-----------------|--------------|
   | §1 | ...      | 6       | 12              | ✅ covered    |
   | §5 | Docs     | 1       | 3               | ⚠ thin       |
   ```
   If SPEC defines numeric scores, add a `Weight (pts)` column between Category and Commits.

5. Flag any §N with 0 commits as an **uncovered requirement risk** (unless auto-evaluated, e.g. "Git history").
