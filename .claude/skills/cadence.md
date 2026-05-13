---
name: cadence
description: Read-only progress digest — commits today, §N distribution, CHECKLIST progress, days to deadline, likely current phase.
triggers:
  - "어디까지 왔어"
  - "오늘 진행"
  - "cadence"
  - "progress check"
  - "진행 상황"
---

# Cadence

Run [CLAUDE.md "Procedure 5 — Cadence check"](../../CLAUDE.md).

**Default implementation**: `bash scripts/cadence.sh`. If the script is missing, fall back to running its logic inline (see Procedure 5 step 2 in CLAUDE.md).

**Read-only by design**. Output the 8-line digest. Do **not** make recommendations — let the user interpret the numbers.
