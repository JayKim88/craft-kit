# Walkthrough — From new assignment to submission

A hypothetical scenario: **AcmeCo Backend Engineer recruitment, "Creator Settlement API", 5 days**.

This document follows the timeline of what to enter and what to look at, step by step. For principles & philosophy see [workflow-guide.md](workflow-guide.md), for per-domain customization see [customizing.md](customizing.md), for design intent see [design-rationale.md](design-rationale.md).

---

## Prerequisites

- **Node.js ≥ 18** (init.mjs uses only stdlib)
- **git** + **gh CLI** (optional, for repo automation)
- **Claude Code** (optional but recommended — for slash commands + subagents)
- **TTY terminal** (to run the interview — piped input automatically falls back to quiet mode)

---

## D-5 (1 hour) — Boot + spec alignment

### Step 1. Get the template (30s)

```bash
# degit (recommended — clean history)
npx degit JayKim88/takehome-kit acmeco-task
cd acmeco-task

# or git clone + drop .git
git clone https://github.com/JayKim88/takehome-kit acmeco-task
cd acmeco-task && rm -rf .git
```

### Step 2. Run the interview (5 min)

```bash
node bin/init.mjs
```

Sample session:

```
=== takehome-kit interview ===

Answer in English. Press Enter to keep the default.

Company name (COMPANY) [AcmeCo]: AcmeCo
Product / assignment name (PRODUCT) [Take-Home Assignment]: Creator Settlement API
Role (ROLE) [Software Engineer]: Backend Engineer 3+ years
Assignment type (TASK_TYPE: FE|BE|FS|ML|Mobile|Other) [FE]: BE
Deadline (DEADLINE_DATE, YYYY-MM-DD) [2026-05-08]: 2026-05-13
Deadline time (DEADLINE_TIME) [23:59]:
One-line core challenge: Settlement correctness + concurrency + idempotency
Stack hint (free-form): Node.js + TypeScript + Postgres + Jest
Environment notes (leave blank if none): No special concerns

--- Run commands ---
Runtime (TECH_RUNTIME): Node.js
Runtime version (RUNTIME_VERSION): 22.19
Install command (INSTALL_COMMAND): npm install
Dev server command (DEV_COMMAND): npm run dev
Test command (TEST_COMMAND): npm run test
Build command (BUILD_COMMAND): npm run build

--- Evaluation criteria ---
Number of criteria [6]: 6
§1 category name: Requirements understanding & problem definition
§1 points: 20
§2 category name: Design & code structure
§2 points: 25
§3 category name: Stability & exception handling
§3 points: 20
§4 category name: Data correctness
§4 points: 15
§5 category name: Documentation & explainability
§5 points: 10
§6 category name: Git / work trail
§6 points: 10

Total: 100 pts (6 categories)

--- Criterion-index mapping ---
Which §N is the "Requirements understanding" category? [1]:
Which §N is the "Design / code structure" category? [2]:
Which §N is the "Documentation" category? [5]:
Which §N is the "Git / work trail" category? [6]:

=== scaffold complete ===
git: initialized + first commit ("chore(init): scaffold takehome-kit for AcmeCo — Creator Settlement API")
```

Generated layout:

```
acmeco-task/
├── CLAUDE.md, AGENTS.md, README.md, .gitignore  ← AI rules + submission-ready README skeleton
├── docs/
│   ├── SPEC.md         ← Next: paste company spec
│   ├── PLAN.md         ← Our interpretation, schedule, risks, rubric mapping (auto 6-row table)
│   ├── DESIGN.md       ← 5–10 ADRs to write
│   ├── PROCESS.md      ← Phase 0–4 skeleton
│   ├── CHECKLIST.md    ← Phase A/B/C skeleton
│   └── AI_USAGE.md     ← Collaboration log table
└── .claude/
    ├── commands/  ← /init-takehome, /dod-check, /spec-sync, /checklist-trace
    └── agents/    ← rubric-reviewer
```

### Step 3. Paste SPEC (5 min)

Paste the company spec into the `<!-- SPEC PASTE START -->` region of `docs/SPEC.md`. **Never edit afterwards.**

Then transcribe the company's "low / high proficiency" criteria into the auto-generated 6-row evaluation table.

### Step 4. Verify interview output (5 min)

```bash
# Made a typo? Just restart.
rm -rf acmeco-task && npx degit JayKim88/takehome-kit acmeco-task && cd acmeco-task && node bin/init.mjs

# Check no leftover placeholders (interview mode expects 0)
grep -rn "{{" docs/ README.md CLAUDE.md
```

Remaining placeholders:
- `{{TECH_RUNTIME}}`, `{{INSTALL_COMMAND}}`, etc. → you left those interview answers blank. Fill them in by hand.
- `{{DECISION_1_TITLE}}` etc. — narrative placeholders, filled at Phase 4 wrap-up.

---

## D-5 ~ D-4 (6 hours) — Planning & design (Phase A)

Open Claude Code:

```
You: Let's fill docs/PLAN.md. Start with the ambiguities in SPEC §2 (implementation scope).

Claude: Found 3 ambiguities in SPEC §2:
1. "Concurrent settlement requests" not specified → we need to decide
2. "Refund period boundary" undefined
3. "Negative balance" handling policy missing

Option comparison:
[A/B/C table with trade-offs]

→ Add 4 rows to PLAN.md §2 table?

You: Decide on A. Add it.
Claude: [updates PLAN.md §2 table]
```

Same pattern fills:
- `PLAN.md` §2 (interpretation), §3 (scope), §4 (D-5~D-0 schedule), §5 (rubric mapping), §6 (risks)
- `DESIGN.md` 5–10 ADRs (DB schema, transaction isolation, idempotency-key strategy, concurrency locks, etc.)
- `PROCESS.md` Phase 0–4 (DB migration → domain model → API → integration tests)
- `CHECKLIST.md` Phase A/B (docs · toolchain lock) → Phase C (50-100 implementation items, each `[§N]`-tagged)

Sample git log at this stage:
```
e8a3f1b docs(plan): align scope and timeline with SPEC §3 [§5]
4c2b9d8 docs(design): ADR-001 transaction isolation (REPEATABLE READ) [§2]
1f7e6a3 docs(design): ADR-002 idempotency key strategy [§2,§3]
```

---

## D-4 ~ D-1 — Implementation cycle (repeating)

**One feature = one commit.** Each cycle:

### 1. Write code

In Claude Code:
```
You: Implement src/lib/billing/calculate.ts.
     Critical for SPEC §4 (data correctness).
     Boundary cases (month-end, midnight timezone) required.

Claude: [writes code + tests]
        - src/lib/billing/calculate.ts (152 lines)
        - src/lib/billing/calculate.test.ts (38 tests)
```

### 2. Run the 8-gate DoD check

In Claude Code:
```
/dod-check
```

> **How is `.claude/commands/dod-check.md` invoked?**
> Claude Code auto-detects the `.claude/commands/` folder under the project root.
> Typing `/dod-check` runs the work described by that .md.
> If you're not on Claude Code: paste the .md content directly and ask "execute this".

Sample output:
```
Inferred commands:
  Lint:  npm run lint
  Test:  npm run test
  Build: npm run build

Auto gates:
  1. Lint clean         ✅ PASS
  2. Tests green        ✅ PASS (38/38)
  3. Build OK           ✅ PASS
  4. No type-escape     ✅ PASS (0 `: any`)
  5. No debug logs      ✅ PASS

Manual gates:
  6. CHECKLIST sync     ⚠ 1 pending item matches diff:
                          - "Settlement boundary cases" still [ ]
  7. AI_USAGE sync      ⚠ AI_USAGE.md not updated
  8. Commit convention  ⚠ no proposed message yet
```

### 3. Sync work (manual gates)

```
You: Mark "Settlement boundary cases" as [x] in docs/CHECKLIST.md,
     append a row to docs/AI_USAGE.md:
     | AI wrote draft / Human added negative-balance case + verified isolation |
     Suggest a commit message.

Claude: [updates]
        feat(billing): implement settlement calculation with boundary cases [§4]

        - 38 tests cover month-end, partial refund, negative balance
        - All DoD gates PASS
```

### 4. User approval → commit

```
You: Commit it.
Claude: git add ... && git commit -m "feat(billing): ..."
```

Repeat 30–60 times across 5 days.

---

## D-1 — Polish

### 1. Check §N distribution

```
/checklist-trace
```

Output:
```
| §N | Category                    | Points | Commits | Status |
|----|-----------------------------|--------|---------|--------|
| §1 | Requirements understanding  | 20     | 6       | ✅ healthy |
| §2 | Design & structure          | 25     | 18      | ✅ healthy |
| §3 | Stability                   | 20     | 9       | ✅ healthy |
| §4 | Data                        | 15     | 12      | ✅ healthy |
| §5 | Documentation               | 10     | 3       | ⚠ low coverage |
| §6 | Git                         | 10     | (auto)  | (auto-evaluated) |

Coverage gap: §5 commits are sparse. Recommend bolstering README.
```

→ Patch commits:
```
docs(readme): clarify isolation/idempotency rationale [§5]
docs(ai-usage): add 5 representative AI/human decision examples [§5]
```

### 2. SPEC drift check (optional)

When the company updates the spec near deadline (rare):
```
/spec-sync
```

→ Verifies SPEC.md changes are reflected in PLAN/DESIGN/CHECKLIST.

---

## D-0 — Self-eval + submission

### 1. rubric-reviewer simulation

In Claude Code:
```
You: Run a simulation evaluation using the rubric-reviewer subagent.
```

> **How is `.claude/agents/rubric-reviewer.md` invoked?**
> Claude Code auto-detects subagents in `.claude/agents/`.
> A natural-language call like "use rubric-reviewer to do X" matches the .md frontmatter `description`.
> Outside Claude Code: paste the .md as a system prompt and ask for the analysis.

Output (4 sections):
1. **Score-simulation table** — simulated points per §N + rationale
2. **Weakness analysis** — what's needed to reach max score
3. **Critical (must do before submit)** — items that fit in 30 minutes
4. **Time-boxed actions** — score gains for 1h / 2h of additional work

### 2. Final README synthesis

```
You: Fill the "Design decisions and rationale" section of README.md
     by extracting from DESIGN ADR-001~005.
     Cover all 5 sub-items of rubric §5.
```

Sweep all `_TO FILL_` markers. Final grep:
```bash
grep -rn "_TO FILL_\|<!-- TODO" README.md docs/
# → must be 0 hits before submission
```

### 3. Make repo public + submit

```bash
# D-1: keep private
gh repo create acmeco-task --private --source=. --push

# Just before D-0 deadline: switch public
gh repo edit --visibility public

# Or one shot (NOT recommended — no recovery on a last-minute push mistake)
# gh repo create acmeco-task --public --source=. --push
```

---

## What the reviewer receives

| Location | Content | Rubric mapping |
|---|---|---|
| `README.md` | 8 evaluation sections (covers SPEC template 100%) | §1 §5 |
| `docs/SPEC.md` | Original company spec (immutable) | Audit reference |
| `docs/PLAN.md` | Interpretation · scope · schedule · risks · rubric mapping | §1 §5 |
| `docs/DESIGN.md` | 5–10 ADRs (option → decision → rationale → trade-off) | §2 §3 §5 |
| `docs/PROCESS.md` | Phase 0–4 dependency graph | §5 |
| `docs/CHECKLIST.md` | Every item `[x]` + `[§N]` tagged | §1 §3 |
| `docs/AI_USAGE.md` | Collaboration log (human decisions/verification explicit) | (avoids deductions) |
| `git log` | 30–60 commits, semantic units + `[§N]` tags | §6 |
| `src/`, `test/` | Code + 3-tier tests | §1–§4 |

---

## Tool quick reference

| Tool | Location | Claude Code | Generic environment |
|---|---|---|---|
| `init.mjs` | `bin/init.mjs` | (n/a) | `node bin/init.mjs [target] [options]` |
| `/init-takehome` | `.claude/commands/init-takehome.md` | `/init-takehome` | Paste .md content + "execute this" |
| `/dod-check` | `.claude/commands/dod-check.md` | `/dod-check` | Paste .md + "verify it" |
| `/spec-sync` | `.claude/commands/spec-sync.md` | `/spec-sync` | Paste .md + "check this" |
| `/checklist-trace` | `.claude/commands/checklist-trace.md` | `/checklist-trace` | Paste .md + "analyze this" |
| `rubric-reviewer` | `.claude/agents/rubric-reviewer.md` | "evaluate using rubric-reviewer" | Paste .md + "play this role" |

---

## Recovery — when things go wrong

### Mis-typed in the interview
```bash
# Simplest: nuke and restart
cd ..
rm -rf acmeco-task
npx degit JayKim88/takehome-kit acmeco-task
cd acmeco-task && node bin/init.mjs
```

### Bulk-replace a single placeholder
```bash
# Replace {{COMPANY}} across all .md files in one go
find . -name "*.md" -not -path "./node_modules/*" -exec sed -i '' 's/{{COMPANY}}/AcmeCo/g' {} +
# Linux: sed -i 's/...' (different quote handling)
```

### Auto quiet-mode kicks in unexpectedly
You're not piping but you still see "stdin is not a TTY":
```bash
# False positive (e.g. CI env var) — force interactive
node bin/init.mjs < /dev/tty
```

### Wrong author on the first commit
```bash
git config user.name "Your Name"
git config user.email "you@example.com"
# If you already committed:
git commit --amend --reset-author --no-edit
```

### `/dod-check` can't find lint/test/build commands
Early in a project the `package.json` scripts section is missing:
```json
{
  "scripts": {
    "lint": "eslint src/",
    "test": "vitest run",
    "build": "tsc --noEmit"
  }
}
```
Lock these during Phase B. `/dod-check` will auto-infer them.

### Slash command not detected
- Confirm cwd is the assignment root (`.claude/` must live there)
- Restart Claude Code (rare cache issue)
- Otherwise paste the .md content directly into the chat

---

## Forking (non-JayKim88 users)

To run this from your own GitHub account:

1. **Fork on GitHub or create a new repo**
   ```bash
   gh repo fork JayKim88/takehome-kit --clone
   # or
   git clone https://github.com/JayKim88/takehome-kit my-takehome-kit
   cd my-takehome-kit && git remote set-url origin https://github.com/USER/my-takehome-kit
   ```

2. **Update authorship**
   - `LICENSE`: `Copyright (c) 2026 Jay Kim` → your name
   - `package.json`: `"author": "Jay Kim"` → your name
   - The `JayKim88/takehome-kit` example in `bin/init.mjs --help` → your repo

3. **Update README degit URLs**
   ```bash
   # Replace JayKim88/takehome-kit → USER/my-takehome-kit across README & walkthrough
   sed -i '' 's|JayKim88/takehome-kit|USER/my-takehome-kit|g' README.md docs/walkthrough.md
   ```

4. **Push to your GitHub**
   ```bash
   gh repo create my-takehome-kit --public --source=. --push
   ```

After this, boot future assignments with `npx degit USER/my-takehome-kit my-task`.

---

## Further reading

- Principles & philosophy: [workflow-guide.md](workflow-guide.md), [design-rationale.md](design-rationale.md)
- Variants by TASK_TYPE: [customizing.md](customizing.md)
- Validation results: [../examples/fs-planner-reverse/README.md](../examples/fs-planner-reverse/README.md)
- This repo's own development rules: [../CLAUDE.md](../CLAUDE.md)
