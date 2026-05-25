<details>
<summary><b>About craft-kit</b> — remove this entire block (including the <code>&lt;details&gt;</code> and <code>&lt;/details&gt;</code> tags) once you start filling the project skeleton below</summary>

A structured kit for shipping quality code under deadline pressure. Clone → fill in your spec → the kit handles workflow, DoD enforcement, and AI procedures automatically.

- **6-document SSOT** — SPEC / PLAN / DESIGN / PROCESS / CHECKLIST / README, each with a clear owner and update cadence
- **7-gate Definition of Done** — enforced in `CLAUDE.md` and re-enforced by the pre-commit hook
- **9 AI agent procedures** — triggered by natural language ("ready to commit", "리뷰해줘", "보안 감사", "어디까지 왔어")
- **Stack-aware pre-commit safety net** — auto-detects Node / Python / Rust / Go / Java via `git config core.hooksPath`

> For a full mental model — phase timeline, file ownership, per-commit flow — see **[docs/kit/OVERVIEW.md](docs/kit/OVERVIEW.md)**.

**Bootstrap a new project:**

```bash
git clone https://github.com/JayKim88/craft-kit my-project
cd my-project
rm -rf .git
git init
git config core.hooksPath .githooks    # enable DoD pre-commit hook
git add . && git commit -m "chore: bootstrap from craft-kit"
```

After cloning:
1. Edit headers in `README.md`, [`CLAUDE.md`](CLAUDE.md), [`AGENTS.md`](AGENTS.md), and [`docs/PLAN.md`](docs/PLAN.md). Look for `<...>` brackets and `_TO FILL_` markers.
2. Paste the project spec / requirements into [`docs/SPEC.md`](docs/SPEC.md) (then never edit it).
3. Define the evaluation criteria in `docs/SPEC.md` "Requirements (detail)".
4. Follow the **5-phase workflow** in `CLAUDE.md` ("Workflow phases (D-N to D-0)"):
   - Phase A: doc alignment (PLAN / DESIGN / PROCESS / CHECKLIST)
   - Phase B: toolchain lock (lint / test / build scripts)
   - Phase C: implementation — `code → DoD → user approval → commit` × N
   - Phase D: polish — §N trace, sweep `_TO FILL_`
   - Phase E: ship — fresh-session strict review, ship / hand off
5. The pre-commit hook (`.githooks/pre-commit`) runs gates 1-5 automatically. Emergency bypass: `SKIP_HOOK=1 git commit ...`. **Never** `--no-verify`.

Project-specific zones are marked `<!-- HINT -->` — yours to fill. Universal rules in `CLAUDE.md` stay as-is.

**Forking:** edit `LICENSE` (copyright line) and the `git clone` URL above to point to your fork.

**Design rationale:** [docs/kit/HARNESS.md](docs/kit/HARNESS.md) — why this kit is shaped the way it is, mapped to OpenAI's harness engineering principles.

</details>

# `<Product Name>`

> Delivery for the `<Client>` `<Project>` project.

<!-- HINT [One-line summary, write in Phase A]: user value + core challenge in one line.
     Example: "An SPA where students visually edit and save their weekly study schedule. Core: time-conflict detection + edit/save state separation." -->

Core challenge: **`<one-line description>`**

---

## Project overview

<!-- HINT [Phase A]: Summarize SPEC's key requirements in our own words (1-2 paragraphs) + state explicitly "where we focused".
     This is what readers encounter first — the README's first impression signals documentation quality. -->

_TO FILL — complete at end of Phase A._

---

## Tech stack & rationale

### Core infrastructure

<!-- HINT [Fill after Phase B]: language, framework, key libraries. One-line rationale per item. -->

| Tech | Version | Reason |
|---|---|---|
| ... | ... | ... |

### Free-choice areas — most-validated tool per area

<!-- HINT: If SPEC says "library choice is free (justify in README)", this section is at the heart of the evaluation criteria.
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

<!-- HINT: SPEC's required "How to run" section. Be very concrete to guarantee anyone can run it. -->

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

### Mock-API setup (FE project only)

<!-- HINT [FE only, Phase B-C]: Delete this section for BE projects.
     FE: state how you mocked (MSW / json-server / static JSON) + operational considerations (e.g. SW detach fallback). -->

_TO FILL or DELETE if BE_

### Dev-scenario URL flags (FE only — delete for BE / ML / Mobile)

<!-- HINT [FE only]: Provide URL flags so anyone can reproduce error/edge cases easily. Delete this entire subsection if not applicable to your project.
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

<!-- HINT [Phase A]: Move PLAN.md §2 "Our planning interpretation" table into a reader-friendly form here.
     What was ambiguous in SPEC + our decision + rationale. -->

_TO FILL — extract from PLAN.md §2 table_

### Optional implementations (bonus)

<!-- HINT: Which bonus items did we ship, which did we drop, with what rationale. -->

_TO FILL_

---

## Design decisions & rationale

<!-- HINT [PROCESS Phase 4 wrap-up, most important]: SPEC's README "Design decisions" section is at the heart of the documentation criteria.
     Extract 5-8 reader-friendly ADRs from DESIGN.md. The 5-step format
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

<!-- HINT [PROCESS Phase 4]: Be honest. Good documentation explicitly requires "if anything is missing, state the reason and an alternative."
     Don't hide. Format: "X was not implemented due to time, alternative is Y." -->

- _TO FILL 1_
- _TO FILL 2_

---

## AI usage scope

<!-- HINT: Clarify how AI was used and what judgment you applied independently.
     Emphasize decisions, verifications, and directions that were yours — not the AI's. -->

**Summary**:
- Most first-pass implementation was done in collaboration with AI
- Decisions (library selection, edge-case handling, error-handling strategy) were made by me after option comparison
- Discovered issues (e.g. ...) were diagnosed and fixed under my direction

---

## Reference docs

- [docs/SPEC.md](docs/SPEC.md) — original project spec (immutable)
- [docs/PLAN.md](docs/PLAN.md) — our planning · scope · schedule
- [docs/DESIGN.md](docs/DESIGN.md) — Architecture Decision Records (ADRs)
- [docs/PROCESS.md](docs/PROCESS.md) — implementation order
- [docs/CHECKLIST.md](docs/CHECKLIST.md) — progress tracking + §N criteria mapping
- [CLAUDE.md](CLAUDE.md) — AI rules · DoD · prohibitions
