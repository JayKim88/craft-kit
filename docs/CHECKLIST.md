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
- [ ] README.md skeleton (SPEC template sections + Documentation rubric items)
- [ ] Free-library decisions (DESIGN.md §4)
- [ ] UI/UX reference decisions (FE only, DESIGN.md §7)

## Phase B — Tech stack & architecture lock

<!-- HINT: Before writing the first line of code, verify the toolchain works. -->

- [ ] Lock runtime / language version (`.nvmrc` / `.python-version` / Dockerfile etc.)
- [ ] `<lint command>` clean
- [ ] `<test command>` passing
- [ ] `<build command>` passing
- [ ] Type checker passes in strict mode (when applicable)
- [ ] `.githooks/pre-commit` runs on a docs-only commit and passes (stack=none path)
- [ ] `.githooks/pre-commit` runs on first `feat:` commit with stack detected and gates 1-3 pass
- [ ] `bash scripts/cadence.sh` returns sensible output (deadline parses correctly)
- [ ] `.claude/skills/*` skills are discoverable (try any trigger phrase in Claude Code)

---

# Phase C — Implementation (PROCESS order)

## 0. Preparation (infrastructure)

<!-- HINT: Decompose PROCESS.md Phase 0 items into work units. Tag each with [§N]. -->

### Environment

- [ ] `<runtime>` setup
- [ ] `<framework>` setup
- [ ] Folder structure

### Additional library installs (free-choice areas, DESIGN.md §4)

- [ ] ...

### Type / model definitions

- [ ] ...

### Domain logic + unit tests `[§<Design> domain logic isolation]`

- [ ] ...
- [ ] ...

### Domain unit tests `[§<Requirements> explicit boundary cases]`

- [ ] Normal cases
- [ ] Boundary cases
- [ ] ...

### Mock API / external-dependency doubles

- [ ] ...

### State-management setup (FE) / DB · transactions setup (BE)

- [ ] ...

---

## 1. _Required feature #1 name_ (SPEC required #1)

<!-- HINT: Sub-tasks + [§N] mapping. 5-15 items per feature is typical. -->

- [ ] ... `[§N]`
- [ ] ... `[§N]`

### Edge cases `[§<Requirements> edge-case awareness]`

- [ ] Long data / large input
- [ ] Empty state
- [ ] Boundary values (midnight, $0, max, ...)
- [ ] Concurrency (when applicable)
- [ ] Performance (re-render / query at N+ items)

---

## 2. _Required feature #2 name_ (SPEC required #2)

- [ ] ...

---

## 3. Optional implementation (bonus)

> Normal completion = every item below [x]. Allow partial only if the emergency cut line activates (required scope at risk).

- [ ] _Bonus item 1_
- [ ] _Bonus item 2_
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
- [ ] README "Design decisions & rationale" — covers every Documentation rubric item
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
