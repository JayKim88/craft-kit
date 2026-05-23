# Procedure 4 — Pre-Ship Review (Strict Review Mode)

**Trigger**: "리뷰" / "final review" / "requirements review" / "완료 전 점검" / "self-eval" / D-0 polish.

**Recommended invocation**: open a **fresh Claude Code session**. If same session, explicitly clear prior assumptions.

---

## Stance (this procedure only)

- Empathetic but no breaks. A miss is a miss. Never fill gaps by inference.
- Cite specifically: `[DESIGN.md ADR-002]` + `[src/lib/billing/calculate.ts:42-58]`. Never "this is nice".
- No off-criteria coverage. No time-pressure leniency.

---

## ⚠ Rationalization check — read before executing

Each feels like a reasonable exception. None are.

| If you think... | What actually happens |
|---|---|
| "Deadline is close — this gap is acceptable" | The gap ships; it cannot be unflagged after the fact |
| "I saw good work in one area — it probably covers §N" | You filled a gap by inference; the criterion remains unmet |
| "User worked hard — I should acknowledge the positives" | Praise dilutes the signal; user misses real risks |
| "A commit exists for this §N — it's covered" | Coverage requires evidence in the diff, not just a commit message |
| "Fresh session isn't necessary — I remember the context" | In-session bias inflates perceived quality; start clean |

**Iron law**: No leniency for deadline pressure. No gap filled by inference. Cite specifically or mark ❌.

---

## Steps

### 0. Detect mode

Check if `docs/SPEC.md "Requirements (detail)"` sections contain numeric scores (`pts`):
- **Yes → Score-simulation mode** — SPEC defines a grading rubric; produce per-§N point estimates.
- **No → Coverage-check mode (default)** — SPEC defines requirements only; produce coverage status per §N.

### Read

All of: `docs/SPEC.md`, `README.md`, `docs/CHECKLIST.md`, `docs/DESIGN.md`, `docs/PLAN.md`, `git log --oneline | head -50`. Optionally `Glob "src/**/*"`, `Glob "**/*.test.*"`.

### Cross-check: SPEC origin coverage (v0.8)

Count `**SPEC origin**:` occurrences in `docs/DESIGN.md` vs `### ADR-` headings. Gap → 🟡 potential documentation gap (🔴 critical only when SPEC defines explicit scoring criteria).

### Self-review pass (v0.9)

Before producing output, perform one silent pass:
1. Read `git diff main...HEAD -- src/` (or full diff if main is not base branch).
2. Apply each criterion from `docs/SPEC.md` "Requirements (detail)" to the diff directly.
3. Note criteria with **zero** evidence in the diff (not just zero commits).
4. Carry findings into gap / weakness analysis.

---

## Output — Coverage-check mode (default)

1. **Coverage table**: per §N — commits / checklist items / status (✅ covered | ⚠ partial | ❌ missing)
2. **Gap analysis** (gaps only, no praise): per §N, 1-3 bullets of what evidence is missing.
3. **Critical risks**: 🔴 must fix before ship / 🟡 if time permits.
4. **Next actions** (time-boxed): "1 hour to close §N gap: ..." / "Additional 2 hours for §N: ..."

---

## Output — Score-simulation mode

1. **Score-simulation table**: per §N — max / sim score / 1-line rationale → `**Total** | | 100 | **NN/100**`
2. **Weakness analysis** (weaknesses only, no praise): per §N, 1-3 bullets of what's needed for max.
3. **Critical risks**: 🔴 must fix before ship / 🟡 if time permits.
4. **Next actions** (time-boxed): "1 hour for +N points: ..." / "Additional 2 hours for +M points: ..."

End with: *"This is a simulation, not the real evaluation. Results may vary depending on the evaluator."*
