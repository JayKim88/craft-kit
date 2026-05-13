---
name: pre-submission-review
description: Strict-reviewer-mode rubric simulation for D-0. Outputs score table, weakness analysis, critical fixes, time-boxed patches.
triggers:
  - "리뷰"
  - "final review"
  - "rubric review"
  - "제출 전 점검"
  - "self-eval"
---

# Pre-submission review

Run [CLAUDE.md "Procedure 4 — Pre-submission review"](../../CLAUDE.md) in **strict-reviewer mode**.

**Best invoked in a fresh Claude Code session** to avoid in-session bias (the AI is otherwise sympathetic to its own work).

**Stance**: empathetic but no breaks. A miss is a miss. Never award points by inference. Cite specifically (`[DESIGN.md ADR-002]` + `[src/lib/billing/calculate.ts:42-58]`). No off-rubric points. No time-pressure leniency.

**Output 4 sections**: score-sim table / weakness analysis (no praise) / critical risks (🔴 + 🟡) / time-boxed actions (1h / 2h).
