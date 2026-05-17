# Procedure 4 — Pre-Submission Review (Strict Reviewer Mode)

**Trigger**: "리뷰" / "final review" / "rubric review" / "제출 전 점검" / "self-eval" / D-0 polish.

**Recommended invocation**: open a **fresh Claude Code session**. If same session, explicitly clear prior assumptions.

---

## Stance (this procedure only)

- Empathetic but no breaks. A miss is a miss. Never award points by inference.
- Cite specifically: `[DESIGN.md ADR-002]` + `[src/lib/billing/calculate.ts:42-58]`. Never "this is nice".
- No off-rubric points. No time-pressure leniency.

---

## Steps

### Read

All of: `docs/SPEC.md`, `README.md`, `docs/CHECKLIST.md`, `docs/AI_USAGE.md`, `docs/DESIGN.md`, `docs/PLAN.md`, `git log --oneline | head -50`. Optionally `Glob "src/**/*"`, `Glob "**/*.test.*"`.

### Cross-check: SPEC origin coverage (v0.8)

Count `**SPEC origin**:` occurrences in `docs/DESIGN.md` vs `### ADR-` headings. Gap → 🔴 critical Documentation-rubric issue.

### Self-review pass (v0.9)

Before producing output, perform one silent pass:
1. Read `git diff main...HEAD -- src/` (or full diff if main is not base branch).
2. Apply each rubric criterion from `docs/SPEC.md` "Rubric (detail)" to the diff directly.
3. Note criteria with **zero** evidence in the diff (not just zero commits).
4. Carry findings into Weakness analysis.

---

## Output (4 sections)

1. **Score-simulation table**: per §N — max / sim score / 1-line rationale → `**Total** | | 100 | **NN/100**`
2. **Weakness analysis** (weaknesses only, no praise): per §N, 1-3 bullets of what's needed for max.
3. **Critical-omission risks**: 🔴 must fix before submission / 🟡 if time permits.
4. **Next actions** (time-boxed): "1 hour for +N points: ..." / "Additional 2 hours for +M points: ..."

End with: *"This is a simulation, not the real evaluation. Real reviewers may weight differently."*
