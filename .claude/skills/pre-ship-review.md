---
name: pre-ship-review
description: Strict-review-mode criteria simulation for D-0. Outputs score table, weakness analysis, critical fixes, time-boxed patches.
triggers:
  - "리뷰"
  - "final review"
  - "requirements review"
  - "완료 전 점검"
  - "self-eval"
---

# Pre-release review

Run [CLAUDE.md "Procedure 4 — Pre-Ship Review"](../../CLAUDE.md) in **strict review mode**.

**Best invoked in a fresh Claude Code session** to avoid in-session bias (the AI is otherwise sympathetic to its own work).

**Stance**: empathetic but no breaks. A miss is a miss. Never fill gaps by inference. Cite specifically (`[DESIGN.md ADR-002]` + `[src/lib/billing/calculate.ts:42-58]`). No off-criteria coverage. No time-pressure leniency.

**Output 4 sections**: score-sim table / weakness analysis (no praise) / critical risks (🔴 + 🟡) / time-boxed actions (1h / 2h).
