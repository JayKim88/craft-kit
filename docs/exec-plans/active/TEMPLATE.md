# Exec Plan: [Feature name]

> Copy as `active/<YYYYMMDD>-<slug>.md` when starting a complex feature (3+ files or 2+ layers).
> Move to `completed/` when all steps are `[x]`.
>
> **TDD rule (complex features)**: domain logic steps follow Red → Green → Refactor order.
> Simple CRUD / UI wiring steps can skip TDD (direct implement).

---

**Goal**: <!-- one-line objective -->

**SPEC clause**: <!-- §N this satisfies. e.g. "§2 — required feature #1: login flow" -->

**Complexity signal**: <!-- why this needs an exec-plan. e.g. "4 layers: types/service/api/ui" -->

**TDD scope**: <!-- which steps use TDD. e.g. "Step 3 (domain logic) — Steps 4-5 skip TDD" -->

**Started**: <!-- YYYY-MM-DD -->

---

## Steps

<!-- TDD order for domain logic: Red commit → Green commit → optional Refactor commit.
     Simple steps (types, wiring, UI): direct implement, no TDD needed. -->

- [ ] 1. Define types / schema
        `chore(types): define <Feature>Input and <Feature>Result [§N]`

- [ ] 2. Write failing tests for domain logic  ← **TDD Red**
        `test(<scope>): add failing tests for <feature> [§N]`
        commit: `TDD_RED=1 git commit -m "test(...): ..."`

- [ ] 3. Implement domain logic (make tests pass)  ← **TDD Green**
        `feat(<scope>): implement <feature> domain logic [§N]`

- [ ] 4. Refactor if needed  ← **TDD Refactor** (skip if clean)
        `refactor(<scope>): clean up <feature> [§N]`

- [ ] 5. Wire API endpoint / UI component
        `feat(<scope>): wire <feature> endpoint/component [§N]`

- [ ] 6. Integration / smoke test
        manual verify or add e2e test if rubric requires

- [ ] 7. Update CHECKLIST.md `[x]` + AI_USAGE.md row
        include in final feat: commit or separate `docs:` commit

---

## Decision log

<!-- Append-only. Date + decision + rationale. -->

| Date | Decision | Rationale |
|---|---|---|
| <!-- YYYY-MM-DD --> | | |

---

## Blockers

- [ ] <!-- e.g. SPEC unclear on empty-state behavior — waiting for Phase A ambiguity resolution -->
