# AI Collaboration Context

> Universal rules · DoD · prohibitions. Everything else lives in a pointed-to document.
> <!-- HINT: Replace header → `# {Company} {Role} — {Product} / AI Collaboration Context` -->

---

## Document routing

| What you're looking for | Where it lives | Updated when |
|---|---|---|
| External spec (immutable) | [SPEC.md](docs/SPEC.md) | 🔒 never |
| **Rubric** | **[SPEC.md §"Rubric (detail)"](docs/SPEC.md) + `[§N]` in [CHECKLIST.md](docs/CHECKLIST.md)** | 🔒 never |
| Planning · scope · schedule · §N map | [PLAN.md](docs/PLAN.md) | Phase A only |
| Design decisions (ADRs) | [DESIGN.md](docs/DESIGN.md) | Phase A + C |
| Implementation order / deps | [PROCESS.md](docs/PROCESS.md) | Phase A only |
| Task list / progress | [CHECKLIST.md](docs/CHECKLIST.md) | Phase C every commit |
| Reviewer-facing output | [README.md](README.md) | Phase A + D |
| Kit structure | [OVERVIEW.md](docs/OVERVIEW.md) | Kit releases |
| Kit design rationale | [HARNESS.md](docs/HARNESS.md) | Kit releases |
| Active feature plans | [exec-plans/active/](docs/exec-plans/active/) | Phase C per feature |
| Known tech debt | [tech-debt-tracker.md](docs/exec-plans/tech-debt-tracker.md) | Phase C per shortcut |
| Domain health grades | [CHECKLIST.md "Quality grades"](docs/CHECKLIST.md) | Phase C per cycle |
| Procedure details | [docs/procedures/](docs/procedures/) | Kit releases |

---

## Workflow phases (D-N → D-0)

| Phase | When | Action |
|---|---|---|
| **A. Doc alignment** | D-N ~5h | Paste SPEC · Procedure 6 guided fill · fill PLAN/DESIGN/PROCESS/CHECKLIST |
| **B. Toolchain lock** | D-N+1 ~30m | Pin runtime · add lint/test/build scripts · verify hook + cadence.sh |
| **C. Implementation** | D-N+1~D-1 ×30-60 | code → Procedure 1 DoD → user approval → `git commit [§N]` |
| **D. Polish** | D-1 ~3h | Procedure 2 §N trace · sweep `_TO FILL_` · Procedure 7 doc-gardening |
| **E. Submit** | D-0 ~2h | Fresh session → Procedure 4 strict review · 30-min fixes · go public |

Phase A/B/C/D/E = workflow. PROCESS Phase 0-4 = implementation steps inside Phase C. See [PROCESS.md](docs/PROCESS.md).

---

## Assignment overview

<!-- HINT [Phase A]: Fill once SPEC is read. 3 lines max. -->

- **Deadline**: `<YYYY-MM-DD HH:MM>`
- **Type**: `<FE | BE | FS | ML | Mobile | Other>` — `<one-line product name>`
- **Core challenge**: `<one-line of what this assignment is really testing>`

---

## Tech stack

<!-- HINT [Phase B]: Fill after tech is decided. Rationale → DESIGN.md "Tech selection rationale". -->

| Tech | Version | Purpose |
|------|---------|---------|
| _TO FILL_ | | |

---

## Coding rules — universal

- **No type escapes** — no `any` / `as any` / `cast()` / `# type: ignore`
- **No debug code** — no `console.log` / `print()` / `dbg!()` / `System.out.println`
- **Domain logic isolated** — pure functions in `lib/<domain>/`, not in components/endpoints
- **Unidirectional data flow** — each piece of state has one owner; derived ≠ source-of-truth
- **Check `[§N]` in [CHECKLIST.md](docs/CHECKLIST.md)** for every item you implement
- **TDD for complex features** — when an exec-plan is created, domain logic steps follow Red → Green → Refactor. Simple CRUD / UI wiring steps skip TDD. Red commit uses `TDD_RED=1 git commit` (Gate 2 bypass).

## Coding rules — project-specific

_TO FILL — 3-5 rules specific to this assignment's domain_

---

## Commit convention

Format: `<type>(<scope>): <subject> [§N]`

- **type**: `feat | fix | refactor | test | chore | docs | style | perf`
- **scope**: 5-10 project tokens locked at Phase A start
- **subject**: English, imperative, ≤ 50 chars
- **`[§N]`**: rubric number. Multiple → `[§2,§3]`. Infra/tooling → `[§-]`

---

## Definition of Done (gates per commit)

| # | Gate | How verified |
|---|---|---|
| 1 | Lint clean | `<lint command>` |
| 2 | Tests green | `<test command>` |
| 3 | Build OK | `<build command>` |
| 4 | No type-escape | language grep → 0 |
| 5 | No debug logs | grep → 0 |
| 6 | CHECKLIST `[x]` + exec-plan sync | manual |
| 6b | No doc drift (DESIGN/PLAN/README) | Procedure 1 Gate 6b |
| 7 | Commit message `[§N]` | manual |

Gates 1-5: also enforced by `.githooks/pre-commit` as safety net. Bypass: `SKIP_HOOK=1 git commit` (justify in body). Never `--no-verify`.

---

## Git / Work trail

- **Semantic-unit commits** — one commit = one unit. Align with [PROCESS.md](docs/PROCESS.md).
- **No bulk dump** — explicit deduction if everything lands in one commit.
- **User approval required** — AI must NOT auto-execute `git commit`.
- **Every commit-approval request includes**: staged files · commit message · DoD gate results · doc-sync check (CHECKLIST / DESIGN / PLAN / README).

---

## Absolute prohibitions — universal

- Never commit without user approval
- Never modify [SPEC.md](docs/SPEC.md)
- Never modify [AGENTS.md](AGENTS.md) without intent
- Never inline domain logic in components/endpoints
- Never mix derived/edit state with source-of-truth state

## Absolute prohibitions — project-specific

_TO FILL — 2-4 risks specific to this assignment_

---

## AI agent procedures

Execute inline when triggered. Read the linked procedure file for full steps.

| # | Trigger phrases | Action | Steps |
|---|---|---|---|
| **1** | "ready to commit" · "DoD check" · "커밋해도 돼" | 7-gate DoD check. No commit until gates 1-5 pass. | → [proc-1-dod.md](docs/procedures/proc-1-dod.md) |
| **2** | "§N coverage" · "어디 부족" · "rubric trace" | Per-§N commit + CHECKLIST count; flag gaps. | → [proc-2-trace.md](docs/procedures/proc-2-trace.md) |
| **3** | "SPEC updated" · "company changed spec" | Map SPEC change to PLAN/DESIGN/CHECKLIST impact zones. | → [proc-3-spec-drift.md](docs/procedures/proc-3-spec-drift.md) |
| **4** | "리뷰" · "final review" · "제출 전 점검" · "self-eval" | Strict review: score sim + weakness + critical fixes. Fresh session preferred. | → [proc-4-review.md](docs/procedures/proc-4-review.md) |
| **5** | "어디까지 왔어" · "cadence" · "progress check" · "진행 상황" | `bash scripts/cadence.sh` digest. Read-only — no recommendations. | → [proc-5-cadence.md](docs/procedures/proc-5-cadence.md) |
| **6** | "fill PLAN" · "start Phase A" · "Phase A 시작" · "PLAN 채우자" | Surface SPEC ambiguities one-at-a-time; user picks A/B/C; append to PLAN.md §2. | → [proc-6-phase-a.md](docs/procedures/proc-6-phase-a.md) |
| **7** | "stale docs" · "doc scan" · "가든" · "문서 점검" · Phase D start | Scan docs/ staleness vs recent src/ diff. Report only — no auto-edit. | → [proc-7-gardening.md](docs/procedures/proc-7-gardening.md) |
| **8** | "코드 리뷰해줘" · "code review" · "리뷰해줘" · "review this code" | Deep code quality review: correctness vs SPEC, architecture, simplicity, duplication, naming, error handling, types, security. No auto-fix — user owns all decisions. | → [proc-8-code-review.md](docs/procedures/proc-8-code-review.md) |
