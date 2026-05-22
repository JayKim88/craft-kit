# Procedure 3 — SPEC Drift Check

**Trigger**: "SPEC updated" / "requirements changed" / observed change to `docs/SPEC.md`.

---

## Steps

1. Find most recent SPEC change:
   ```
   git log --follow --pretty='%h %s' docs/SPEC.md
   ```

2. Map the changed region to impact zones:
   - Implementation scope → PLAN §3 + CHECKLIST Phase C
   - Requirements → PLAN §5 + CHECKLIST `[§N]` tags
   - API schema → DESIGN ADRs
   - Constraints → PLAN §3 (out-of-scope) + DESIGN §6 (errors)

3. For each impacted doc, check `git log -1 --pretty=%at <doc>` vs SPEC change time.

4. Report a drift table. **Never auto-edit** — propose changes for user approval only.
