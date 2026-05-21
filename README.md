<details>
<summary><b>About craft-kit</b> — remove this entire block (including the <code>&lt;details&gt;</code> and <code>&lt;/details&gt;</code> tags) once you start filling the submission skeleton below</summary>

This repository is a clone-and-edit template for short-scope engineering projects. It ships a 6-document SSOT workflow (SPEC / PLAN / DESIGN / PROCESS / CHECKLIST / README), a 7-gate Definition of Done in `CLAUDE.md`, `[§N]` rubric tagging, **eight AI agent procedures** (DoD verify, §N trace, SPEC drift, strict pre-submission review, cadence check, Phase A guided fill, doc-gardening, deep code review), and a **stack-aware pre-commit safety net** installed via `git config core.hooksPath`.

**Bootstrap a new assignment:**

```bash
git clone https://github.com/JayKim88/craft-kit my-task
cd my-task
rm -rf .git
git init
git config core.hooksPath .githooks    # v0.8: enable DoD pre-commit hook
git add . && git commit -m "chore: bootstrap from craft-kit"
```

After cloning:
1. Edit headers in this `README.md`, [`CLAUDE.md`](CLAUDE.md), [`AGENTS.md`](AGENTS.md), and [`docs/PLAN.md`](docs/PLAN.md). Look for `<...>` brackets and `_TO FILL_` markers.
2. Paste the company spec into [`docs/SPEC.md`](docs/SPEC.md) (then never edit it).
3. Transcribe the rubric into `docs/SPEC.md` "Rubric (detail)" (6 placeholder categories — adjust to match the company's spec).
4. Follow the **5-phase workflow** documented at the top of `CLAUDE.md` ("Workflow phases (D-N to D-0)"). The AI agent will auto-trigger eight procedures — DoD verification, §N coverage trace, SPEC drift check, strict pre-submission review, cadence check, Phase A guided fill, doc-gardening, and deep code review — based on natural-language cues described in `CLAUDE.md` "AI agent procedures".
5. The pre-commit hook (`.githooks/pre-commit`) is now active. Lint / test / build / type-escape / debug-log checks run before each commit. Auto-skips on Phase A docs-only commits. Emergency bypass: `SKIP_HOOK=1 git commit ...` (justify in body). **Never** use `--no-verify`.

Universal best practices in `CLAUDE.md` stay; project-specific zones marked `<!-- HINT -->` are yours to fill.

**Forking:** edit `LICENSE` (copyright line) and the `git clone` URL above to point to your fork.

**How it works:** [docs/OVERVIEW.md](docs/OVERVIEW.md) — unified diagram + 3-view breakdown (timeline / file map / per-commit flow).

**Design rationale:** [docs/HARNESS.md](docs/HARNESS.md) — why this kit is shaped the way it is, mapped to OpenAI's harness engineering principles.

</details>

# `<Product Name>`

> Submission for the `<Company>` `<Role>` assignment.

<!-- HINT [One-line summary, write in Phase A]: user value + core challenge in one line.
     Example: "An SPA where students visually edit and save their weekly study schedule. Core: time-conflict detection + edit/save state separation." -->

Core challenge: **`<one-line description>`**

---

## Project overview

<!-- HINT [Phase A]: Summarize SPEC's key requirements in our own words (1-2 paragraphs) + state explicitly "where we focused".
     This is what reviewers read first — the README's first impression directly affects the Documentation rubric. -->

_TO FILL — complete at end of Phase A._

---

## Tech stack & rationale

### Core infrastructure

<!-- HINT [Fill after Phase B]: language, framework, key libraries. One-line rationale per item. -->

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

- `<runtime + version>` (e.g. Node.js 22.19, Python 3.13)
- (Other: `<DB / services etc.>`)

### Install & run

```bash
# 1. Install dependencies
<install command>          # e.g. npm install / poetry install / cargo build

# 2. Start dev server
<dev command>              # e.g. npm run dev / uvicorn app.main:app --reload

# 3. Build (optional)
<build command>            # e.g. npm run build / cargo build --release
```

### Test

```bash
<test command>             # e.g. npm test / pytest / cargo test
```

<!-- HINT [After Phase B]: Update the table below at end of PROCESS Phase 4 (wrap-up):
     | Tier | Target | Count |
     |---|---|---|
     | 1. Pure functions | lib/<domain>.ts | N |
     | 2. Components / endpoints | ... | N |
     | 3. Integration | ... | N |
-->

### Mock-API setup (FE assignment only)

<!-- HINT [FE only, Phase B-C]: Delete this section for BE assignments.
     FE: state how you mocked (MSW / json-server / static JSON) + operational considerations (e.g. SW detach fallback). -->

_TO FILL or DELETE if BE_

### Dev-scenario URL flags (FE only — delete for BE / ML / Mobile)

<!-- HINT [FE only]: Provide URL flags so reviewers can reproduce error/edge cases easily. Delete this entire subsection if not applicable to your assignment.
     Examples:
     - `?_seed=empty` — empty initial state
     - `?_seed=stress` — N+ items stress test
     - `?_simulate=<ERROR_CODE>` — trigger a specific error response
     - `?_slow=2000` — 2-second response delay
-->

---

## Project structure

<!-- HINT: Folder tree + one-line responsibility per folder.

   FE example:
   src/
   ├── app/         # routing
   ├── components/  # presentational
   ├── hooks/       # data hooks
   ├── lib/         # Domain logic (isolated modules)
   ├── store/       # client-only state
   └── types/       # type definitions

   BE example:
   src/
   ├── controllers/  # HTTP layer
   ├── services/     # business logic
   ├── repositories/ # data access
   ├── domain/       # pure domain models
   └── middleware/   # cross-cutting concerns
-->

```
src/
├── ...
└── ...
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

<!-- HINT [PROCESS Phase 4 wrap-up, most important]: SPEC's README "Design decisions" section is at the heart of the Documentation rubric.
     Extract 5-8 reviewer-friendly ADRs from DESIGN.md. The 5-step format
     (context → options → decision → rationale → trade-off) is defined in
     [docs/DESIGN.md "## 3. Decision Records (ADR)"](docs/DESIGN.md).
-->

### 1. _Decision title 1_

_TO FILL — context → options → decision → rationale → trade-offs_

### 2. _Decision title 2_

_TO FILL_

<!-- 3-8 to add -->

---

## Unimplemented / constraints

<!-- HINT [PROCESS Phase 4]: Be honest. The Documentation rubric explicitly looks for "if anything is missing, state the reason and an alternative."
     Don't hide. Format: "X was not implemented due to time, alternative is Y." -->

- _TO FILL 1_
- _TO FILL 2_

---

## AI usage scope

<!-- HINT: "AI usage itself is not penalized. We evaluate how much you made the result your own after using AI." (typical SPEC clause)
     → Emphasize "what I decided / verified". -->

**Summary**:
- Most first-pass implementation was done in collaboration with AI
- Decisions (library selection, edge-case handling, error-handling strategy) were made by me after option comparison
- Discovered issues (e.g. ...) were diagnosed and fixed under my direction

---

## Reference docs

- [docs/SPEC.md](docs/SPEC.md) — original company spec (immutable)
- [docs/PLAN.md](docs/PLAN.md) — our planning · scope · schedule
- [docs/DESIGN.md](docs/DESIGN.md) — Architecture Decision Records (ADRs)
- [docs/PROCESS.md](docs/PROCESS.md) — implementation order
- [docs/CHECKLIST.md](docs/CHECKLIST.md) — progress tracking + §N rubric mapping
- [CLAUDE.md](CLAUDE.md) — AI rules · DoD · prohibitions
