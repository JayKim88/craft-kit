# AI Collaboration Context

> Universal rules · DoD · prohibitions. Everything else lives in a pointed-to document.
> <!-- HINT: Replace header → `# {Client} {Project} — {Product} / AI Collaboration Context` -->

---

## Session invariants — read first, every session

- Never `git commit` without user approval
- Never `--no-verify`
- Run Procedure 1 DoD before every commit proposal
- When in doubt: read the procedure file, don't infer

<HARD-GATE>
Do not create or modify any `src/` file until ALL of the following are confirmed:

- [ ] `docs/SPEC.md` contains real spec content (not a placeholder)
- [ ] `docs/PLAN.md` §2 Assumption-Map has at least 4 rows (all surfaced ambiguities resolved)
- [ ] `docs/PLAN.md` §3 scope is filled (Required / Optional lists confirmed)
- [ ] `docs/DESIGN.md` has at least 3 ADRs with SPEC origin fields
- [ ] `docs/CHECKLIST.md` tasks are tagged with [§N]
- [ ] User has explicitly approved the above

If any box is unchecked: stop, surface what is missing, and run Procedure 6 (Phase A).
</HARD-GATE>

---

## Document routing

| What you're looking for | Where it lives | Updated when |
|---|---|---|
| Project spec (immutable) | [SPEC.md](docs/SPEC.md) | 🔒 never |
| **Requirements** | **[SPEC.md §"Requirements (detail)"](docs/SPEC.md) + `[§N]` in [CHECKLIST.md](docs/CHECKLIST.md)** | 🔒 never |
| Planning · scope · schedule · §N map | [PLAN.md](docs/PLAN.md) | Phase A only |
| Design decisions (ADRs) | [DESIGN.md](docs/DESIGN.md) | Phase A + C |
| Implementation order / deps | [PROCESS.md](docs/PROCESS.md) | Phase A only |
| Task list / progress | [CHECKLIST.md](docs/CHECKLIST.md) | Phase C every commit |
| External-facing output | [README.md](README.md) | Phase A + D |
| Kit structure | [OVERVIEW.md](docs/kit/OVERVIEW.md) | Kit releases |
| Kit design rationale | [HARNESS.md](docs/kit/HARNESS.md) | Kit releases |
| Active feature plans | [exec-plans/active/](docs/exec-plans/active/) | Phase C per feature |
| Known tech debt | [tech-debt-tracker.md](docs/exec-plans/tech-debt-tracker.md) | Phase C per shortcut |
| Domain health grades | [CHECKLIST.md "Quality grades"](docs/CHECKLIST.md) | Phase C per cycle |
| Procedure details (project) | [docs/procedures/](docs/procedures/) | Kit releases |
| Recommended dev tools (MCP, env) | [TOOLS.md](docs/kit/TOOLS.md) | Kit releases |
| Coding style (full standard + lint template) | [CODING-STYLE.md](docs/kit/CODING-STYLE.md) + [templates/eslint.config.mjs](docs/kit/templates/eslint.config.mjs) | Kit releases |
| Kit version history | [docs/kit/HISTORY.md](docs/kit/HISTORY.md) | kit-improve (post-acceptance) |
| Kit improvement proposals + kit-improve | [kit/improvements/](docs/kit/improvements/) | Stop hook (auto) + kit-improve |
| Kit planning docs (harness evaluations, initiatives) | [kit/plans/](docs/kit/plans/) `done/` · `in-progress/` · `todo/` | Manual — per evaluation cycle |

---

## Workflow phases (D-N → D-0)

| Phase | When | Action |
|---|---|---|
| **A. Doc alignment** | D-N ~5h | Paste spec · Procedure 6 guided fill · fill PLAN/DESIGN/PROCESS/CHECKLIST |
| **B. Toolchain lock** | D-N+1 ~30m | Pin runtime · add lint/test/build scripts · verify hook + cadence.sh · install dev tools (context-mode, code-review-graph) |
| **C. Implementation** | D-N+1~D-1 ×30-60 | code → Procedure 1 DoD → user approval → `git commit [§N]` |
| **D. Polish** | D-1 ~3h | Procedure 2 §N trace · sweep `_TO FILL_` · Procedure 7 doc-gardening |
| **E. Ship** | D-0 ~2h | Fresh session → Procedure 4 strict review · fixes · ship / hand off |

Phase A/B/C/D/E = workflow. PROCESS Phase 0-4 = implementation steps inside Phase C. See [PROCESS.md](docs/PROCESS.md).

---

## Project overview

<!-- HINT [Phase A]: Fill once spec is read. 3 lines max. -->

- **Deadline**: `<YYYY-MM-DD HH:MM>`
- **Type**: `<FE | BE | FS | ML | Mobile | Other>` — `<one-line product name>`
- **Core challenge**: `<one-line of what this project is really testing>`

---

## Tech stack

<!-- HINT [Phase B]: Fill after tech is decided. Rationale → DESIGN.md "Tech selection rationale". -->

| Tech | Version | Purpose |
|------|---------|---------|
| _TO FILL_ | | |

---

## Coding rules

Full standard → **[CODING-STYLE.md](docs/kit/CODING-STYLE.md)**. Two layers:

- **Tool-enforced (auto)** — type escapes, debug code, import order, naming, `const`, `import type`, `interface` for object shapes, a11y, etc. Encoded in `eslint.config.mjs` (copied at Phase B from [templates/eslint.config.mjs](docs/kit/templates/eslint.config.mjs)). DoD Gate 1 + post-edit-lint enforce these — **you do not need to recall them**.
- **Judgment (read before writing `src/`)** — layering (`lib/` vs `utils/`), state ownership, test strategy, when-to-extract, prop typing. These can't be linted. Read [CODING-STYLE.md §2](docs/kit/CODING-STYLE.md).

Non-negotiables (apply even if the doc wasn't read):
- No type escapes (`any` / `as any` / `# type: ignore`) · No debug code (`console.log` / `print()`)
- Domain logic in `lib/<domain>/`, never inlined in components/endpoints
- Unidirectional data flow — one owner per state; derived ≠ source-of-truth
- Check `[§N]` in [CHECKLIST.md](docs/CHECKLIST.md) for every item you implement
- **TDD for complex features** — exec-plan domain steps follow Red → Green → Refactor. Red commit uses `TDD_RED=1 git commit` (Gate 2 bypass).

## Coding rules — project-specific

_TO FILL — 3-5 rules specific to this project's domain_

---

## Commit convention

Format: `<type>(<scope>): <subject> [§N]`

- **type**: `feat | fix | refactor | test | chore | docs | style | perf`
- **scope**: 5-10 project tokens locked at Phase A start
- **subject**: English, imperative, ≤ 50 chars
- **`[§N]`**: criterion number. Multiple → `[§2,§3]`. Infra/tooling → `[§-]`

---

## Definition of Done (gates per commit)

| # | Gate | How verified |
|---|---|---|
| 1 | Lint clean | `<lint command>` |
| 2 | Tests green | `<test command>` |
| 3 | Build OK | `<build command>` |
| 4 | No type-escape | language grep → 0 |
| 5 | No debug logs | grep → 0 |
| 5b | Architecture — domain dirs (`lib/` `utils/`) must not import from UI/endpoint layers | grep of staged blobs in domain dirs |
| 6 | CHECKLIST `[x]` + exec-plan sync | manual |
| 6b | No doc drift (DESIGN/PLAN/README) | Procedure 1 Gate 6b |
| 7 | Commit message `[§N]` | manual |

Gates 1-5b: also enforced by `.githooks/pre-commit` as safety net. Bypass: `SKIP_HOOK=1 git commit` (justify in body). Never `--no-verify`.

---

## Git / Work trail

- **Semantic-unit commits** — one commit = one unit. Align with [PROCESS.md](docs/PROCESS.md).
- **No bulk dump** — a quality concern if everything lands in one commit.
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

_TO FILL — 2-4 risks specific to this project_

---

## AI agent procedures

Execute inline when triggered. Read the linked procedure file for full steps.

| # | Trigger phrases | Action | Steps |
|---|---|---|---|
| **1** | "ready to commit" · "DoD check" · "커밋해도 돼" | 7-gate DoD check + independent subagent critical review (Correctness vs SPEC, Security). No commit until gates 1-5 pass and no 🚨 findings. | → [proc-1-dod.md](docs/procedures/proc-1-dod.md) |
| **2** | "§N coverage" · "어디 부족" · "criteria trace" | Per-§N commit + CHECKLIST count; flag gaps. | → [proc-2-trace.md](docs/procedures/proc-2-trace.md) |
| **3** | "SPEC updated" · "requirements changed" | Map SPEC change to PLAN/DESIGN/CHECKLIST impact zones. | → [proc-3-spec-drift.md](docs/procedures/proc-3-spec-drift.md) |
| **4** | "리뷰" · "final review" · "완료 전 점검" · "self-eval" | Strict review: coverage check (+ score sim if SPEC defines scoring) + gaps + critical fixes. Fresh session preferred. **Automatically runs Procedure 9 after output — Phase E only ("final review" / "완료 전 점검").** | → [proc-4-review.md](docs/procedures/proc-4-review.md) |
| **5** | "어디까지 왔어" · "cadence" · "progress check" · "진행 상황" | `bash scripts/cadence.sh` digest. Read-only — no recommendations. | → [proc-5-cadence.md](docs/procedures/proc-5-cadence.md) |
| **6** | "fill PLAN" · "start Phase A" · "Phase A 시작" · "PLAN 채우자" | Surface SPEC ambiguities one-at-a-time; user picks A/B/C; append to PLAN.md §2. | → [proc-6-phase-a.md](docs/procedures/proc-6-phase-a.md) |
| **7** | "stale docs" · "doc scan" · "가든" · "문서 점검" · Phase D start | Scan docs/ staleness vs recent src/ diff. Report only — no auto-edit. | → [proc-7-gardening.md](docs/procedures/proc-7-gardening.md) |
| **8** | "코드 리뷰해줘" · "code review" · "리뷰해줘" · "review this code" | Deep code quality review: correctness vs SPEC, architecture, simplicity, duplication, naming, error handling, types, security. Systemic findings flagged as harness gaps (📋 CLAUDE.md gap / 🔧 Hook gap) → kit-improve candidates. No auto-fix — user owns all decisions. | → [proc-8-code-review.md](docs/procedures/proc-8-code-review.md) |
| **9** | "보안 감사" · "security audit" · "취약점 확인" · "cso" | Dedicated security audit: secrets, dependencies, CI/CD, OWASP Top 10. Exploit scenario required per finding. No auto-fix. | → [proc-9-security.md](docs/procedures/proc-9-security.md) |
| **10** | "kit improve" · "개선 반영" · "improvement review" | Review `docs/kit/improvements/pending/`, decide accept/reject/defer per proposal, apply to CLAUDE.md, log in docs/kit/HISTORY.md, archive. No auto-apply — user approval required per change. | → [kit-improve.md](docs/kit/improvements/kit-improve.md) |

---

## Self-improvement loop

The kit improves itself through three hook-driven mechanisms. No manual trigger needed for collection — only **kit-improve** requires user action.

| Hook | Event | What it does |
|---|---|---|
| `scripts/hooks/session-reflect.sh` | `Stop` (end of each turn) | If src/ files were edited this session, writes a structured review prompt to `docs/kit/improvements/pending/YYYY-MM-DD.md`. Idempotent — one file per day. |
| `scripts/hooks/session-start.sh` | `UserPromptSubmit` (first message) | Injects current branch, active exec-plans, and pending-improvement count as system context. Runs once per session via session-ID marker. |
| `scripts/hooks/post-edit-lint.sh` | `PostToolUse` (Write/Edit) | Runs fast lint on modified src/ file. Surfaces errors only (non-blocking). Pre-commit gate 1 remains authoritative. |

**When proposals accumulate** → trigger **kit-improve**. Accepted improvements are logged in [docs/kit/HISTORY.md](docs/kit/HISTORY.md) and archived; rejected proposals are archived with a reason.
