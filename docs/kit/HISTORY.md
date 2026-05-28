# Kit History — craft-kit

Chronological record of accepted kit improvements. Newest first.
Each entry was processed through kit-improve and approved by the user.

> **Rejected proposals** are archived in `docs/kit/improvements/rejected/` with a reason.
> **Pending proposals** are staged in `docs/kit/improvements/pending/`.

---

## Improvement log (post-v1.0)

_Entries added here by kit-improve as improvements are accepted._

<!-- Format:
### YYYY-MM-DD — short description
- **Source**: `docs/kit/improvements/pending/<filename>`
- **Change**: what was added or amended (one sentence)
- **Target**: `CLAUDE.md §"<section>"`
-->

---

## v1.6 — Coding-style externalization (CODING-STYLE.md + lint template)
*Date: 2026-05-28*

Moved the coding standard out of CLAUDE.md's always-loaded body into a dedicated two-layer reference, applying the tools-over-prose principle: deterministic rules become a linter config, judgment rules become an on-demand doc.

- **`docs/kit/CODING-STYLE.md`** (new): §1 tool-enforced rules (table → ESLint), §2 judgment rules (9 patterns with inline examples), §3 Phase B setup + verified Prettier import-ordering route.
- **`docs/kit/templates/eslint.config.mjs`** (new): Bucket A/B style rules layered on `eslint-config-next`. Three rules removed after empirical failure on a real toolchain: `import/no-cycle` + `import/order` (broken resolver → opt-in Prettier route instead), boolean-name prefix (needs typed linting → judgment rule).
- **`docs/kit/templates/.prettierrc`** (new): formatter defaults.
- **`CLAUDE.md`**: 24-bullet "Coding rules — universal" block replaced with a pointer + 5 non-negotiables; routing-table row + Phase B workflow row added.
- **`scripts/hooks/session-start.sh`**: injects a "read CODING-STYLE.md §2 before editing src/" nudge when `src/` exists.
- **`docs/kit/OVERVIEW.md` / `proc-8` / `kit-improve.md` / `HARNESS.md` / `GUIDE.md`**: synced to point coding-rule changes at CODING-STYLE.md / the ESLint template.

**Why**: CLAUDE.md must stay a concise index (community consensus + ETH 2026 finding that bloated/over-prose rule files lower task success and raise cost). Coding rules were the one block violating the kit's own progressive-disclosure principle. Splitting them into a linter (deterministic floor — Gate 1 + post-edit-lint) and an on-demand doc (judgment ceiling) keeps CLAUDE.md lean while strengthening enforcement.

**Verification**: the ruleset was run against the `ennt` reference project's real toolchain — it caught actual violations (magic numbers, object-literal casts) and the three broken rules were found by execution, not assumed. The Prettier import-sort route was verified in a throwaway project.

### Five-principle coverage after v1.6

| Principle | v1.5 | v1.6 addition |
|---|---|---|
| **Constrain** | Pre-commit gates 1–5b | Coding-style ESLint template (primary-stack) — Gate 1 enforces deterministic style rules |
| **Inform** | Start hook + skills + exec-plans + subagent map + cadence | CLAUDE.md slimmed to an index; start hook nudges CODING-STYLE.md §2 before src/ edits |
| **Verify** | PostToolUse lint + cadence + pre-commit-reviewer + Gate 5b | post-edit-lint now enforces the shared style ruleset, not just stack defaults |
| **Correct** | Stop hook + kit-improve + Proc 8 Step 13 | Coding-rule gaps now route to CODING-STYLE.md / ESLint template (proc-8, kit-improve updated) |
| **Human in loop** | All correctives advisory + `// allow:` | Preserved — §2 judgment rules advisory; type/interface left to dev intent |

---

## v1.5 — Architecture fitness gate (Gate 5b)
*Date: 2026-05-28*

Added Gate 5b to `.githooks/pre-commit`, converting the "domain logic isolated" rule in CLAUDE.md from a guide-only rule into a mechanically enforced sensor.

- **`.githooks/pre-commit` Gate 5b**: checks staged files in `src/lib/`, `src/utils/`, `src/helpers/`, `src/shared/` for imports from UI/endpoint layers (`components|pages|api|routes|views|app`). Covers TS/JS/Python files. Exit 6 on violation. Bypass: `// allow:` or `# allow:` comment on the offending import line.
- **`CLAUDE.md` DoD table**: Gate 5b row added between Gate 5 and Gate 6. Gate footnote updated from "Gates 1-5" to "Gates 1-5b".
- **`docs/kit/plans/done/2026-05-28-harness-evaluation.md`**: Improvement 3 marked as implemented.

**Why**: CLAUDE.md stated "domain logic in `lib/<domain>/`, never inlined in components/endpoints" but no sensor enforced it — violations were only caught in Proc 8 (manual, skippable). Gate 5b closes this as a computational sensor: same pattern in all repos, zero configuration, fires at commit time.

**Scope decision — why `src/utils/` is included**: craft-kit's convention places both domain logic and shared utilities under `src/lib/`. Real projects frequently create `src/utils/` separately. The same architectural principle applies — utility code must not depend on UI layers.

### Five-principle coverage after v1.5

| Principle | v1.4 | v1.5 addition |
|---|---|---|
| **Constrain** | Pre-commit hook gates 1–5 | Gate 5b — architecture violation blocks commit |
| **Inform** | Start hook + skills + exec-plans + subagent map + cadence metrics | (no change) |
| **Verify** | PostToolUse lint + cadence injection + pre-commit-reviewer | Gate 5b is a computational sensor — deterministic, automatic, zero user action |
| **Correct** | Stop hook + kit-improve + Proc 8 Step 13 | (no change) |
| **Human in loop** | All correctives advisory | Preserved — `// allow:` provides intentional exception path |

---

## v1.4 — Pre-commit independent critical review
*Date: 2026-05-28*

Added an independent subagent review as Proc 1 Step 0b, addressing the rationalization bias in the existing self-review (Step 0).

- **`.claude/agents/pre-commit-reviewer.md`**: new read-only subagent — checks staged diff for Critical issues only: Correctness vs SPEC (stated requirement with zero implementation evidence) and Security surface scan (injection, exposed credentials, missing auth, XSS). Passes silently when clean; reports 🚨 findings only. No auto-fix.
- **`docs/procedures/proc-1-dod.md` Step 0b**: spawns `pre-commit-reviewer` after self-review (Step 0) and before auto gates (Step 1). Skipped for kit-only work (no src/ in staged diff). 🚨 finding stops DoD immediately.
- **Output table**: added `Pre-commit review` row between Self-review and Auto gates.
- **`CLAUDE.md` Proc 1 description**: updated to mention subagent critical review.

**Why**: Step 0 (self-review) is performed by the same agent that wrote the code — rationalization bias is unavoidable. A separate subagent with no session context catches Correctness and Security blockers with fresh eyes. Non-blocking for all other dimensions — Proc 8 remains the deliberate deep review.

### Five-principle coverage after v1.4

| Principle | v1.3 | v1.4 addition |
|---|---|---|
| **Constrain** | Pre-commit hook gates 1–5 | (no change) |
| **Inform** | Start hook + skills + exec-plans + subagent map + cadence metrics | (no change) |
| **Verify** | PostToolUse lint + cadence injection | Independent subagent verifies Correctness + Security before every commit |
| **Correct** | Stop hook + kit-improve + Proc 8 Step 13 | (no change) |
| **Human in loop** | All correctives advisory | Preserved — subagent reports only; user resolves 🚨 findings |

---

## v1.3 — Start hook cadence injection
*Date: 2026-05-28*

Extended the session-start hook to inject live project health metrics at the top of every session, closing the gap identified in `docs/kit/plans/done/2026-05-28-harness-evaluation.md` Improvement 1.

- **`scripts/hooks/session-start.sh`**: added CHECKLIST progress (`done / total (pct%)`), days to deadline (derived from CLAUDE.md), and last commit summary — all appended after the existing branch / active-plans / pending output
- **Guard clauses**: graceful handling of missing CHECKLIST.md, unfilled `<YYYY-MM-DD>` deadline placeholder, and projects with no commits yet
- **`docs/kit/plans/done/2026-05-28-harness-evaluation.md`**: Improvement 1 marked as implemented; last-evaluated date updated

**Why**: The start hook previously answered "where am I?" (branch, plans) but not "how far along am I?" or "what's my time pressure?". Adding CHECKLIST % and days-to-deadline converts a manual Procedure 5 (`cadence.sh`) lookup into automatic session context — strengthening the **Verify** principle without any user action.

### Five-principle coverage after v1.3

| Principle | v1.2 | v1.3 addition |
|---|---|---|
| **Constrain** | Pre-commit hook gates 1–5 | (no change) |
| **Inform** | Start hook + skills + exec-plans + subagent map | (no change) |
| **Verify** | Cadence + quality grades + PostToolUse lint + subagent map | Start hook now auto-surfaces CHECKLIST %, deadline, last commit — no manual trigger needed |
| **Correct** | Stop hook + kit-improve + Proc 8 Step 13 | (no change) |
| **Human in loop** | All correctves advisory | Preserved — injected context is read-only; no actions taken |

---

## v1.2 — Proc 8 harness gap analysis
*Date: 2026-05-27*

Connected code review findings to the harness self-improvement loop, based on the **Sensors (Feedback Controls)** concept from Martin Fowler's harness engineering article:

> *"Sensors observe post-action outputs and enable self-correction. The goal is not to fix this instance — it's to prevent the next one."*
> — [Martin Fowler — Harness Engineering for Coding Agents](https://martinfowler.com/articles/harness-engineering.html)

- **Proc 8 Step 13** (`proc-8-code-review.md`): after the 11 review dimensions, identifies systemic findings (same pattern in 2+ files, or CLAUDE.md rule with no hook enforcement) and classifies them as 📋 CLAUDE.md gap or 🔧 Hook gap — surfaced as kit-improve candidates
- **Output format**: added `── Harness gaps ──` section (omitted when none found); AI offers to trigger kit-improve if gaps are present
- **Output rules**: "Harness gaps are separate from code findings — they go to kit-improve, not the user's fix list"
- **`.claude/skills/code-review.md`**: fixed dimension count (10 → 11); added Step 13 description
- **`CLAUDE.md` Proc 8 description**: updated to mention harness gap output
- **`docs/kit/HARNESS.md` Correct principle**: added "Proc 8 Step 13 → kit-improve" to coverage table

**Why**: Proc 8 findings previously ended at the review session. Step 13 closes the loop — recurring patterns discovered in review become permanent harness improvements rather than being rediscovered each cycle.

### Five-principle coverage after v1.2

| Principle | v1.1 | v1.2 addition |
|---|---|---|
| **Constrain** | Pre-commit hook gates 1–5 | (no change) |
| **Inform** | Start hook + skills + exec-plans + subagent map | (no change) |
| **Verify** | Cadence + quality grades + PostToolUse lint + subagent map | (no change) |
| **Correct** | Stop hook + kit-improve + doc-gardening | Proc 8 Step 13 — code review findings feed harness improvement loop |
| **Human in loop** | All correctves advisory | Preserved — harness gaps surfaced for user decision, never auto-applied |

---

## v1.1 — Proc 8 subagent map
*Date: 2026-05-25*

Separated exploration from editing in large-scope code reviews, based on the **Tool-call offloading / subagent exploration** pattern from Addy Osmani's agent harness engineering article:

> *"A read-only subagent maps the subsystem first; the main agent then reviews with the full picture instead of reading blind."*
> — [Addy Osmani — Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/)

- **`code-review-mapper` subagent** (`.claude/agents/code-review-mapper.md`): read-only agent that maps exports, imports, call sites, and anomalies across the blast-radius file list, then writes a compact summary to `/tmp/review-map.md`
- **Proc 8 Step 0b**: when blast-radius > 10 files, spawns `code-review-mapper` before the main review begins — main agent reads the map instead of opening all files raw
- **`.claude/skills/code-review.md`**: updated to mention the subagent path for large-scope reviews
- **Out-of-scope update**: "Multi-agent orchestration" row in HARNESS.md narrowed — full orchestration remains rejected; single read-only subagent in Proc 8 is the approved exception

**Why narrow**: single subagent, sequential handoff, read-only, no infrastructure required — not a full orchestration pipeline.

### Five-principle coverage after v1.1

| Principle | v1.0 | v1.1 addition |
|---|---|---|
| **Constrain** | Pre-commit hook gates 1–5 | (no change) |
| **Inform** | Start hook + skills + exec-plans | Subagent map gives main agent full subsystem picture before reviewing |
| **Verify** | Cadence + quality grades + PostToolUse lint | Subagent independently maps call graph — cross-check against main agent's assumptions |
| **Correct** | Stop hook + kit-improve | (no change) |
| **Human in loop** | All correctves advisory | Preserved — subagent only reads; main agent presents findings; user decides |

---

## v1.0 — Self-improving loop
*Date: 2026-05-25*

Shifted hooks from pure guard-rails to active self-improvement, based on the insight:
> *"Hooks make the setup self-improving. A stop hook can reflect on what happened during a session and propose CLAUDE.md updates while the context is fresh."*
> — Source: Anthropic internal documentation on Claude Code session hooks *(URL not recorded — verify if re-citing)*

Prior versions (v0.7–v0.9) used only `PreToolUse` hooks to block dangerous commands.
v1.0 adds two new hook roles and a full improvement feedback loop:

- **Stop hook** (`scripts/hooks/session-reflect.sh`): On session end with kit-file edits, generates a structured improvement proposal in `docs/kit/improvements/pending/`. Scope-guarded by `docs/kit/improvements/` presence; reads `/tmp/cc-files-all.txt` filtered by current session_id.
- **Start hook** (`scripts/hooks/session-start.sh`): On first user message per session, injects current branch, active exec-plans, and pending improvement count as system context
- **PostToolUse lint** (`scripts/hooks/post-edit-lint.sh`): After Write/Edit to src/ files, runs fast language-specific lint and surfaces errors immediately (non-blocking advisory; gate 1 in pre-commit remains authoritative)
- **kit-improve** (`docs/kit/improvements/kit-improve.md`): Structured review process for pending proposals — read, decide (accept/reject/defer), apply, log, archive
- **Kit improvements staging** (`docs/kit/improvements/pending|accepted|rejected/`): Three-state artifact lifecycle for improvement proposals
- **Kit history** (`docs/kit/HISTORY.md`): This document — authoritative log of what changed and why

### Structural: `docs/kit/` separation

To make the kit-vs-project boundary self-evident, kit-meta documents moved into a dedicated `docs/kit/` directory:

| Before | After |
|---|---|
| `docs/HARNESS.md` | `docs/kit/HARNESS.md` |
| `docs/OVERVIEW.md` | `docs/kit/OVERVIEW.md` |
| `docs/tools.md` | `docs/kit/TOOLS.md` |
| `docs/kit-history.md` | `docs/kit/HISTORY.md` (prefix dropped — redundant inside `kit/`) |
| `docs/kit-improvements/` | `docs/kit/improvements/` (same) |
| `docs/procedures/proc-10-kit-improve.md` | `docs/kit/improvements/kit-improve.md` (no longer a numbered project procedure) |

Project documents (SPEC / PLAN / DESIGN / PROCESS / CHECKLIST / GUIDE / exec-plans / procedures) stayed at `docs/` root. Naming convention: numbered `proc-N-*.md` reserved for project procedures (1–9); kit workflows use descriptive names without numbers.

### Five-principle coverage after v1.0

| Principle | v0.9 | v1.0 addition |
|---|---|---|
| **Constrain** | Pre-commit hook gates 1–5 | (no change) |
| **Inform** | SPEC origin + skills + exec-plans + core beliefs | Start hook injects live branch/plan context every session |
| **Verify** | Cadence + quality grades + self-review | PostToolUse lint surfaces errors before pre-commit |
| **Correct** | Procedure 7 doc-gardening + Proc 1 auto-corrective | Stop hook + kit-improve close the CLAUDE.md improvement loop |
| **Human in loop** | All correctves advisory | Preserved — kit-improve requires explicit user approval for every change |

---

## v0.9 — Active observability
*Date: pre-history*

Added proactive detection and per-feature state tracking:

- **Exec-plan templates** (`docs/exec-plans/active/`) — explicit "what am I working on now" artifact; agent no longer re-derives context each turn
- **Quality grades table** in CHECKLIST.md — one-glance domain health map surfaced by cadence
- **Core beliefs** in DESIGN.md — permanent operating principles applied to every ADR
- **Procedure 7: doc-gardening** — proactive stale-doc detection between commits (not only at commit time)
- **Procedure 4: self-review pass** — pre-ship review includes a silent diff-against-criteria pass before score simulation

---

## v0.8 — Mechanical enforcement
*Date: pre-history*

Closed the gap between "Claude knows the rules" and "the rules are mechanically enforced":

- **Pre-commit hook** (`.githooks/pre-commit`): Gates 1–5 (lint / test / build / type-escape / debug-log) fire on every `git commit`, regardless of whether the user went through chat
- **SPEC origin field** in DESIGN.md ADRs — every ADR traces back to a SPEC clause
- **`.claude/skills/` SKILL.md packaging** — procedures auto-discoverable by non-Claude agents (Codex, Cursor, Aider)
- **Procedure 5 (Cadence)** + `scripts/cadence.sh` — 8-line progress digest on demand
- **Auto-corrective in Procedure 1 step 3b** — detects README ↔ package.json script drift and proposes a one-command fix

---

## Origin (v0.1 – v0.6)

Earlier iterations under different names — not part of the current craft-kit identity but preserved here for traceability (see `git log` for detail):

| Version | What changed |
|---|---|
| v0.1.0 | `recruit-kit` — initial cookiecutter for recruitment assignments |
| v0.1.1 | post-review fixes |
| v0.2.0–0.2.1 | address deferred review issues, add walkthrough.md |
| v0.3.0 | translate all docs/templates/prompts to English |
| v0.4.0 | rename `recruit-kit` → `takehome-kit` |
| v0.5, v0.6 | (skipped — no releases) |

v0.7 is the major redesign that established the current shape (clone-and-edit template). Later, `takehome-kit` was renamed to `craft-kit` (kit identity, not a version bump).

---

## v0.7 — Baseline
*Date: pre-history*

Core kit established:
- `CLAUDE.md` with coding rules, 7-gate DoD, absolute prohibitions
- Procedures 1–4: DoD, §N trace, SPEC drift, pre-ship review
- Workflow phases A–E (Doc alignment → Ship)
- SPEC-immutable rule, user-approval-before-commit invariant
