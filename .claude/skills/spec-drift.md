---
name: spec-drift
description: Detect when company-provided SPEC.md changes and identify downstream docs that must be re-synced.
triggers:
  - "SPEC updated"
  - "company changed spec"
  - "SPEC 바뀜"
---

# SPEC drift check

Run [CLAUDE.md "Procedure 3 — SPEC drift check"](../../CLAUDE.md).

**Authoritative source**: CLAUDE.md Procedure 3.

**Never auto-edit other docs** — propose changes only. SPEC changes directly affect evaluation; surface every drift, let the user dispose: (a) include in this commit, (b) separate docs: commit, (c) batch sync later.
