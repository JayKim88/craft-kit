# {{PRODUCT}}

> Submission for the {{COMPANY}} {{ROLE}} recruitment assignment.

<!-- HINT [One-line summary, write in Phase A]: user value + core challenge in one line.
     Example: "An SPA where students visually edit and save their weekly study schedule. Core: time-conflict detection + edit/save state separation." -->

Core challenge: **{{ONELINE_CHALLENGE}}**

---

## Project overview

<!-- HINT [Phase A]: Summarize SPEC's key requirements in our own words (1-2 paragraphs) + state explicitly "where we focused".
     This is what reviewers read first — the README's first impression directly affects rubric §{{DOC_CRITERION_INDEX}}.
     (Synthesized from PLAN.md §1 "Product definition" and §2 "Our planning interpretation") -->

_TO FILL — complete at end of Phase A._

---

## Tech stack & rationale

### Core infrastructure

<!-- HINT [Fill after Phase B]: language, framework, key libraries. One-line rationale per item. Reference STACK_HINT="{{STACK_HINT}}" from the interview. -->

| Tech | Version | Reason |
|---|---|---|
| ... | ... | ... |

### Free-choice areas — most-validated tool per area

<!-- HINT: If SPEC says "library choice is free (justify in README)", this section is at the heart of the rubric.
     For each area, state "why this and not hand-rolled". -->

| Area | Selection | Reason |
|---|---|---|
| ... | ... | ... |

### Intentionally NOT added

<!-- HINT: Libraries you deliberately did not add. A "conscious omission" signal. -->

| Area | Selection | Reason |
|---|---|---|
| ... | ... | ... |

---

## How to run

<!-- HINT: SPEC's required "How to run" section. Be very concrete to guarantee the reviewer can run it. -->

### Prerequisites

- {{TECH_RUNTIME}} {{RUNTIME_VERSION}}
- (Other: <!-- HINT: DB / services etc. -->)

### Install & run

```bash
# 1. Install dependencies
{{INSTALL_COMMAND}}

# 2. Start dev server
{{DEV_COMMAND}}

# 3. Build (optional)
{{BUILD_COMMAND}}
```

### Test

```bash
{{TEST_COMMAND}}
```

<!-- HINT [After Phase B]: If the commands above were left blank in init, fill them in directly.
     Update the table below at end of Phase 4:
     | Tier | Target | Count |
     |---|---|---|
     | 1. Pure functions | lib/<domain>.ts | N |
     | 2. Components / endpoints | ... | N |
     | 3. Integration | ... | N |
-->


<!-- HINT: Test count + classification, at-a-glance for the reviewer.
     Example:
     | Tier | Target | Count |
     |---|---|---|
     | 1. Pure functions | lib/time.ts | 69 |
     | 2. Components | components/* | 11 |
     | 3. Integration | integration | 2 |
     | **Total** | | **82** |
-->

### Mock-API setup (FE assignment only)

<!-- HINT [FE only, Phase B-C]: Delete this section for BE assignments.
     FE: state how you mocked (MSW / json-server / static JSON) + operational considerations (e.g. SW detach fallback). -->

_TO FILL_

### Dev-scenario URL flags (optional)

<!-- HINT: Provide URL flags so reviewers can reproduce error/edge cases easily.
     Examples:
     - `?_seed=empty` — empty week seed
     - `?_seed=stress` — 100+ blocks stress test
     - `?_simulate=TIME_CONFLICT` — trigger conflict response
     - `?_slow=2000` — 2-second response delay
-->

---

## Project structure

<!-- HINT: Folder tree + one-line responsibility per folder.
```
src/
├── app/         # ...
├── components/  # ...
├── hooks/       # ...
├── lib/         # Domain logic (isolated modules)
├── store/       # ...
└── types/       # ...
```
Or BE: `src/{controllers,services,repositories,domain,middleware}` etc.
-->

```
<!-- HINT [Phase 0-1]: tree of src/ (or equivalent), one-line responsibility per folder.
src/
├── ...
└── ...
-->
_TO FILL_
```

| Folder/file | Responsibility |
|---|---|
| ... | ... |

---

## Requirements interpretation & assumptions

<!-- HINT [Phase A]: Move PLAN.md §2 "Our planning interpretation" table into a reviewer-friendly form here.
     What was ambiguous in SPEC + our decision + rationale. -->

_TO FILL — extract from PLAN.md §2 table_

### Optional implementations (bonus)

<!-- HINT: Which bonus items did we ship, which did we drop, with what rationale. -->

_TO FILL_

---

## Design decisions & rationale

<!-- HINT [Phase 4 wrap-up, most important]: SPEC's README "Design decisions" section is at the heart of rubric §{{DOC_CRITERION_INDEX}}.
     Extract 5-8 reviewer-friendly ADRs from DESIGN.md. Cover every sub-item under SPEC's §{{DOC_CRITERION_INDEX}}.

     Below is the format for one ADR. In your assignment, scale to 5-8.
-->

### 1. <!-- Decision title 1 -->

_TO FILL — context → options → decision → rationale → trade-offs_

### 2. <!-- Decision title 2 -->

_TO FILL_

<!-- 3-8 to add -->

---

## Unimplemented / constraints

<!-- HINT [Phase 4]: Be honest. Rubric §{{DOC_CRITERION_INDEX}} explicitly looks for "if anything is missing, state the reason and an alternative."
     Don't hide. Format: "X was not implemented due to time, alternative is Y." -->

- _TO FILL 1_
- _TO FILL 2_

---

## AI usage scope

<!-- HINT: Summary + link to AI_USAGE.md.
     "AI usage itself is not penalized. We evaluate how much you made the result your own after using AI." (SPEC)
     → Emphasize "what I decided / verified". -->

See [docs/AI_USAGE.md](docs/AI_USAGE.md) for details.

**Summary**:
- Most first-pass implementation was done in collaboration with AI
- Decisions (library selection, algorithm boundary cases, state-separation pattern) were made by me after option comparison
- Discovered issues (e.g. ...) were diagnosed and fixed under my direction

---

## Reference docs

- [docs/SPEC.md](docs/SPEC.md) — original company spec (immutable)
- [docs/PLAN.md](docs/PLAN.md) — our planning · scope · schedule
- [docs/DESIGN.md](docs/DESIGN.md) — Architecture Decision Records (ADRs)
- [docs/PROCESS.md](docs/PROCESS.md) — implementation order
- [docs/CHECKLIST.md](docs/CHECKLIST.md) — progress tracking + §N rubric mapping
- [docs/AI_USAGE.md](docs/AI_USAGE.md) — AI collaboration log
- [CLAUDE.md](CLAUDE.md) — AI rules · DoD · prohibitions
