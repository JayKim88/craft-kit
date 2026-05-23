---
name: doc-gardening
description: Scan docs/ for staleness vs recent src/ changes. Report only — no auto-edit. User chooses disposition per item.
triggers:
  - "stale docs"
  - "doc scan"
  - "가든"
  - "문서 점검"
---

# Doc-Gardening Scan

Run [CLAUDE.md "Procedure 7 — Doc-Gardening Scan"](../../CLAUDE.md) in **report-only mode**.

**Never auto-edit docs.** Present findings; user picks (a) fix inline / (b) separate `docs:` commit / (c) defer.

**One-line scope**:

```bash
git log --since='3 days ago' --name-only --pretty=format: -- src/ | sort -u | grep -v '^$'
```

Cross-reference each stale `docs/` file (> 3 days) against the above src/ diff. Flag symbol renames, scope drift, stale "How to run" commands, and unresolved tech-debt items per Procedure 7 step 3.
