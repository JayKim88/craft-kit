# Procedure 7 — Doc-Gardening Scan

**Trigger**: "stale docs" / "doc scan" / "가든" / "문서 점검" / start of Phase D.

---

## Steps

### 1. Find recently changed source files

```bash
git log --since='3 days ago' --name-only --pretty=format: -- src/ | sort -u | grep -v '^$'
```

If no src/ changes in 3 days → report "No src/ changes in last 3 days — doc-gardening skipped."

### 2. Build stale-doc table

For each file in `docs/`:
```bash
git log -1 --pretty='%ar' -- docs/<file>
```
Output: `file | last updated | age`

### 3. Cross-check each stale doc (> 3 days) against recent src/ diff

- `docs/DESIGN.md` — ADR interface names present in diff as renamed/removed symbols?
- `docs/PLAN.md §3` — diff introduces features not in Required/Optional scope?
- `docs/CHECKLIST.md` quality grades — grades still reflect current diff?
- `docs/exec-plans/tech-debt-tracker.md` — diff resolves open TD items, or introduces new shortcuts?
- `README.md` "How to run" / "Project structure" — stale paths or command names?

### 4. Output

```
=== Doc-gardening scan ===
Stale docs (not updated in 3+ days):
  docs/DESIGN.md    (5 days ago) — ⚠ ADR-002 may be stale: `ScheduleService` removed in src/
  docs/PLAN.md      (2 days ago) — ✅ in sync
  README.md         (7 days ago) — ⚠ "How to run" references `npm run dev` (renamed to `start`)
  tech-debt-tracker (1 day ago)  — ✅ in sync

Recommended actions (per item):
  (a) Fix inline now
  (b) Separate `docs:` commit before next feat commit
  (c) Defer → add to CHECKLIST.md "📌 Extra TODO"
```

### 5. Never auto-edit

Present findings only. User chooses disposition per item.

### 6. False-positive caveat

Symbol matches are textual, not semantic. User judgment is final.
