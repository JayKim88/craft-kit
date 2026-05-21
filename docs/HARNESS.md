# Harness Engineering — Design of craft-kit

> Why this kit is shaped the way it is, mapped to OpenAI's *harness engineering* discipline.
> Reference: [OpenAI — Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/).
> **Version history**: v0.8 — pre-commit hook, SPEC origin, skills, auto-corrective, cadence. v0.9 — exec-plans, quality grades, core beliefs, doc-gardening, self-review.

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

craft-kit v0.7 already implemented ~70% of this implicitly. v0.8 closes the remaining gaps with five concrete additions.

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

| Before (v0.7) | After (v0.8) |
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

Every ADR template now starts with a mandatory **SPEC origin** field:

```markdown
### ADR-001: <decision title>

**SPEC origin**: `docs/SPEC.md §"Implementation scope" L34 — "must persist across page reloads"`

**Context**: ...
**Options**: ...
**Decision**: ...
**Rationale**: ...
**Trade-off**: ...
```

If the decision is not derived from a SPEC clause, the candidate writes `Inferred — no direct SPEC clause` and explains the inference in Rationale.

Procedure 4 (pre-submission review) was extended in v0.8 to count `**SPEC origin**:` occurrences vs `### ADR-` headings; any gap is flagged as a critical Documentation-rubric issue.

### The problem it solves

| Before | After |
|---|---|
| ADRs could end with "Decision: X, Rationale: Y" — disconnected from SPEC | Every decision is one citation away from its SPEC origin |
| Reviewer's question "where in SPEC?" had no auto-answer | `grep "**SPEC origin**:" docs/DESIGN.md` answers it |
| SPEC changes had no automatic impact map | SPEC change region → grep ADRs for that §section → list of affected decisions |

### Why it's good (Principle #2: Inform — data context provenance)

1. **Reviewer signal** for the Documentation rubric: "this candidate distinguishes assumptions from facts".
2. **`Inferred — no direct SPEC clause` is itself a positive signal** — demonstrates metacognition ("I know this is inferred").
3. **Couples with Procedure 3 (SPEC drift check)**: when SPEC changes, the citation field tells you exactly which ADRs to revisit.

### Trade-offs

- ADR writing costs one more line per record. Reviewers prefer the cost.
- For companies whose SPEC body is sparse (rubric-only), most ADRs may end up as `Inferred`. Still better than silent inference.

---

## Component 3 — `.claude/skills/` SKILL.md packaging

### How it works

Six `SKILL.md` files in `.claude/skills/`. Each has frontmatter declaring trigger keywords:

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

The body is ~5 lines, pointing back to CLAUDE.md. Skills do not duplicate procedure content — they expose trigger keywords to compatible agents that auto-discover SKILL.md files (Codex, Cursor, Aider, Claude Code).

### The problem it solves

| Before | After |
|---|---|
| Procedures lived only in `CLAUDE.md` | Procedures are also auto-discoverable via the `SKILL.md` convention |
| Only Claude Code agents could route on the procedures | Codex / Cursor / Aider / other AGENTS.md-compatible agents now route too |
| Natural-language triggers were defined informally in CLAUDE.md prose | Triggers are declared explicitly in frontmatter — router precision improves |

### Why it's good (Principle #2: Inform — multi-vendor reach)

1. **AGENTS.md is a Linux-Foundation-stewarded convention** with ~60k OSS repos adopted (per vendor estimates). The kit sits on top of this standard.
2. **Trigger precision** — each skill declares 5–7 keywords. The router matches a natural-language phrase to one specific procedure.
3. **Pointer-not-duplication pattern** preserves CLAUDE.md as the single source of truth. Skill bodies never get out of sync.

### Trade-offs

- v0.7 deleted `.claude/` entirely. v0.8 partially reverses this. Different concern, though — v0.7 was about `.claude/settings.json` (per-user, never-commit). v0.8's `.claude/skills/` is shared, version-controlled, deliberately tracked. The `.gitignore` continues to ignore settings; skills are tracked.

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

| Before | After |
|---|---|
| User renames `dev` → `start` in package.json. Forgets to update README. Reviewer runs `npm run dev` → command not found → bad first impression. | AI proactively spots the drift and offers a one-keystroke fix. |

### Why it's good (Principle #4: Correct — narrowly)

1. **Catches the most common stale-doc bug** automatically.
2. **Narrow scope (Node + package.json scripts + README only)** keeps false positives low.
3. **Advisory, not auto-apply** preserves user control (Principle #5: human-in-loop).

### Out of scope (intentionally)

Function renames, DB schema migrations, HTTP route renames, environment variable renames, test file renames — all rejected because false-positive risk exceeds value. The corrective stays inside its competence zone.

### Trade-offs

- The corrective fires inside chat-time Procedure 1. If the user runs `git commit` directly (bypassing the chat assistant), the corrective never fires. The hook still runs gates 1-5, so silent failure is impossible — just no proactive doc patch.

---

## Component 5 — Procedure 5 (Cadence) + `scripts/cadence.sh`

### How it works

User says any of "어디까지 왔어" / "cadence" / "progress check" / "진행 상황" → AI runs `bash scripts/cadence.sh` (or implements its logic inline if the script is missing) → 8-line digest:

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

The deadline is parsed from CLAUDE.md's "Assignment overview" line. macOS BSD `date -j -f` is tried first, then GNU `date -d` as fallback. If the placeholder `<YYYY-MM-DD>` is still present, the script prints `unknown` instead of crashing.

### The problem it solves

| Before | After |
|---|---|
| User estimated "are we on track?" by stale intuition | Objective 8-line digest in 1 second |
| §5 (Documentation) often had 0 commits silently until D-1 polish | `cadence` exposes coverage gaps continuously |
| Days-to-deadline awareness was vague | Explicit number in every cadence call |

### Why it's good (Principle #3: Verify — sensor)

1. **Observability is a core harness primitive.** Without a sensor for state, *correct* and *human-in-loop* both degrade.
2. **Read-only by design.** The procedure does NOT make recommendations. The numbers are shown; the user interprets. This preserves user agency.
3. **Trivial invocation cost** — under 1 second. Cheap enough to run every D-2 / D-1.

### Trade-offs

- Deadline parsing requires the user to fill the CLAUDE.md placeholder during Phase A (this is already a Phase A obligation, so not a new burden).
- The "Likely current phase" heuristic is just that — a heuristic. Don't over-interpret.

---

## Supporting changes

| Change | Purpose |
|---|---|
| **README.md bootstrap** gains `git config core.hooksPath .githooks` | Activates the hook with explicit user consent (git refuses silent hook activation by design) |
| **CLAUDE.md edits M1–M5 + R6** | Wires v0.8 capabilities into the SSOT that the AI agent reads as context |
| **docs/CHECKLIST.md Phase B** gains 4 verification items | Phase B (toolchain lock) now includes hook + cadence + skills smoke tests |
| **.gitignore comment** clarifying `.claude/skills/` is tracked | Prevents future confusion ("should skill files be committed?") |

---

## Scenarios — v0.7 vs v0.8

### Scenario A: AI forgets to run DoD verification

| Stage | v0.7 | v0.8 |
|---|---|---|
| Pre-commit | AI didn't autonomously trigger Procedure 1 | Hook fires automatically on `git commit` |
| Bad code (`console.log`) | Slips through → reviewer catches → −1 to −3 pts | Gate 5 blocks → user fixes and retries |

### Scenario B: User runs `git commit -m "..."` directly (bypassing chat)

| Stage | v0.7 | v0.8 |
|---|---|---|
| Verification | None — procedures lived only in chat | Hook runs regardless of how commit was triggered |

### Scenario C: Company updates SPEC mid-project

| Stage | v0.7 | v0.8 |
|---|---|---|
| Identifying affected ADRs | Manual — re-read every ADR vs SPEC diff | `grep "**SPEC origin**:" docs/DESIGN.md` extracts every ADR with the affected §section |

### Scenario D: D-2 self-assessment

| Stage | v0.7 | v0.8 |
|---|---|---|
| Progress check | `git log | wc -l` + manual checklist scan + days-to-deadline mental math | `cadence` → one 8-line digest |

### Scenario E: Non-Claude user clones the kit

| Stage | v0.7 | v0.8 |
|---|---|---|
| Procedure auto-discovery | Claude Code only | Codex / Cursor / Aider auto-route on trigger keywords via SKILL.md |

---

## Five-principle coverage map

| Principle | v0.7 coverage | v0.8 addition |
|---|---|---|
| **Constrain** | Absolute prohibitions (don't modify SPEC, don't commit without approval) | Pre-commit hook enforces gates 1-5 mechanically |
| **Inform** | CLAUDE.md / AGENTS.md / HINT comments | SPEC origin field (provenance) + `.claude/skills/` (multi-vendor) |
| **Verify** | 7-gate DoD + Procedures 1 / 2 / 3 (chat-time) | Procedure 5 (cadence sensor) |
| **Correct** | Gate 6b doc-drift heuristic | Procedure 1 step 3b auto-corrective (advisory) |
| **Human in loop** | User commit approval mandatory | Preserved — auto-corrective is advisory, never applies without consent |

All five principles covered. None weakened.

---

---

## v0.9 additions

Five new components derived from OpenAI's harness engineering article.

### Context — v0.8 gaps that motivated v0.9

| Pattern (OpenAI article) | v0.8 status | Gap |
|---|---|---|
| Execution plans as versioned artifacts | PROCESS.md covers phase order | No active/completed separation; no decision log per task |
| Quality grades per domain | CHECKLIST.md tracks `[x]`/`[ ]` only | No domain-level health scores visible at a glance |
| Core beliefs document | Implied in coding rules | Never codified as explicit, permanent design principles |
| Doc-gardening scan | Gate 6b fires at commit time only | No proactive stale-doc detection between commits |
| Short entry point (~100 lines) | CLAUDE.md was ~450 lines | Excess context load every turn |
| Active/completed plan split | Flat PLAN.md only | No per-feature state tracking; agent re-derives context each turn |

### Components

| Component | File(s) changed | Principle |
|---|---|---|
| **Exec-plan templates** (`docs/exec-plans/`) | New dir: `active/TEMPLATE.md`, `completed/`, `tech-debt-tracker.md` | **Inform** — agent gets explicit "what am I working on now" artifact; no context re-derivation per turn |
| **Quality grades table** (CHECKLIST.md §0) | `docs/CHECKLIST.md` | **Verify** — one-glance domain health map; surfaced by Procedure 5 cadence |
| **Core beliefs** (DESIGN.md §0) | `docs/DESIGN.md` | **Inform** — permanent operating principles (agent legibility, boring tech, in-repo) applied to every ADR |
| **Procedure 7: doc-gardening** | `CLAUDE.md` (new procedure) | **Correct** — proactive stale-doc detection between commits, not just at commit time |
| **Procedure 4: self-review pass** | `CLAUDE.md` (Procedure 4 extension) | **Verify** — pre-submission review now includes a silent diff-against-rubric pass before producing the score simulation |

### Principle coverage after v0.9

| Principle | v0.8 | v0.9 addition |
|---|---|---|
| **Constrain** | Pre-commit hook gates 1-5 | (no change) |
| **Inform** | SPEC origin field + `.claude/skills/` | Core beliefs in DESIGN.md + exec-plan active artifacts |
| **Verify** | Procedure 5 cadence sensor | Quality grades in cadence output + self-review pass in Procedure 4 |
| **Correct** | Procedure 1 step 3b (README↔scripts) | Procedure 7 doc-gardening (broader stale-doc scan) + exec-plan step sync in Gate 6 |
| **Human in loop** | All correctves advisory | Preserved — Procedure 7 never auto-edits |

---

## What the kit deliberately does NOT do

### Permanent rejections (any version)

| Rejected pattern | Why |
|---|---|
| Auto-commit (bypassing user approval) | Violates Principle #5 (human-in-loop). Absolute prohibition. |
| Drift detector that auto-edits SPEC | Violates SPEC-immutable rule |
| Broader auto-correctives (function renames, schema migrations) | False-positive risk > value |
| Skill marketplace external dependencies | Community-dependent, breaks the kit's single-source self-containment |

### Out of scope for 3–7 day projects (from OpenAI article)

These patterns exist in production-scale harness engineering but are explicitly rejected because the 5-day timeline can't absorb the infrastructure cost:

| Rejected pattern | Why not applicable |
|---|---|
| Chrome DevTools Protocol wiring | Requires app to be bootable per-worktree + local browser automation setup |
| Local observability stack (Loki/Victoria) | Ephemeral per-worktree observability is a multi-day infrastructure investment |
| Layered domain architecture enforcement via custom linters | Too project-specific; the kit is stack-neutral |
| Background recurring garbage-collection agents | Requires persistent agent runtime; project sessions are ephemeral |
| Multi-agent PR review (full Ralph Wiggum loop) | Assumes PR queue, CI triggers, and agent orchestration infrastructure |
| MCP server integration | Assumes user infrastructure; violates tech-neutrality |
| Multi-agent orchestration (Vera/Axel/etc. style) | 5-day projects don't warrant agent-team overhead |
| Production-scale thinking (1,500 PRs / ~100M LoC) | Kit targets 50–200 commits, 5k–20k LoC; different threat model |

---

## See also

- [`CLAUDE.md`](../CLAUDE.md) — universal AI rules, DoD definition, and the 5 procedures
- [`README.md`](../README.md) — user-facing bootstrap and usage
- [`docs/PROCESS.md`](PROCESS.md) — implementation phase order
- [OpenAI — Harness engineering](https://openai.com/index/harness-engineering/) — the upstream concept
- [agents.md](https://agents.md/) — the AGENTS.md / SKILL.md convention spec
- [awesome-harness-engineering](https://github.com/ai-boost/awesome-harness-engineering) — curated patterns
