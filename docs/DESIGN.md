# Design Decision Document

> Architecture Decision Records (ADRs). The basis for the README "Design decisions & rationale" section.
> Format: option comparison → decision → rationale → trade-off.

---

## 1. Architecture overview

<!-- HINT: One or two diagrams (ASCII OK) covering the entire system. Examples:

   FE:
   ```
   ┌─────────────────────────────────────┐
   │  Server state (TanStack Query/API)   │
   └──────────────┬──────────────────────┘
                  │ initial copy on mount
   ┌──────────────▼──────────────────────┐
   │  Edit state (Zustand / Redux / etc.)  │
   └──────────────┬──────────────────────┘
                  │ sync on save success
   ┌──────────────▼──────────────────────┐
   │  UI state (local)                    │
   └─────────────────────────────────────┘
   ```

   BE:
   ```
   [Client] → [API Gateway] → [Service Layer] → [DB]
                                   ↓
                             [Background Job]
   ```
-->

_TO FILL — replace with your system diagram_

---

## 2. Key flow diagram

<!-- HINT: 1-2 most-important user flows as a sequence diagram (or step list).
     E.g. "save flow", "order processing flow", "permission check flow". -->

_TO FILL_

---

## 3. Decision Records (ADR)

For each key decision, follow the 5-step format: **context → options → decision → rationale → trade-off**.

> **Operating guide**:
> - Write 5-10 ADRs. **Skip the trivial.** Only "things that genuinely could have gone differently".
> - Copy the ADR-001 format below for ADR-002, ADR-003, ...
> - Title format: "Subject + result" — e.g. `ADR-002: Time-conflict boundary policy (touching is not overlap)`
> - **Spell out "why we did NOT pick the rejected options"** — this is where reviewers award the most credit.
> - Recommend mapping one ADR to each sub-checkpoint of the Design rubric category.

---

### ADR-001: _Decision title 1: one-line summary of result_

**Context**: <!-- 1-2 sentences on the problem to solve. Which constraint forced this decision? -->

**Options**:

| Option | Pros | Cons |
|---|---|---|
| A. ... | ... | ... |
| B. ... | ... | ... |
| C. ... | ... | ... |

**Decision**: <!-- Which option we picked. One line. -->

**Rationale**: <!-- Why this option beats the rest, expressed in measurable criteria (perf, complexity, blast radius, ...). -->

**Trade-off (downside accepted)**: <!-- Explicit downsides of this choice. Demonstrates "I am aware of this drawback". -->

---

### ADR-002: _Decision title 2_

**Context**: ...

**Options**:

| Option | Pros | Cons |
|---|---|---|
| A. ... | ... | ... |
| B. ... | ... | ... |

**Decision**: ...

**Rationale**: ...

**Trade-off**: ...

---

<!-- Copy ADR-003, ADR-004, ... ADR-N below using the format above. 5-10 recommended. -->

---

## 4. Tech-selection rationale

### Core infrastructure

| Tech | Reason |
|------|--------|
| <!-- HINT: language / framework / key libraries. Follow SPEC's "recommended" but justify free-choice areas explicitly --> | ... |

### External library choices (free-choice areas)

<!-- HINT: If SPEC says "library choice is free, justify in README", this section is heavyweight in the Design rubric.
     For each area, compare "build vs library", and only adopt a library where building is riskier. -->

| Area | Selection | Rationale | Why we did not build it ourselves |
|---|---|---|---|
| ... | ... | ... | ... |

### Intentionally NOT added

<!-- HINT: List libraries / tools we deliberately did not add. This shows the reviewer "conscious omission". -->

| Area | Selection | Reason |
|---|---|---|
| ... | ... | ... |

---

## 5. Domain-logic isolation principle

<!-- HINT: Critical when SPEC explicitly checks "is X logic isolated?".
     Examples: time math (`lib/time.ts`), permissions (`lib/auth.ts`), settlement (`lib/billing.ts`), algorithms (`lib/<domain>.ts`) -->

**Isolated module**: `<path/to/module>` <!-- e.g. src/lib/time.ts -->

**Rules**:
- No direct computation in components / endpoints
- Pure functions only (no external state / time / I/O dependencies)
- Unit tests cover every boundary case

---

## 6. Error-handling strategy

<!-- HINT: If SPEC defines error codes, use a table. State the UI / response flow + the invariant principle. -->

| Error case | Situation | Handling | What user / caller receives | Retryable? |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

**Principle**: <!-- HINT: Spell out the invariant, like "Under any failure mode, X is protected". E.g. "Under any failure mode, editBlocks is never mutated." -->

---

## 7. UI/UX references (FE assignment only)

<!-- HINT: Delete this section for BE/ML assignments.
     For FE: explicitly declare reference services per area — sends a "deliberate UX choice" signal to the reviewer.
     Principle: visual inspiration only; implementation follows SPEC. -->

| Area | Reference service | What we take from it |
|---|---|---|
| ... | ... | ... |

---

## 8. Test strategy

<!-- HINT: Organize as 3 tiers. Per-tier count and responsibility:
     Tier 1: pure functions (domain logic, algorithms)
     Tier 2: components / endpoints
     Tier 3: integration (E2E or API scenarios)
-->

| Tier | Target | Count (estimate) | Tooling |
|---|---|---|---|
| 1. Pure functions | `<path>` | ~30 | ... |
| 2. Components / endpoints | ... | ~10 | ... |
| 3. Integration | ... | ~5 | ... |

**Regression prevention**: When a bug is found, freeze it as a regression test. Mark the describe block with `(regression: <short note>)`.

---

## 9. Unimplemented / constraints

> The reviewer-facing single source of truth lives in [README.md](../README.md) "Unimplemented / constraints". Not duplicated here.
