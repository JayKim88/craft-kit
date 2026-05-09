# {{COMPANY}} {{ROLE}} — {{PRODUCT}} / AI Collaboration Context

> Ground truth for collaborating with AI (Claude).
> This document holds **context** and **rules** (coding · commit · DoD · prohibitions) only.
> Everything else is routed to a single-responsibility document.

---

## Document routing (Single Source of Truth)

When you need information mid-work, here's where to look:

| What you're looking for | Where it lives |
|---|---|
| External spec (immutable contract) | [SPEC.md](docs/SPEC.md) |
| **Rubric (check while working)** | **[SPEC.md "## Rubric (detail)"](docs/SPEC.md) + the inline `[§N]` markers in [CHECKLIST.md](docs/CHECKLIST.md)** |
| Our planning (product definition · scope · schedule · bonus priority · rubric mapping) | [PLAN.md](docs/PLAN.md) |
| Design decisions (architecture · library choices · trade-offs) | [DESIGN.md](docs/DESIGN.md) |
| Workflow (Phases, dependency graph, commit cycle) | [PROCESS.md](docs/PROCESS.md) |
| Task list / progress | [CHECKLIST.md](docs/CHECKLIST.md) |
| AI usage rules · coding rules · DoD · prohibitions | **This document** |
| AI usage history (for submission) | [AI_USAGE.md](docs/AI_USAGE.md) |
| Reviewer-facing output | [README.md](README.md) |

Rule: **A single piece of information lives in a single document.** If you find a duplicate, consolidate into the SSOT and replace the others with links.

---

## Assignment overview (context)

- **Deadline**: {{DEADLINE_DATE}} ({{DEADLINE_TIME}})
- **Type**: {{TASK_TYPE}} — {{PRODUCT}}
- **Core challenge**: {{ONELINE_CHALLENGE}}

Detailed planning · scope · schedule → [PLAN.md](docs/PLAN.md)

---

## Tech stack

<!-- HINT: Fill after tech is decided. If still undecided, compare in the DESIGN.md "Tech selection rationale" section first.
     Example table (by role):
     | Tech | Version | Purpose |
     |---|---|---|
     | <Runtime> | <X.Y> | runtime |
     | <Framework> | <X.Y> | framework |
     | <Language> | strict | type safety |
-->

| Tech | Version | Purpose |
|------|---------|---------|
| {{STACK_HINT}} |  |  |

Tech-selection rationale → [DESIGN.md](docs/DESIGN.md) "Tech selection rationale"

---

## Environment notes (optional)

<!-- HINT: If your framework/language differs from typical training data, note it here.
     Examples: "Next 16 async dynamic API", "Python 3.13 deprecation", "Java 21 record patterns".
     Delete this section if nothing applies. -->

---

## Coding rules

<!-- HINT: Adjust per language/framework. The defaults below assume TypeScript. -->

- No type escapes (no unintended `any` / `unknown` / `as any`)
- No debug code (`console.log` / `print()` / `dbg!()` etc. — intentional logging via error/warn is fine)
- **Isolate domain logic in domain modules** — no direct computation in components / endpoints (e.g. time math in `lib/time.ts`, authorization in `lib/auth.ts`)
- State separation — never mix server state with edit/UI state (keep flow unidirectional)
- **For each item you implement, check the `[§N]` marker in [CHECKLIST.md](docs/CHECKLIST.md) → aim to satisfy the "high proficiency" bar in [SPEC.md "Rubric (detail)" §N](docs/SPEC.md).**

State-flow detail → [DESIGN.md](docs/DESIGN.md)

---

## Commit convention

Format: `<type>(<scope>): <subject> [§N]`

- **type**: `feat | fix | refactor | test | chore | docs | style | perf`
- **scope**: project-defined (e.g. `types | core | api | ui | nav | a11y | mocks` — `<!-- HINT: lock 5-10 of these at project start -->`)
- **subject**: English, imperative, ≤ 50 characters
- **`[§N]`**: rubric criterion number. Multiple → `[§2,§3]`. Infrastructure/tooling work → `[§-]`.

Examples:
- `feat(api): add user authentication endpoint [§2,§3]`
- `test(core): cover boundary cases for time conflict [§3]`
- `refactor(ui): extract validation hook [§2]`
- `chore(deps): upgrade test framework [§-]`

Commit ordering · dependencies → [PROCESS.md](docs/PROCESS.md) + [CHECKLIST.md](docs/CHECKLIST.md)

---

## Definition of Done (per feature commit)

| # | Gate | Verification command |
|---|---|---|
| 1 | Lint clean | `<!-- HINT: npm run lint / ruff check . / cargo clippy etc. -->` |
| 2 | Tests green | `<!-- HINT: npm test / pytest / cargo test etc. -->` |
| 3 | Build OK | `<!-- HINT: npm run build / mvn package / cargo build etc. -->` |
| 4 | No type-escape | `grep -rn ': any' src/` → 0 (TypeScript) / per-language equivalent |
| 5 | No debug logs | `grep -rn 'console\.log\|print(\|dbg!' src/` → 0 |
| 6 | CHECKLIST item updated to [x] | — |
| 7 | AI_USAGE.md row added (when AI used) | — |
| 8 | Commit message follows convention + carries `[§N]` | — |

1-5 are automated quality gates; 6-8 are manual rubric-alignment gates.

`/dod-check` runs all 5 auto gates + the sync verification in one shot.

---

## Git / Work trail (rubric §{{GIT_CRITERION_INDEX}})

When git history is itself a rubric criterion, follow these:

- **Semantic-unit commits**: one commit = one semantic unit. Align with [PROCESS.md](docs/PROCESS.md) phases.
- **No bulk dump**: never lump everything into a single final commit (explicit deduction).
- **Separate refactor / test commits (bonus)**: keeping `refactor:` / `test:` commits apart from feature commits earns extra credit.
- **User approval required**: every commit runs only after explicit user approval. AI must NOT auto-execute `git commit`.

  **A commit-approval request always includes:**
  1. List of files to stage + summary of key changes
  2. Proposed commit message (full body, including `[§N]`)
  3. DoD gate results (lint / test / build / no any / no debug-log)
  4. **Doc-sync check** — verify before every commit:
     - [docs/CHECKLIST.md](docs/CHECKLIST.md): any items completed by this commit still marked [ ]?
     - [docs/AI_USAGE.md](docs/AI_USAGE.md): is an AI-usage row missing for this work?
     - [docs/DESIGN.md](docs/DESIGN.md) / [docs/PLAN.md](docs/PLAN.md) / [README.md](README.md): any unreflected design / scope / interface changes?
     - Offer disposition options when needed: (a) include in this commit / (b) separate docs commit / (c) batch sync later

---

## Absolute prohibitions

- **Never run a commit without user approval** (see §Git above)
- Never modify SPEC.md / AGENTS.md (external contract / environment doc)
- Never mix edit state with server state (unidirectional flow)
- Never inline domain logic in components / endpoints (isolation rule)

<!-- HINT: Add domain-specific prohibitions for your project. Examples:
- Never directly mutate the TanStack Query cache
- Never start a DB transaction outside the service layer
- Never bypass authorization without an authenticated user context
-->
