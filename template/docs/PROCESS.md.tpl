# PROCESS — Implementation order

> Implement in the order of [SPEC.md](SPEC.md) "Implementation scope".
> Per-phase items + rubric mapping → matching numbered section in [CHECKLIST.md](CHECKLIST.md)
> Working rules (commit convention · DoD · prohibitions) → [CLAUDE.md](../CLAUDE.md)
> Every commit runs only after user approval

---

## Phase 0. Preparation (infrastructure)

<!-- HINT: User-invisible things needed for later phases.
     Examples (FE):
     - Type definitions (src/types/)
     - Domain logic + unit tests (src/lib/<domain>/)
     - Mock API handlers (src/mocks/)
     - State management setup (src/store/, src/hooks/)
     Examples (BE):
     - DB schema + migrations
     - Domain model + unit tests
     - Logging / error middleware
     - Environment vars / config
-->

- ...
- ...

→ **Dependency order**: `{{INFRA_DEPENDENCY_CHAIN}}`

<!-- HINT example: types → domain-lib → mocks → providers → store → hooks → UI -->

---

## Phase 1. {{REQUIRED_FEATURE_1_NAME}} (SPEC required #1)

<!-- HINT: SPEC's first required item. 5-10 sub-task bullets. -->

- ...
- ...

→ Component / module implementation order: `...`

---

## Phase 2. {{REQUIRED_FEATURE_2_NAME}} (SPEC required #2)

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
- Finalize AI_USAGE.md
- Set repository public + submit

---

## Work cycle (repeated each Phase)

```
Implement → DoD gates (lint / test / build / no-any / no-debug-log)
          → CHECKLIST item [x] + AI_USAGE update (when AI used)
          → User approval → commit
```

DoD details → [CLAUDE.md](../CLAUDE.md)

`/dod-check` runs all auto gates in one shot.
