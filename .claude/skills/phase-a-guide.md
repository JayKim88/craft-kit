---
name: phase-a-guide
description: Phase A guided fill — surface SPEC ambiguities one at a time with 3-option A/B/C tables, force user to pick, append rows to PLAN.md §2. Never decide for the user.
triggers:
  - "fill PLAN"
  - "start Phase A"
  - "Phase A 시작"
  - "PLAN 채우자"
  - "docs/PLAN.md 같이 채우자"
  - "doc alignment"
---

# Phase A guided fill

Run [CLAUDE.md "Procedure 6 — Phase A guided fill"](../../CLAUDE.md).

**Authoritative source**: CLAUDE.md Procedure 6.

**Stance**: Phase A is judgment-heavy. AI surfaces ambiguities; the user decides. Never pre-pick an option. Never propose options outside SPEC's stated scope. One ambiguity per round.

**Output**: For each SPEC ambiguity, present a 3-option A/B/C table (Strict / Lenient / Ask). After the user picks, append one row to `docs/PLAN.md` §2 (5-column Assumption-Map: ambiguity / decision / rationale / confidence / verified by).

**Prerequisite**: `docs/SPEC.md` must contain a real spec, not the `[[ paste original company spec here ]]` placeholder.

**Anti-patterns** (do not do):
- Pitch one option as obviously correct
- Propose options outside SPEC's stated scope
- Decide for the user
- Bundle multiple ambiguities into one round
- Write code (Phase A is doc-only)
