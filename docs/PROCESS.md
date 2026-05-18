# PROCESS — Implementation order

> Implement in the order of [SPEC.md](SPEC.md) "Implementation scope".
> Per-phase items + rubric mapping → matching numbered section in [CHECKLIST.md](CHECKLIST.md)
> Working rules (commit convention · DoD · prohibitions) → [CLAUDE.md](../CLAUDE.md)
> Every commit runs only after user approval.

---

## Phase 0. Preparation (infrastructure)

<!-- HINT: User-invisible things needed for later phases.

   FE example:
   - Type definitions (src/types/)
   - Domain logic + unit tests (src/lib/<domain>/)
   - Mock API handlers (src/mocks/)
   - State management setup (src/store/, src/hooks/)

   BE example:
   - DB schema + migrations
   - Domain model + unit tests
   - Logging / error middleware
   - Environment vars / config

   ML example:
   - Data loader + train/val/test split
   - Pipeline scaffolding
   - Experiment tracking setup
-->

- ...
- ...

→ **Dependency order**: `<chain>` <!-- HINT: e.g. `types → domain-lib → mocks → providers → store → hooks → UI` -->

---

## Phase 1. _Required feature #1 name_ (SPEC required #1)

<!-- HINT: SPEC's first required item. 5-10 sub-task bullets. -->

- ...
- ...

→ Component / module implementation order: `...`

---

## Phase 2. _Required feature #2 name_ (SPEC required #2)

<!-- HINT: SPEC's second required item. -->

- ...

---

## Phase 3. Optional implementation (bonus)

<!-- HINT: SPEC "Optional" items. Priority basis is the table in PLAN.md §3.
     Be aggressive ("we plan to ship all 5"); dropping is the emergency cut line only. -->

1. ...
2. ...
3. ...

Enter only after Phase 0~2 are complete. The emergency cut-line priority is the safety-net table in [PLAN.md §3](PLAN.md).

---

## Phase 4. Wrap-up

- Manual smoke tests (the items in CHECKLIST.md "4. Wrap-up")
- Fill README "Unimplemented / constraints"
- Set repository public + submit

---

## Work cycle (repeated each Phase)

```
Implement → DoD gates (lint / test / build / no-type-escape / no-debug-log)
          → CHECKLIST item [x]
          → User approval → commit
```

DoD details → [CLAUDE.md](../CLAUDE.md). The AI agent runs the 7-gate procedure automatically when the user signals a commit is imminent (see CLAUDE.md "AI agent procedures § Procedure 1").
