# Workflow Guide

The workflow used inside an assignment folder booted with `takehome-kit` — focused on **principles and philosophy**.

> The **timeline walkthrough** (D-5 boot → D-0 submission, command-by-command) lives in [walkthrough.md](walkthrough.md). This document covers the principles repeated in each cycle (Phase units, commit conventions, AI_USAGE practice, FAQ).

---

## Overall flow

```
D-N (N days before deadline)               Output
─────────────────────────────────────────────────────────
D-N    : Fill SPEC.md                      SPEC.md (immutable)
D-N    : Extract criteria → CHECKLIST §N   CHECKLIST.md skeleton
D-N+0~1: PLAN.md (scope, timeline, risks)  PLAN.md
D-N+1~2: DESIGN.md (Decision Records)      DESIGN.md
D-N+2  : PROCESS.md (Phase dependencies)   PROCESS.md
D-N+2~ : Implement → 8-gate DoD per commit Code + commits + AI_USAGE.md updates
D-1    : Polish (manual smoke, a11y)       All gates PASS
D-0    : Synthesize README · submit        Final README.md
```

---

## Per-Phase guide

### Phase A: Spec alignment (D-N)

1. Paste the company spec into the `<!-- SPEC PASTE START -->` block of SPEC.md
2. If the rubric is explicit, organize into §1, §2, ... sections with point allocations
3. **If the spec has ambiguities, capture them in PLAN.md "Our interpretation"** (never edit SPEC)
4. Run `/dod-check` to see the initial state (most gates will FAIL — that's expected)

### Phase B: Planning & design (D-N+0~2)

1. PLAN.md
   - Our definition of the product/feature (1 paragraph)
   - Spec ambiguities → how we interpreted them + interview/email questions
   - Scope: N required + M optional (bonus)
   - Timeline (D-N → D-0)
   - Risk matrix
   - Rubric mapping (§N → which features/documents contribute)

2. DESIGN.md
   - Use the "Decision Records" table format: `option | criterion | decision | rationale | trade-off`
   - 5–10 core decisions (e.g. state-management library, test strategy, error pattern)
   - **Document why you didn't pick the rejected options** (this is where reviewers give the most credit)

3. PROCESS.md
   - Decompose into Phase 0~N with a dependency graph
   - Example: `types → core lib → integration → UI → polish`
   - Mark which work can run in parallel vs sequentially

### Phase C: Implementation (D-N+2 → D-1)

For every feature, follow this cycle:

```
1. Implement (code)
2. Auto gates
   ├─ npm run lint
   ├─ npm test
   ├─ npm run build
   ├─ grep ": any" src/  → 0?
   └─ grep "console.log" src/  → 0?
3. Manual gates
   ├─ Mark [x] on the corresponding §N item in CHECKLIST.md?
   ├─ Add a row to AI_USAGE.md for this work?
   └─ Commit message: <type>(<scope>): <subject> [§N]
4. User approval (Claude must NOT auto-execute git commit; the human approves explicitly)
5. git commit
```

`/dod-check` runs all 5 auto gates + the manual sync verification in one shot.

### Phase D: Polish (D-1)

- Write and run 5–10 manual smoke scenarios
- Accessibility check (FE)
- Performance check (when needed)
- Final README.md polish (synthesized from PLAN/DESIGN)

### Phase E: Submission (D-0)

1. Run `git log --oneline | head -30` (is the history clean?)
2. Use the `rubric-reviewer` subagent to simulate evaluation
3. Review the weakness report → patch if time allows
4. Submit

---

## Commit convention

```
<type>(<scope>): <subject> [§N]

[body — optional]

[footer — optional]
```

**type**: `feat | fix | refactor | test | chore | docs | style | perf`

**scope**: defined per project (e.g. `time | grid | modal | save | summary | a11y | mocks`)

**subject**: imperative, English, ≤ 50 characters

**`[§N]`**: rubric criterion number. Multiple → `[§2,§3]`. Infrastructure-only commits use `[§-]`.

**Examples**:
```
feat(grid): render saved blocks with conflict highlighting [§2,§4]
test(time): cover boundary, overlap, grid math [§3]
docs(readme): add test architecture table [§5]
fix(save): Safari disabled tooltip; mark manual smoke complete [§4]
chore(deps): upgrade vitest to v4 [§-]
```

---

## Operating AI_USAGE.md

Add one row per commit. Table format:

| # | Time | What AI did | What the human decided / fixed | Note |
|---|------|-------------|-------------------------------|------|

**Important**: Don't stop at "AI wrote the code". Spell out **what the human decided or corrected**. The reviewer wants to see "someone who knows how to use AI as a tool", not "someone who outsources to AI".

Good example:
> AI drafted the conflict-detection algorithm. Human reviewed boundary cases (`a.start < b.end` vs `≤`) and switched to strict inequality (touching is not overlap).

Bad example:
> AI implemented conflict detection.

---

## FAQ

**Q. Do I really need user approval on every commit?**
A. Yes. Validated on fs-planner. Once AI runs unsupervised, 5–10 changes get bundled into a single commit and the git history is ruined. If "Git history" is part of the rubric, this is a direct hit.

**Q. Building a 200-item CHECKLIST.md feels heavy.**
A. Start with 5–10 items per §N. Add new items as you discover them. You don't need 200 up front.

**Q. Isn't logging AI_USAGE.md in detail a waste of time?**
A. One row = one line. 30 seconds. 30–50 rows is enough total (fs-planner had 32).
