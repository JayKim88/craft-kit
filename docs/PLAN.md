# PLAN — Project plan

> What we're building, for whom, how far, and by when.
> Holds our interpretation of and decisions about [SPEC.md](SPEC.md) (the external spec).

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
     The reader uses this to verify we accurately understood the spec. -->

1. ...
2. ...
3. ...

---

## 2. Our planning interpretation (decisions outside SPEC)

[SPEC.md](SPEC.md) is external input; what follows are decisions we made when interpreting it.

<!-- HINT: This 5-column table is the Assumption-Map pattern. The AI agent's
     Procedure 6 (Phase A guided fill) surfaces ambiguities one at a time
     with A/B/C option tables and appends rows here after you pick. Trigger
     with "fill PLAN" / "Phase A 시작" / "PLAN 채우자". -->

| SPEC ambiguity | Our decision | Rationale | Confidence | Verified by |
|---|---|---|---|---|
| <!-- "<verbatim quote from SPEC>" --> | <!-- chosen option --> | <!-- user's reason --> | <!-- High / Med / Low --> | <!-- Inferred / Asked stakeholder / Cross-checked sample --> |

→ These decisions feed [DESIGN.md](DESIGN.md) as design rationale and the [README.md](../README.md) "Requirements interpretation & assumptions" section as external-facing copy. The **Verified by** column is the strongest documentation signal — `Asked stakeholder` > `Cross-checked sample` > `Inferred`. Distinguishing them honestly is itself a documentation quality signal.

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

### Out of scope (not in this project)

<!-- HINT: explicitly excluded by SPEC + things we explicitly drop. -->

- ...

### External dependencies / environment decisions (response to SPEC's "free choice" areas)

<!-- HINT: If SPEC offered free choice for "Mock API environment", "DB", "deployment", etc., document the decision + rationale + limitations.
     FE example: "MSW v2 chosen — close to production / test reusability / in-memory persistence". Limitation: "Seeds reset on refresh".
     BE example: "PostgreSQL + Docker Compose — verifiable real transactions". Limitation: "No distributed transactions".
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
| **Project deadline** | `<YYYY-MM-DD HH:MM>` |
| **Today** (writing date) | `<YYYY-MM-DD>` |
| **Time remaining** | ~`<N>` days |

**Schedule plan (rough)**:

<!-- HINT: Daily milestones from D-N to D-0. Common 5-day pattern:
     D-5: Doc alignment + toolchain check
     D-4: Core infra (types, lib, mocks, providers)
     D-3: Required screens / endpoints — first pass
     D-2: Required — second pass + start bonus
     D-1: Polish + manual smoke
     D-0: README polish + ship

     Adjust to your actual remaining days.
-->

- D-N (`<today>`): ... ← **today**
- D-N+1: ...
- D-1: Polish + manual smoke
- D-0 (`<deadline>`): README polish + ship

---

## 5. Requirements mapping

Mapping where each criterion is satisfied.

<!-- HINT: For each §N category in [SPEC.md "Requirements (detail)"](SPEC.md), fill "where it's satisfied".
     If SPEC defines scoring: include point weight in the header (e.g. "§1 Requirements understanding (20 pts)").
     If no scoring defined: omit points — focus on which files/commits cover this criterion.

     Example shape:
     | §1 Requirements understanding | PLAN §2 interpretation / CHECKLIST edge cases |
     | §2 Design & code structure    | DESIGN ADRs + actual code |
     | §3 Stability & exceptions     | DESIGN error patterns / CHECKLIST stability / DoD gates |
     | §4 UI/UX                      | DESIGN UX pattern + CHECKLIST readability |
     | §5 Documentation              | SPEC + PLAN + DESIGN + PROCESS + CLAUDE + README |
     | §6 Git history                | CLAUDE.md git policy + per-Phase commits + separate refactor/test commits |
-->

| Criterion | Where it is satisfied |
|---|---|
| §1 ... | _TO FILL_ |
| §2 ... | _TO FILL_ |
| §3 ... | _TO FILL_ |
| §4 ... | _TO FILL_ |
| §5 ... | _TO FILL_ |
| §6 ... | _TO FILL_ |

---

## 6. Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| <!-- HINT: stack incompatibility with new APIs, time pressure, dropping required scope to chase bonus, ... --> | Med | Med | ... |

---

## 7. Ship checklist (summary)

<!-- HINT: SPEC "Required deliverables" verbatim + documentation criteria. -->

- Repository (accessible, with full commit history)
- README.md — covers every section in SPEC's README template + documentation criteria
- Every required implementation works (manual smoke passes)
- Honest "Unimplemented / constraints" section

→ The single source of truth for tracking is [CHECKLIST.md "4. Wrap-up"](CHECKLIST.md).
