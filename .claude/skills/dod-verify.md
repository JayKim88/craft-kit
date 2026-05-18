---
name: dod-verify
description: 7-gate Definition-of-Done verification before any feature commit. Triggers on commit-readiness signals.
triggers:
  - "ready to commit"
  - "DoD check"
  - "verify gates"
  - "커밋해도 돼"
  - "커밋 가능"
---

# DoD verify

Run the 7-gate Definition of Done as defined in [CLAUDE.md "Procedure 1 — DoD verification"](../../CLAUDE.md).

**Authoritative source**: `CLAUDE.md` Procedure 1. Do not duplicate steps here — if you find drift between this skill and CLAUDE.md, CLAUDE.md wins.

**Quick reference**:
1. Detect stack (node/python/rust/go/java) → 2. Run gates 1–5 (auto) → 3. Report gates 6/6b/7 (manual)
4. Block commit until auto gates pass.

**Hook integration**: The `.githooks/pre-commit` script enforces gates 1–5 at git-commit time as a safety net. Procedure 1's role is (a) reporting results in chat for visibility, (b) covering manual gates 6/6b/7 that the hook does not enforce, (c) running the optional Tier-4 auto-corrective (Procedure 1 step 3b).
