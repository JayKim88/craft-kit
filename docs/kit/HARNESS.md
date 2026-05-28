# Harness Engineering — Design of craft-kit

> Why this kit is shaped the way it is, mapped to the *agent harness engineering* discipline.
> References: [OpenAI — Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/) · [Addy Osmani — Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/).
> For version history, see [HISTORY.md](HISTORY.md).

---

## One-line core

> **"AI conscience" → "mechanical enforcement + multi-vendor reach + active observability"**. If the user forgets, if the AI gets lazy, git refuses. Procedures travel across vendors. Progress is one keystroke away.

---

## Framework

In OpenAI's framing, **Agent = Model + Harness**. The harness is everything around the model — guides, sensors, data context, tools, memory, scaffolding. Five principles:

| # | Principle | Meaning |
|---|---|---|
| 1 | **Constrain** | Stop unwanted outputs before they occur |
| 2 | **Inform** | Tell the agent what it should do and where to find the truth |
| 3 | **Verify** | Observe and validate agent behavior |
| 4 | **Correct** | Detect violations and trigger a response |
| 5 | **Human in loop** | Keep humans at high-stakes decision points |

---

## Component 1 — Pre-commit hook (`.githooks/pre-commit`)

### How it works

When the user runs `git commit`, git invokes the hook automatically:

```
1. Detect docs-only commit (staged paths all under docs/, *.md at root, .gitignore, LICENSE,
   .githooks/, scripts/, .claude/skills/) → if so, skip gates 1-3
2. Detect stack from root files (package.json / pyproject.toml / Cargo.toml / go.mod /
   pom.xml / build.gradle*) → STACK ∈ {node, python, rust, go, java, none}
3. Gates 1-3: per-stack lint / test / build
4. Gates 4-5: language-specific grep of STAGED BLOBS (git show :$f), not the working tree
   - Type-escape patterns:    `: any`, `cast(`, `unsafe`, `@SuppressWarnings`
   - Debug-log patterns:      `console.log`, `print(`, `dbg!`, `fmt.Println`, `System.out.println`
   - `// allow:` or `# allow:` comment permits a known exception
5. On any failure: exit non-zero with file:line surfaced → git rejects the commit
6. Bypass: SKIP_HOOK=1 git commit ...   (justify in commit body — NEVER --no-verify)
```

Activation is opt-in: the bootstrap adds `git config core.hooksPath .githooks` once. Git refuses to run hooks committed by anyone else without this explicit consent — a security feature of git that we respect.

### The problem it solves

| Without this | With this |
|---|---|
| AI agent had to *consciously* run Procedure 1 | git enforces gates 1-5 mechanically |
| User typing `git commit` directly (bypassing chat) skipped all verification | Hook fires regardless of how commit was triggered |
| Working-tree debug logs could slip through if staged content was clean | Hook reads `git show :$f` — staged blob only |

### Why it's good (Principle #1: Constrain)

1. **Preventive control** — block violations before they reach the repo. Cheaper than discovery after.
2. **Stack-aware = tech-neutral** — one hook for Node / Python / Rust / Go / Java. No fork per stack.
3. **Docs-only auto-skip = zero Phase A friction** — `chore: bootstrap` and `docs:` commits don't pay the lint/test/build cost.
4. **Explicit `SKIP_HOOK=1` bypass = audit-trail safety hatch** — unlike `--no-verify` (silent), this leaves a clear signal in the commit body.

### Trade-offs

- Windows users on Git Bash work, but BSD-only commands (`date -j -f` in cadence.sh) fall back to GNU `date`. Hook fails open if neither is present.
- If a user never runs `git config core.hooksPath .githooks`, the hook is dead weight. Mitigated: README bootstrap makes this Step 5.

---

## Component 2 — SPEC origin field in DESIGN.md ADRs

### How it works

Every ADR template starts with a mandatory **SPEC origin** field:

```markdown
### ADR-001: <decision title>

**SPEC origin**: `docs/SPEC.md §"Implementation scope" L34 — "must persist across page reloads"`

**Context**: ...
**Options**: ...
**Decision**: ...
**Rationale**: ...
**Trade-off**: ...
```

If the decision is not derived from a SPEC clause, the author writes `Inferred — no direct SPEC clause` and explains the inference in Rationale.

Procedure 4 (pre-ship review) counts `**SPEC origin**:` occurrences vs `### ADR-` headings; any gap is flagged as a critical issue.

### The problem it solves

| Without this | With this |
|---|---|
| ADRs could end with "Decision: X, Rationale: Y" — disconnected from SPEC | Every decision is one citation away from its SPEC origin |
| Reader's question "where in SPEC?" had no auto-answer | `grep "**SPEC origin**:" docs/DESIGN.md` answers it |
| SPEC changes had no automatic impact map | SPEC change region → grep ADRs for that §section → list of affected decisions |

### Why it's good (Principle #2: Inform — data context provenance)

1. **Documentation signal**: "this author distinguishes assumptions from facts".
2. **`Inferred — no direct SPEC clause` is itself a positive signal** — demonstrates metacognition ("I know this is inferred").
3. **Couples with Procedure 3 (SPEC drift check)**: when SPEC changes, the citation field tells you exactly which ADRs to revisit.

### Trade-offs

- ADR writing costs one more line per record. Evaluators prefer the cost.
- For sparse SPEC documents (criteria-only), most ADRs may end up as `Inferred`. Still better than silent inference.

---

## Component 3 — `.claude/skills/` SKILL.md packaging

### How it works

`SKILL.md` files in `.claude/skills/` each declare trigger keywords in frontmatter:

```markdown
---
name: cadence
description: Read-only progress digest — commits today, §N distribution, CHECKLIST progress, days to deadline.
triggers:
  - "어디까지 왔어"
  - "cadence"
  - "progress check"
  - "진행 상황"
---

# Cadence

Run [CLAUDE.md "Procedure 5 — Cadence check"](../../CLAUDE.md).
```

The body is ~5 lines pointing back to CLAUDE.md. Skills do not duplicate procedure content — they expose trigger keywords to compatible agents that auto-discover SKILL.md files (Codex, Cursor, Aider, Claude Code).

### The problem it solves

| Without this | With this |
|---|---|
| Procedures lived only in `CLAUDE.md` | Procedures are also auto-discoverable via the `SKILL.md` convention |
| Only Claude Code agents could route on the procedures | Codex / Cursor / Aider / other AGENTS.md-compatible agents now route too |
| Natural-language triggers were defined informally in prose | Triggers are declared explicitly in frontmatter — router precision improves |

### Why it's good (Principle #2: Inform — multi-vendor reach)

1. **AGENTS.md is a Linux-Foundation-stewarded convention** with ~60k OSS repos adopted (per vendor estimates). The kit sits on top of this standard.
2. **Trigger precision** — each skill declares 5–7 keywords. The router matches a natural-language phrase to one specific procedure.
3. **Pointer-not-duplication pattern** preserves CLAUDE.md as the single source of truth. Skill bodies never get out of sync.

### Trade-offs

- `.claude/skills/` is shared, version-controlled, and deliberately tracked. (Note: as of v1.0, `.claude/settings.json` is also tracked — see Component 6 below for the settings split.)

---

## Component 4 — Procedure 1 step 3b: narrow auto-corrective

### How it works

Inside Procedure 1 (DoD verification), after gates 6/6b/7, a single advisory check:

```
Conditions:
  (a) detected stack == node
  (b) staged diff modifies package.json's "scripts" block

Detection:
  - Parse renamed script entries (e.g., "dev" → "start")
  - Grep README.md "How to run" code fences for the OLD invocation
  - Match → propose ONE sed patch:

      sed -i.bak 's/npm run dev/npm run start/g' README.md && rm README.md.bak

Disposition (user picks):
  (a) include README fix in this commit
  (b) make a separate docs: commit before this one
  (c) ignore (record nothing)
```

**Never auto-apply.** Always present the proposed diff and require approval.

### The problem it solves

| Without this | With this |
|---|---|
| User renames `dev` → `start` in package.json. Forgets to update README. Reviewer runs `npm run dev` → command not found → bad first impression. | AI proactively spots the drift and offers a one-keystroke fix. |

### Why it's good (Principle #4: Correct — narrowly)

1. **Catches the most common stale-doc bug** automatically.
2. **Narrow scope (Node + package.json scripts + README only)** keeps false positives low.
3. **Advisory, not auto-apply** preserves user control (Principle #5: human-in-loop).

### Out of scope (intentionally)

Function renames, DB schema migrations, HTTP route renames, environment variable renames, test file renames — all rejected because false-positive risk exceeds value. The corrective stays inside its competence zone.

### Trade-offs

- Fires only inside chat-time Procedure 1. If the user runs `git commit` directly, the corrective never fires. The hook still runs gates 1-5, so silent failure is impossible — just no proactive doc patch.

---

## Component 5 — Procedure 5 (Cadence) + `scripts/cadence.sh`

### How it works

User says any of "어디까지 왔어" / "cadence" / "progress check" / "진행 상황" → AI runs `bash scripts/cadence.sh` → 8-line digest:

```
=== Cadence check (2026-05-13) ===
Commits today          : 3
Commits last 7 days    : 14

§N distribution (all-time):
  §2   18
  §3   9
  §5   3        ← under-covered

CHECKLIST              : 18 / 50 (36%) done, 32 open
Days to deadline       : 4  (deadline: 2026-05-17)
Likely current phase   : Phase C+ (last impl commit: feat(api): login [§2,§3])
```

The deadline is parsed from CLAUDE.md's "Project overview" line. macOS BSD `date -j -f` is tried first, then GNU `date -d` as fallback. If the placeholder `<YYYY-MM-DD>` is still present, the script prints `unknown` instead of crashing.

### The problem it solves

| Without this | With this |
|---|---|
| User estimated "are we on track?" by stale intuition | Objective 8-line digest in 1 second |
| §5 (Documentation) often had 0 commits silently until D-1 polish | `cadence` exposes coverage gaps continuously |
| Days-to-deadline awareness was vague | Explicit number in every cadence call |

### Why it's good (Principle #3: Verify — sensor)

1. **Observability is a core harness primitive.** Without a sensor for state, *correct* and *human-in-loop* both degrade.
2. **Read-only by design.** The procedure does NOT make recommendations. The numbers are shown; the user interprets. This preserves user agency.
3. **Trivial invocation cost** — under 1 second. Cheap enough to run every D-2 / D-1.

### Trade-offs

- Deadline parsing requires the user to fill the CLAUDE.md placeholder during Phase A (already a Phase A obligation).
- The "Likely current phase" heuristic is just that — a heuristic. Don't over-interpret.

---

## Component 6 — Exec-plan templates (`docs/exec-plans/`)

**Principle**: Inform

Per-feature execution plans in `docs/exec-plans/active/` give the agent an explicit "what am I working on now" artifact, eliminating context re-derivation each turn. Completed plans move to `completed/`; shortcuts land in `tech-debt-tracker.md`.

**Trade-off**: Only worth creating for complex features (3+ files, non-obvious logic). Simple CRUD steps don't need a plan file.

---

## Component 7 — Quality grades table (CHECKLIST.md §0)

**Principle**: Verify

A domain-level health table at the top of CHECKLIST.md (A–F grades per domain: correctness, architecture, types, etc.) gives a one-glance health map. Surfaced by Procedure 5 cadence output.

**Trade-off**: Grades are self-assessed — no automated grader. Accuracy depends on the user's honest judgment.

---

## Component 8 — Core beliefs (DESIGN.md §0)

**Principle**: Inform

Permanent operating principles codified at the top of DESIGN.md (agent legibility, boring tech, in-repo, etc.) applied to every ADR. Unlike coding rules (which govern implementation), core beliefs govern architectural decisions.

**Trade-off**: Beliefs can become stale if the project's constraints change. Revisit at Phase D polish.

---

## Component 9 — Procedure 7: doc-gardening

**Principle**: Correct

Proactive stale-doc scan triggered by "stale docs" / "가든" / "문서 점검". Compares recent `src/` diff against `docs/` content to surface likely drift. Report-only — no auto-edit.

**Trade-off**: False-positive risk when code changes are cosmetic. The user filters the report.

---

## Component 10 — Procedure 4: self-review pass

**Principle**: Verify

Pre-ship review (Procedure 4) includes a silent diff-against-criteria pass before producing the score simulation. The agent checks its own output against SPEC requirements before presenting the review.

**Trade-off**: Only as good as the SPEC coverage. A sparse SPEC produces a shallow self-review.

---

## Component 11 — Stop hook + session reflection

**Principle**: Correct

`scripts/hooks/session-reflect.sh` fires on every assistant turn end (`Stop` event). For sessions with kit-file edits, it writes a structured improvement proposal to `docs/kit/improvements/pending/YYYY-MM-DD.md`. Idempotent: same-day re-fires are no-ops.

```
Session with kit-file edits
       ↓
Stop hook → docs/kit/improvements/pending/YYYY-MM-DD.md
       ↓ (next session)
Start hook → "⚠ 1 improvement proposal pending"
       ↓ (user triggers kit-improve)
Review → Accept / Reject / Defer
       ↓ (Accept path)
Apply to CLAUDE.md → log in HISTORY.md → archive → commit
```

**Design decision — why Stop fires every turn**: Claude Code's `Stop` event fires at end of each assistant turn, not only at conversation close. Date-based filename makes re-fires idempotent; the proposal is written once.

**Trade-off**: Proposals are unfiltered — not every session produces a useful improvement. The kit-improve review gate is the quality filter.

---

## Component 12 — Start hook (dynamic context injection)

**Principle**: Inform

`scripts/hooks/session-start.sh` fires once per session (`UserPromptSubmit` event) and injects current branch, active exec-plans, pending improvement count, CHECKLIST %, days to deadline, and last commit summary as system context.

**Design decision — why once per session**: A session-ID marker file prevents repeated injection on every user message. Without it, context would be injected on every turn, making it noisy.

**Trade-off**: Requires session-ID to be available from the hook environment. Falls back to no-op if unavailable.

---

## Component 13 — PostToolUse lint advisory

**Principle**: Verify

`scripts/hooks/post-edit-lint.sh` fires after every Write/Edit to `src/` files and runs fast language-specific lint. Non-blocking (exit 0 always) — surfaces errors as an early signal without interrupting the implementation flow.

**Design decision — why non-blocking**: Blocking edit-time lint would interrupt flow for cosmetic warnings. The pre-commit hook (gates 1-3) is authoritative; this is early-warning only.

**Trade-off**: Advisory output can be ignored. The pre-commit hook is the hard gate.

---

## Component 14 — kit-improve + history

**Principle**: Correct

`docs/kit/improvements/kit-improve.md` closes the self-improvement loop: review pending proposals → accept/reject/defer → apply to CLAUDE.md → log in `HISTORY.md` → archive. Every accepted change requires explicit user approval.

**Trade-off**: Requires the user to actively trigger kit-improve. The Start hook nudges with the pending count, but follow-through is voluntary.

---

## Component 15 — code-review-mapper subagent (Proc 8 Step 0b)

**Principle**: Inform + Verify

`.claude/agents/code-review-mapper.md` is a read-only subagent spawned by Procedure 8 when blast-radius > 10 files. It maps exports, imports, call sites, and anomalies across the affected file list, writes a compact summary to `/tmp/review-map.md`, then stops. The main agent reviews using the map rather than opening all files raw.

**Why narrow, not full orchestration**: single subagent, sequential handoff, no file edits, no git writes — one `Agent` tool call, no infrastructure required.

**Trade-off**: Adds ~30–90 seconds per large-scope review. grep-based call-site detection misses dynamic dispatch.

---

## Component 16 — `.claude/settings` shared/local split

**Principle**: Inform (project-shared config) + Human in loop (user-local permissions stay local)

v1.0 introduced project-shared hooks (Stop / UserPromptSubmit / PostToolUse) that **must** be tracked in git so every cloner gets the same agent behavior. Pre-v1.0, `.claude/settings.json` was gitignored because it mixed user-specific permission allowlists with the only shared item at the time (PreToolUse Bash block).

Claude Code's two-file pattern resolves the conflict:

| File | Scope | Tracked | Contents |
|---|---|---|---|
| `.claude/settings.json` | Project-shared | ✅ tracked | `hooks` block only (PreToolUse Bash block + v1.0 Stop/UserPromptSubmit/PostToolUse) |
| `.claude/settings.local.json` | User-local | ❌ gitignored | `permissions.allow`, `permissions.additionalDirectories` — accumulate per user |

Claude Code automatically merges both at startup; `.local` overrides `.json`.

**Bootstrap implication**: cloning the kit now gives every user the same hook behavior immediately. No manual hook registration step required.

**Trade-off**: when Claude Code auto-records a newly approved permission, it can land in `settings.json` instead of `settings.local.json` depending on which exists. Maintainers should periodically move user-specific entries out of `settings.json` to keep the shared file hook-only.

---

## Current principle coverage

| Principle | How the kit implements it |
|---|---|
| **Constrain** | Absolute prohibitions in CLAUDE.md · Pre-commit hook gates 1–5 · `PreToolUse` hook blocks destructive commands |
| **Inform** | CLAUDE.md (rules SSOT) · SPEC origin field · `.claude/skills/` (multi-vendor) · Exec-plans (active task context) · Core beliefs (DESIGN.md §0) · Start hook (live context per session) · code-review-mapper map (large-scope reviews) |
| **Verify** | 7-gate DoD (Proc 1) · Cadence + quality grades (Proc 5) · Self-review pass (Proc 4) · PostToolUse lint (edit-time advisory) · code-review-mapper (independent call-graph map) · pre-commit-reviewer (independent Correctness + Security check per commit) |
| **Correct** | Auto-corrective (Proc 1 step 3b) · Doc-gardening (Proc 7) · Stop hook → kit-improve (CLAUDE.md feedback loop) · Proc 8 Step 13 harness gaps → kit-improve (recurring patterns → rules/hooks) |
| **Human in loop** | User approval required before every commit · All correctves advisory, never auto-apply · kit-improve requires explicit approval per accepted change |

---

## What the kit deliberately does NOT do

### Permanent rejections

| Rejected pattern | Why |
|---|---|
| Auto-commit (bypassing user approval) | Violates Principle #5 (human-in-loop). Absolute prohibition. |
| Drift detector that auto-edits SPEC | Violates SPEC-immutable rule |
| Broader auto-correctives (function renames, schema migrations) | False-positive risk > value |
| Skill marketplace external dependencies | Community-dependent, breaks the kit's single-source self-containment |

### Out of scope for 3–7 day projects

These patterns exist in production-scale harness engineering but are explicitly rejected because the 5-day timeline can't absorb the infrastructure cost:

| Rejected pattern | Why not applicable |
|---|---|
| Chrome DevTools Protocol wiring | Requires app to be bootable per-worktree + local browser automation setup |
| Local observability stack (Loki/Victoria) | Ephemeral per-worktree observability is a multi-day infrastructure investment |
| Layered domain architecture enforcement via custom linters | Too project-specific; the kit is stack-neutral |
| Background recurring garbage-collection agents | Requires persistent agent runtime; project sessions are ephemeral |
| Multi-agent PR review (full Ralph Wiggum loop) | Assumes PR queue, CI triggers, and agent orchestration infrastructure |
| MCP server integration | Assumes user infrastructure; violates tech-neutrality |
| Multi-agent orchestration (Vera/Axel/etc. style) | Full orchestration pipelines don't fit 5-day scope; narrow single-subagent in Proc 8 is the approved exception |
| Production-scale thinking (1,500 PRs / ~100M LoC) | Kit targets 50–200 commits, 5k–20k LoC; different threat model |

---

## See also

- [`CLAUDE.md`](../../CLAUDE.md) — universal AI rules, DoD definition, and procedures 1–10
- [`README.md`](../../README.md) — user-facing bootstrap and usage
- [`docs/PROCESS.md`](../PROCESS.md) — implementation phase order
- [`docs/kit/HISTORY.md`](HISTORY.md) — version history and improvement log
- [OpenAI — Harness engineering](https://openai.com/index/harness-engineering/) — five-principle framework (Constrain/Inform/Verify/Correct/Human in loop)
- [Addy Osmani — Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/) — harness patterns and concept overview
- [agents.md](https://agents.md/) — the AGENTS.md / SKILL.md convention spec
- [awesome-harness-engineering](https://github.com/ai-boost/awesome-harness-engineering) — curated patterns
