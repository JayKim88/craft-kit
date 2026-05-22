---
name: spec-drift
description: Detect when SPEC.md / project requirements change and identify downstream docs that must be re-synced.
triggers:
  - "SPEC updated"
  - "requirements changed"
  - "SPEC 바뀜"
---

# SPEC drift check

Run [CLAUDE.md "Procedure 3 — SPEC drift check"](../../CLAUDE.md).

**Authoritative source**: CLAUDE.md Procedure 3.

**Never auto-edit other docs** — propose changes only. SPEC changes directly affect evaluation; surface every drift, let the user dispose: (a) include in this commit, (b) separate docs: commit, (c) batch sync later.
