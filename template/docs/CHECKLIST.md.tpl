# Implementation Checklist

> Progress tracking + rubric verification.
> Item order aligns with the Phases of [PROCESS.md](PROCESS.md).
> Each item's `[§N]` marker references the rubric category number in [SPEC.md "Rubric (detail)"](SPEC.md).

---

## Phase A — Document alignment

<!-- HINT: Verify every doc is aligned before starting work. -->

- [ ] CLAUDE.md (DoD + commit convention + rubric reference)
- [ ] CHECKLIST.md (rubric §N inline mapping — this document)
- [ ] PROCESS.md (implementation order)
- [ ] PLAN.md (scope · schedule · risk matrix · rubric mapping)
- [ ] DESIGN.md (5-10 Decision Records)
- [ ] SPEC.md (original company paste, rubric §1~§N)
- [ ] README.md skeleton (SPEC template sections + rubric §{{DOC_CRITERION_INDEX}} items)
- [ ] Free-library decisions (DESIGN.md §4)
- [ ] UI/UX reference decisions (FE only, DESIGN.md §7)

## Phase B — Tech stack & architecture lock

<!-- HINT: Before writing the first line of code, verify the toolchain works. -->

- [ ] Lock runtime / language version (.nvmrc / .python-version / Dockerfile etc.)
- [ ] `<lint command>` clean
- [ ] `<test command>` passing
- [ ] `<build command>` passing
- [ ] Type checker passes in strict mode (when applicable)

---

# Phase C — Implementation (PROCESS order)

## 0. Preparation (infrastructure)

<!-- HINT: Decompose PROCESS.md Phase 0 items into work units. Tag each with [§N]. -->

### Environment

- [ ] {{TECH_RUNTIME}} setup
- [ ] {{TECH_FRAMEWORK}} setup
- [ ] Folder structure

### Additional library installs (free-choice areas, DESIGN.md §4)

- [ ] ...

### Type / model definitions

- [ ] ...

### Domain logic + unit tests `[§{{DESIGN_CRITERION_INDEX}} domain logic isolation]`

- [ ] ...
- [ ] ...

### Domain unit tests `[§{{REQ_CRITERION_INDEX}} explicit boundary cases]`

- [ ] Normal cases
- [ ] Boundary cases
- [ ] ...

### Mock API / external-dependency doubles

- [ ] ...

### State-management setup (FE) / DB · transactions setup (BE)

- [ ] ...

---

## 1. {{REQUIRED_FEATURE_1_NAME}} (SPEC required #1)

<!-- HINT: Sub-tasks + [§N] mapping. Per fs-planner pattern, 5-15 items. -->

- [ ] ... `[§N]`
- [ ] ... `[§N]`

### Edge cases `[§{{REQ_CRITERION_INDEX}} edge-case awareness]`

- [ ] Long data / large input
- [ ] Empty state
- [ ] Boundary values (midnight, $0, max, ...)
- [ ] Concurrency (when applicable)
- [ ] Performance (re-render / query at N+ items)

---

## 2. {{REQUIRED_FEATURE_2_NAME}} (SPEC required #2)

- [ ] ...

---

## 3. Optional implementation (bonus)

> Normal completion = every item below [x]. Allow partial only if the emergency cut line activates (required scope at risk).

- [ ] {{BONUS_FEATURE_1}}
- [ ] {{BONUS_FEATURE_2}}
- [ ] ...

---

## 4. Wrap-up

### Manual smoke tests

- [ ] Fresh install + dev server boots
- [ ] Initial seed renders / responds correctly
- [ ] Core flow 1: <!-- HINT: most-important user scenario -->
- [ ] Core flow 2: ...
- [ ] Error case 1: ...
- [ ] Error case 2: ...
- [ ] Empty-state handling
- [ ] Boundary values (time / number / string length)
- [ ] Performance at 100+ items
- [ ] All tests PASS
- [ ] Lint clean
- [ ] Build PASS

### Finalize docs

- [ ] README "Project overview / Tech stack / How to run / Structure"
- [ ] README "Requirements interpretation & assumptions"
- [ ] README "Design decisions & rationale" — covers every rubric §{{DOC_CRITERION_INDEX}} item
- [ ] README "Unimplemented / constraints"
- [ ] README "AI usage scope" — links to AI_USAGE.md
- [ ] Finalize AI_USAGE.md

### Submission

- [ ] Repository public
- [ ] Public URL submitted
- [ ] (Optional) `rubric-reviewer` subagent simulation

---

## 📌 Extra TODO (custom, optional)

> Improvements found mid-work. Pursue after required + bonus complete, time permitting.
>
> **Priority** legend: 🔴 high (direct evaluation impact) / 🟡 medium / 🟢 low (polish)
> **Status** legend: [ ] pending / [-] in progress / [x] done / [~] dropped

| Priority | Status | Item | Area | Source |
|---------|--------|------|------|--------|
| 🟡 | [ ] | ... | ... | ... |
