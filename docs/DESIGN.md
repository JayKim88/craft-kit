# Design Decision Document

> Architecture Decision Records (ADRs). The basis for the README "Design decisions & rationale" section.
> Format: option comparison → decision → rationale → trade-off.

---

## 0. Core beliefs

> Permanent operating principles. Apply to every ADR below.
> Violating one requires explicit justification in the ADR's **Trade-off** field.
> Source: OpenAI harness engineering discipline — adapted for short-scope engineering projects.

<!-- HINT: These defaults are intentionally generic. Override any line that conflicts with your
     project's specific constraints (e.g. "framework is mandated by SPEC" overrides belief 1). -->

1. **Agent legibility over human elegance** — prefer technologies with stable APIs, wide training-set
   coverage, and predictable behavior. The agent's ability to reason about a dependency matters more
   than stylistic preference.

2. **Boring is a virtue** — when a library's behavior is opaque or hard to model in-context, reimplementing
   a focused subset is often cheaper than working around the library. Justify any non-trivial
   dependency in §4 (Tech-selection rationale).

3. **In-repo over out-of-repo** — every decision, constraint, and architectural rationale must live in
   this repository. Knowledge in chat logs, Google Docs, or implicit team consensus is invisible to
   the agent and to reviewers.

4. **Enforce invariants mechanically** — if a rule is important enough to state, it is important enough
   to lint or test. Prose rules rot; code rules hold.

5. **Unidirectional data flow** — state has one owner. Derived / edit state never mixes with
   source-of-truth state. Bidirectional bindings are disallowed unless SPEC explicitly requires them.

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
> - **Spell out "why we did NOT pick the rejected options"** — this is where readers gain the most trust in your decisions.
> - Recommend mapping one ADR to each sub-checkpoint of the Design criteria category.
> - **SPEC origin is mandatory.** Every ADR must cite the SPEC clause it derives from. If no direct SPEC clause exists, write `Inferred — no direct SPEC clause` and explain why in Rationale.

---

### ADR-001: _Decision title 1: one-line summary of result_

**SPEC origin**: <!-- HINT: cite the SPEC clause this decision derives from.
     Format: `docs/SPEC.md §<section> L<line> — "<verbatim quote>"`
     Example: `docs/SPEC.md §"Implementation scope" L34 — "the schedule must persist across page reloads"`
     If the decision is not directly tied to a SPEC clause, write `Inferred — no direct SPEC clause` and explain why in Rationale below. -->

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

**SPEC origin**: <!-- cite the SPEC clause; format as in ADR-001 -->

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

<!-- HINT: If SPEC says "library choice is free, justify in README", this section is heavyweight in the Design criteria.
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

## 7. UI/UX references (FE project only)

<!-- HINT: Delete this section for BE/ML projects.
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

> The external-facing single source of truth lives in [README.md](../README.md) "Unimplemented / constraints". Not duplicated here.
