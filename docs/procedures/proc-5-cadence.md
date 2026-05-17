# Procedure 5 — Cadence Check

**Trigger**: "어디까지 왔어" / "오늘 진행" / "cadence" / "progress check" / "진행 상황".

---

## Steps

1. Run `bash scripts/cadence.sh`. If missing or exits non-zero, run step 2 inline.

2. **Inline equivalent**:
   - Commits today: `git log --since="$(date +%Y-%m-%d) 00:00" --oneline | wc -l`
   - Commits 7d: `git log --since='7 days ago' --oneline | wc -l`
   - §N dist: `git log --pretty=%s | grep -oE '\[§[0-9-]+(,§[0-9-]+)*\]' | tr -d '[]§' | tr ',' '\n' | sort | uniq -c | sort -rn`
   - CHECKLIST: `grep -c '^- \[ \]' docs/CHECKLIST.md` and `grep -c '^- \[x\]' docs/CHECKLIST.md`
   - Deadline: parse `**Deadline**:` line in CLAUDE.md "Assignment overview"
   - Phase guess: `git log --pretty=%s | grep -E '^(feat|fix|refactor|test)' | head -1` — empty → Phase A

3. **Output** (read-only digest):
   - Commits today / 7d
   - §N distribution sorted desc
   - CHECKLIST done/total (%)
   - Days to deadline
   - Likely phase
   - Quality grades table from `docs/CHECKLIST.md` (verbatim; if all `—` → "not yet assessed")
   - Tech-debt open count from `docs/exec-plans/tech-debt-tracker.md`
   - Stale docs warning if cadence.sh reports any

4. **Do NOT make recommendations**. Read-only observability — user decides.
