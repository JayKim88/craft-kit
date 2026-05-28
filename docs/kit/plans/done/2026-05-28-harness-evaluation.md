# craft-kit — Harness Engineering Evaluation

> Periodic self-assessment against AI harness engineering principles.
> Framework: OpenAI 5-principle (Constrain/Inform/Verify/Correct/Human in loop)
>             + Fowler Feedforward/Feedback + Claude Code Architecture layers.
> References: [OpenAI](https://openai.com/index/harness-engineering/) ·
>             [Addy Osmani](https://addyosmani.com/blog/agent-harness-engineering/) ·
>             [Martin Fowler](https://martinfowler.com/articles/harness-engineering.html)

---

## One-line verdict

> craft-kit is a strong Feedforward harness with weak Feedback — it guides the AI well before action, but verifies outcomes poorly after.

---

## Domain scores

### Feedforward (Guides) — A−

**[FACT]** Implemented:
- CLAUDE.md: comprehensive coding rules with named conditions, guard clauses, boolean naming, etc.
- SPEC origin field: every ADR traces back to a SPEC clause
- Skills on-demand: `.claude/skills/` loads procedure content only when triggered
- HARD-GATE: blocks `src/` until 5 documents are filled

**[FACT] Gap — HARD-GATE validates presence, not quality.**
A SPEC.md with one sentence passes the gate identically to a complete spec.
This creates an incentive to fill documents minimally to unblock coding.

---

### Computational Feedback (Sensors) — B

**[FACT]** Implemented:
- Pre-commit hook: gates 1–5 (lint / test / build / type-escape / debug-log) — deterministic, stack-auto
- PostToolUse lint: early warning immediately after each file edit

**[FACT] Gap — architecture rules have no computational sensor.**
CLAUDE.md rule: `"domain logic must live in lib/<domain>/"`.
Pre-commit grep: none.
Enforcement path: Proc 8 manual review only — skippable under deadline pressure.

```
Rule exists:  CLAUDE.md "Domain logic isolated"
Sensor:       ✗  (no grep in pre-commit or PostToolUse)
Catch path:   Proc 8 only — manually triggered
```

---

### Inferential Feedback (LLM sensors) — C+

| Sensor | Trigger | Problem |
|---|---|---|
| Proc 4 pre-ship review | Manual ("final review") | Runs once at Phase E |
| Proc 8 code review | Manual ("코드 리뷰해줘") | Skippable — user must ask |
| Proc 9 security audit | Manual ("보안 감사") | Skippable — user must ask |

**[OPINION]** All inferential sensors depend on explicit user trigger.
Deadline pressure peaks exactly when skipping is most tempting.
A harness that relies on user discipline for quality checks is weaker than one that enforces them structurally.

---

### Behaviour Harness — C−

**[FACT]** What exists:
- Gate 2 (Tests green) — runs existing test suite at commit time
- CHECKLIST.md `[§N]` — tracks "implemented" status per requirement

**[FACT]** What is absent:
- No verification that code behaves correctly at runtime
- No screenshot / API response / end-to-end check
- CHECKLIST `[x]` means "coded", not "working"

Gate 2 verifies that existing tests pass, not that the implementation satisfies requirements.
This is the hardest harness category (Fowler acknowledges it) — craft-kit has a floor but no ceiling here.

**Grade depends on project setup**: C− when a test suite exists (Gate 2 is a real behavioural check); closer to D for projects without tests, where Gate 2 prints `(skipped: not configured)`.

---

### Self-improvement Loop — C

**[FACT]** The Stop hook → pending/ → kit-improve loop has structural latency:

```
Session 3: pattern found in code review
    ↓
pending/ file generated (Stop hook)
    ↓  ← same pattern can recur during this gap
Session 5: user triggers kit-improve
    ↓
CLAUDE.md rule added
```

**[FACT] Larger gap**: Stop hook fires only when **kit files** are edited, not `src/`.
During Phase C (the primary 30–60 commit implementation cycle), src/ files are edited,
kit files are not → Stop hook is silent throughout the most active project phase.
Patterns that emerge during coding accumulate without feedback.

---

### Procedure count — potential overload [OPINION]

10 procedure entries with distinct natural-language triggers:

```
"어디까지 왔어"  → Proc 5 (cadence)
"어디 부족"      → Proc 2 (§N trace)
"리뷰"           → Proc 4 (pre-ship)
"코드 리뷰해줘"  → Proc 8 (code review)
```

Procedures are on-demand and phase-contextual, which mitigates this — users typically need
2–3 procedures per phase, not all 10 simultaneously. The concern is real but may be
overstated: the trigger phrases are in Korean and English, reducing accidental collisions.

---

## 5-principle scorecard [ESTIMATE]

| Principle | Score | Evidence |
|---|---|---|
| **Constrain** | A | Pre-commit hook + HARD-GATE + absolute prohibitions in CLAUDE.md |
| **Inform** | A− | CLAUDE.md + Skills strong. Procedure count adds some cognitive load. |
| **Verify** | C+ | Computational sensors automatic; inferential sensors entirely manual |
| **Correct** | C+ | Auto-corrective scope narrow (package.json scripts only). Proc 8 Step 13 newly added. |
| **Human in loop** | A | No auto-commit; all correctves advisory; kit-improve requires explicit approval |

---

## Claude Code architecture layer utilisation

| Layer | Utilisation | Notes |
|---|---|---|
| Permission Gate | ✅ Full | settings.json + settings.local.json |
| Skill Registry | ✅ Full | 9 SKILL.md files |
| Memory Store | ✅ Partial | Auto-memory active; cross-session via project memory/ |
| Event Bus (Hooks) | ✅ Full | Stop / UserPromptSubmit / PostToolUse / PreToolUse |
| Task Graph | ❌ Unused | exec-plans (markdown) substitute |
| Multi-Agent Layer | △ Minimal | code-review-mapper only (Proc 8 Step 0b) |
| MCP Runtime | △ Recommended | tools.md recommends; kit does not configure |
| Worktree Isolator | ❌ Unused | — |

---

## Realistic improvement candidates

Ordered by impact / effort ratio:

**1. Start hook: auto-inject cadence metrics** ✅ Implemented (2026-05-28)
~~Currently injects: branch, active exec-plans, pending count.~~
~~Missing: CHECKLIST %, days to deadline, last commit summary.~~
Now injects: branch, active plans, pending count, CHECKLIST %, days to deadline, last commit summary.
Effect: Verify principle strengthened without any user action.

**2. Phase C Stop hook expansion** ✅ Implemented differently (2026-05-28)
~~Proposed: Stop hook expansion for src/ edits.~~
Implemented as: `pre-commit-reviewer` subagent in Proc 1 Step 0b — independent
fresh-context agent checks Correctness vs SPEC + Security before every commit.
Rationale: per-commit independent review is stronger than per-session lightweight checklist.

**3. Architecture fitness grep** ✅ Implemented (2026-05-28)
Gate 5b added to `.githooks/pre-commit`: staged files in `src/lib/`, `src/utils/`,
`src/helpers/`, `src/shared/` are checked for imports from UI/endpoint layers
(`components|pages|api|routes|views|app`). Exit 6 on violation. Bypass: `// allow:`.

*Note: HARD-GATE provisional mode was evaluated earlier and excluded — checkbox risk
outweighs benefit. Not listed here. See conversation context 2026-05-27.*

---

## What this evaluation intentionally excludes

Patterns present in production-scale harness engineering but out of scope for 3–7 day projects:
- Mutation testing
- LSP integration
- Harness templates per topology
- Multi-agent orchestration pipelines
- Runtime observability (Loki / Victoria)

These are excluded for the same reasons documented in [HARNESS.md](HARNESS.md) §"Out of scope".

---

*Last evaluated: 2026-05-28*
*Next evaluation trigger: after v1.3+ or significant harness change*
