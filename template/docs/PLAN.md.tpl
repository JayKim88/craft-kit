# PLAN — Project plan

> What we're building, for whom, how far, and by when.
> Holds our interpretation of and decisions about SPEC.md (the external spec).

---

## 1. Product definition

**One-line definition**: <!-- HINT: One-line summary of SPEC in our words. Example: "A time-based planner where students visually edit and save their weekly study schedule." -->

**Target user**: <!-- HINT: Who uses it? Reasonable inference if SPEC is silent. -->

**User value**:
<!-- HINT: 3-5 core benefits this product gives the user. -->
- ...
- ...
- ...

### Core user scenarios

<!-- HINT: Translate SPEC's "background scenario" or "usage flow" into 5-8 steps in our words.
     The reviewer reads this to verify we accurately understood the spec. -->

1. ...
2. ...
3. ...

---

## 2. Our planning interpretation (decisions outside SPEC)

SPEC.md is external input; what follows are decisions we made when interpreting it.

| SPEC ambiguity | Our decision | Rationale |
|---|---|---|
| <!-- HINT: ambiguous parts of SPEC (boundary cases, empty states, timezones, ...) --> | <!-- how we interpreted it --> | <!-- why --> |

→ These decisions feed [DESIGN.md](DESIGN.md) as design rationale and the [README.md](../README.md) "Requirements interpretation & assumptions" section as reviewer-facing copy.

---

## 3. Scope

### Required (must implement)

<!-- HINT: SPEC "Required implementation" verbatim + reasonable implicit requirements. -->

- ...
- ...

### Optional (bonus)

<!-- HINT: SPEC "Optional" verbatim if listed. Set priority by cost · naturalness.
     Default plan = "implement all OR explicit drop". No vague avoidance. -->

| Item | Cost | Naturalness (already-built infra) | Priority for keeping until the end |
|---|---|---|---|
| ... | ... | ... | ... |

**Principle**: implementing all is the **default plan**. The priority above only triggers in "the required scope is at risk" emergencies as a cut line.

### Out of scope (not in this assignment)

<!-- HINT: explicitly excluded by SPEC + things we explicitly drop. -->

- ...

### External dependencies / environment decisions (response to SPEC's "free choice" areas)

<!-- HINT: If SPEC offered free choice for "Mock API environment", "DB", "deployment", etc., document the decision + rationale + limitations.
     fs-planner case: "MSW v2 chosen — close to production / test reusability / in-memory persistence". Limitation: "Seeds reset on refresh".
     BE case: "PostgreSQL + Docker Compose — verifiable real transactions". Limitation: "No distributed transactions".
     Delete this section if not applicable. -->

**Selection**: ...

**Rationale**:
- ...
- ...

**Limitations (record in README constraints)**:
- ...

---

## 4. Deadline / schedule

| Item | Date |
|---|---|
| **Assignment deadline** | {{DEADLINE_DATE}} ({{DEADLINE_TIME}}) |
| **Today** (writing date) | {{TODAY}} |
| **Time remaining** | ~{{DEADLINE_DAYS}} days |

**Schedule plan (rough)**:

<!-- HINT: Daily milestones from D-N to D-0. Common pattern:
     D-N    : Doc alignment + toolchain check
     D-N+1  : Core infra (types, lib, mocks, providers)
     D-N+2  : Required screens / endpoints — first pass
     D-N+3  : Required — second pass + start bonus
     D-1    : Polish + manual smoke
     D-0    : README polish + repo public + submit
-->

- D-{{DEADLINE_DAYS}} ({{TODAY}}): ... ← **today**
- D-{{DAY_BEFORE_LAST}}: ...
- D-1: Polish + manual smoke
- D-0 ({{DEADLINE_DATE}}): README polish + repo public + submit

---

## 5. Rubric mapping

Mapping where each rubric score gets earned. (init dynamically generates rows from interview answers)

{{EVAL_MAPPING_TABLE}}

<!-- HINT: For each §N category in the table above, fill "where it's satisfied".
     Example (FE 5-day assignment):
     | §1 Requirements understanding (20) | SPEC = input / PLAN §2 interpretation / CHECKLIST edge cases |
     | §2 Design & code structure (25)    | DESIGN ADRs + actual code |
     | §3 Stability & exceptions (20)     | DESIGN error patterns / CHECKLIST stability / DoD gates |
     | §4 UI/UX (15)                      | DESIGN UX pattern + CHECKLIST readability |
     | §5 Documentation (10)              | SPEC + PLAN + DESIGN + PROCESS + CLAUDE + AI_USAGE + README |
     | §6 Git history (10)                | CLAUDE.md git policy + per-Phase commits + separate refactor/test commits |
-->

---

## 6. Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| <!-- HINT: stack incompatibility with new APIs, time pressure, dropping required scope to chase bonus, ... --> | Med | Med | ... |

---

## 7. What we must satisfy at submission (summary)

<!-- HINT: SPEC "Required deliverables" verbatim + rubric §5 (documentation) items. -->

- Repository (public, with full commit history)
- README.md — covers every section in SPEC's README template + rubric §{{DOC_CRITERION_INDEX}} items
- Every required implementation works (manual smoke passes)
- AI_USAGE.md finalized
- Honest "Unimplemented / constraints" section

→ The single source of truth for tracking is [CHECKLIST.md "4. Wrap-up"](CHECKLIST.md).
