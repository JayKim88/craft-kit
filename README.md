<details>
<summary><b>About takehome-kit</b> — delete this block after cloning for your assignment</summary>

This repository is a clone-and-edit template for corporate take-home assignments. It ships a 7-document SSOT workflow (SPEC / PLAN / DESIGN / PROCESS / CHECKLIST / AI_USAGE / README), an 8-gate Definition of Done in `CLAUDE.md`, `[§N]` rubric tagging, and four AI agent procedures embedded in `CLAUDE.md` (DoD verification, §N coverage trace, SPEC drift, strict pre-submission review).

**Bootstrap a new assignment:**

```bash
git clone https://github.com/JayKim88/takehome-kit my-task
cd my-task
rm -rf .git
git init && git add . && git commit -m "chore: bootstrap from takehome-kit"
```

After cloning, edit headers in this README, [`CLAUDE.md`](CLAUDE.md), and [`docs/PLAN.md`](docs/PLAN.md), then paste the company spec into [`docs/SPEC.md`](docs/SPEC.md). Universal best practices in `CLAUDE.md` stay; project-specific zones marked `<!-- HINT -->` are yours to fill.

**How to use (after bootstrap):**

| Phase | When | Action | Files touched |
|---|---|---|---|
| **A. Doc alignment** | D-N (~5h) | Paste SPEC verbatim. Transcribe rubric (6 placeholder categories in `docs/SPEC.md`). Fill `docs/PLAN.md` §2 (interpretation), §3 (scope), §4 (schedule), §5 (rubric mapping), §6 (risks). Write 5-10 ADRs in `docs/DESIGN.md`. Decompose Phase 0~4 in `docs/PROCESS.md`. Tag 50-100 items with `[§N]` in `docs/CHECKLIST.md`. Fill project-specific HINT zones in `CLAUDE.md`. | All 6 docs + CLAUDE.md |
| **B. Toolchain lock** | D-N+1 (~30m) | Pin runtime version. Add `lint` / `test` / `build` scripts. Run them — all PASS. Replace `<lint command>` placeholders in `CLAUDE.md` DoD table with real commands. Mark Phase B items `[x]` in CHECKLIST. | `package.json` (or stack equivalent), CLAUDE.md, CHECKLIST.md |
| **C. Implementation cycle** | D-N+1 ~ D-1 (×30-60) | Per feature: code → ask AI to verify DoD → mark CHECKLIST `[x]` + add AI_USAGE row → user approval → commit `<type>(<scope>): <subject> [§N]`. | src/, CHECKLIST.md, AI_USAGE.md, git log |
| **D. Polish** | D-1 (~3h) | Ask AI for §N coverage trace. Patch with extra `docs:` commits. Sweep all `_TO FILL_` markers in README. Run manual smoke checklist. | README.md, ad-hoc fixes |
| **E. Submit** | D-0 (~2h) | Open a fresh Claude session; ask for strict pre-submission review. Apply 30-min critical fixes. Verify `grep -rn "_TO FILL_\|<!-- TODO" README.md docs/` returns 0. Make repo public + submit. | README.md, repo settings |

**AI agent procedures** (defined in `CLAUDE.md`, triggered by natural language — no slash command needed):

| Procedure | Triggered when you say... | What the AI does |
|---|---|---|
| DoD verification | "ready to commit", "DoD check", "커밋해도 돼" | Runs the 8-gate check (lint/test/build + grep type-escapes per stack + grep debug logs + CHECKLIST/AI_USAGE/commit-msg sync) |
| Checklist trace | "§N coverage", "어디 부족", "rubric trace" | Counts commits and CHECKLIST items per §N; flags under-covered categories |
| SPEC drift check | "SPEC updated", "company changed spec" | Maps SPEC change to impacted PLAN / DESIGN / CHECKLIST sections |
| Pre-submission review | "리뷰", "final review", "제출 전 점검" | Switches to strict-reviewer mode; outputs score-sim + weakness + critical fixes + time-boxed patches |

**Forking:** edit `LICENSE` (copyright line) and the `git clone` URL above to point to your fork.

</details>

# `<Product Name>`

> Submission for the `<Company>` `<Role>` take-home assignment.

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

<!-- HINT [After Phase B]: Update the table below at end of Phase 4:
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

<!-- HINT [Phase 4 wrap-up, most important]: SPEC's README "Design decisions" section is at the heart of the Documentation rubric.
     Extract 5-8 reviewer-friendly ADRs from DESIGN.md.

     Below is the format for one ADR. In your assignment, scale to 5-8.
-->

### 1. _Decision title 1_

_TO FILL — context → options → decision → rationale → trade-offs_

### 2. _Decision title 2_

_TO FILL_

<!-- 3-8 to add -->

---

## Unimplemented / constraints

<!-- HINT [Phase 4]: Be honest. The Documentation rubric explicitly looks for "if anything is missing, state the reason and an alternative."
     Don't hide. Format: "X was not implemented due to time, alternative is Y." -->

- _TO FILL 1_
- _TO FILL 2_

---

## AI usage scope

<!-- HINT: Summary + link to AI_USAGE.md.
     "AI usage itself is not penalized. We evaluate how much you made the result your own after using AI." (typical SPEC clause)
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
