# Overview — How craft-kit Works at a Glance

> Single-view structure + flow + enforcement. This is the **WHAT** — for the **WHY**, see [HARNESS.md](HARNESS.md).
> Audience: someone who just cloned the kit and wants the full mental model in one page.

---

## Unified diagram

```mermaid
flowchart TB
    User((👤 User))

    subgraph TIME["⏱ Phase A → E (D-N → D-0)"]
      direction LR
      PA["<b>A · Doc alignment</b><br/>~5h · SPEC paste<br/>Proc.6 guided fill"]
      PB["<b>B · Toolchain lock</b><br/>~30m · pin runtime<br/>lint/test/build scripts"]
      PC["<b>C · Implement</b><br/>30~60 cycles<br/>code → DoD → commit"]
      PD["<b>D · Polish</b><br/>~3h · §N trace<br/>_TO FILL_ sweep"]
      PE["<b>E · Ship</b><br/>~2h · fresh session<br/>strict review"]
      PA --> PB --> PC --> PD --> PE
    end

    subgraph BRAIN["🧠 CLAUDE.md — AI rules SSOT router"]
      direction TB
      DOD["<b>7-gate DoD</b><br/>lint·test·build·no-escape<br/>no-debug·CHECKLIST·msg"]
      PROCS["<b>9 procedures</b> (natural-language triggers)<br/>1 DoD · 2 §N trace · 3 SPEC drift · 4 review<br/>5 cadence · 6 Phase-A fill · 7 gardening · 8 code-review · 9 security"]
    end

    subgraph DOCS["📚 docs/ — Single Source of Truth"]
      direction TB
      SPEC["<b>SPEC.md</b> · immutable contract"]
      PLAN["<b>PLAN.md</b> · scope/schedule/§N map"]
      DESIGN["<b>DESIGN.md</b> · ADRs + SPEC origin"]
      PROCESS["<b>PROCESS.md</b> · impl order/deps"]
      CHECK["<b>CHECKLIST.md</b> · tasks tagged [§N]"]
    end

    subgraph KIT["📦 docs/kit/ — Kit-meta (reference + maintainer)"]
      direction TB
      HARN["HARNESS.md · design rationale"]
      OVW2["OVERVIEW.md · structure (this file)"]
      TOOLS["TOOLS.md · dev tool recommendations"]
      HIST["HISTORY.md · v0.7→v1.x changelog"]
      IMPR["improvements/ · self-improvement loop<br/>(Stop hook writes here · kit-improve processes)"]
    end

    subgraph CLAUDE_DIR["⚡ .claude/ — agent configuration"]
      SK["skills/ — multi-vendor triggers<br/>cadence · code-review · security-audit · …"]
      AG["agents/ — subagent definitions<br/>code-review-mapper (read-only mapper, Proc 8)<br/>pre-commit-reviewer (critical review, Proc 1)"]
    end

    subgraph CHOOKS["🪝 scripts/hooks/ — Claude Code event hooks (chat-time)"]
      SREF["session-reflect.sh<br/>Stop → kit improvement proposal"]
      SSTA["session-start.sh<br/>UserPromptSubmit → branch / plans / CHECKLIST% / deadline / last commit"]
      PEL["post-edit-lint.sh<br/>PostToolUse → instant lint"]
    end

    subgraph GUARD["🛡 Auto safety net (git-time)"]
      HOOK[".githooks/pre-commit<br/>stack-auto · re-runs gates 1-5b<br/>docs-only → auto-skip"]
      CAD["scripts/cadence.sh<br/>commits/§N/CHECKLIST/D-day digest"]
    end

    OUT["📤 External-facing<br/>README.md (ship)<br/>AGENTS.md (env)<br/>src/ (code)"]

    User -- "natural language<br/>(ready to commit / review / progress)" --> BRAIN
    BRAIN -- "phase guidance" --> TIME

    PA -. reads .-> SPEC
    PA -. writes .-> PLAN
    PA -. writes .-> DESIGN
    PA -. writes .-> PROCESS
    PA -. writes .-> CHECK
    PB -. registers scripts .-> OUT
    PC -- "Proc.1 DoD" --> DOD
    PC -. updates .-> CHECK
    PC -- "git commit" --> HOOK
    PD -- "Proc.2 §N trace" --> PROCS
    PE -- "Proc.4 strict review" --> PROCS

    PROCS -. same logic .- SK
    HOOK -- "PASS → record / FAIL → reject" --> GIT[(git repo)]
    CAD -. reads .-> GIT
    User -. "/cadence /dod-verify …" .-> CLAUDE_DIR
```

---

## 3-view breakdown

**1. Timeline — Phase A → E sequence**

```mermaid
flowchart TD
  Boot["<b>bootstrap</b><br/>git clone + git config core.hooksPath .githooks"]
  A["<b>Phase A · Doc alignment</b> (D-N, ~5h)<br/>paste SPEC verbatim<br/>Proc.6 Phase-A guided fill<br/>fills PLAN / DESIGN / PROCESS / CHECKLIST / README HINTs"]
  B["<b>Phase B · Toolchain lock</b> (D-N+1, ~30m)<br/>pin runtime + lint / test / build scripts<br/>smoke-test pre-commit hook · cadence.sh · skills"]
  C["<b>Phase C · Implementation</b> (D-N+1 ~ D-1, ×30-60)<br/>code → Proc.1 DoD verify → user approval → git commit<br/>any time: Proc.5 cadence · Proc.3 SPEC drift"]
  D["<b>Phase D · Polish</b> (D-1, ~3h)<br/>Proc.2 §N trace · sweep _TO FILL_ · manual smoke"]
  E["<b>Phase E · Ship</b> (D-0, ~2h)<br/>fresh session → Proc.4 strict review<br/>Proc.9 security audit · fixes · ship / hand off"]
  Boot --> A --> B --> C --> D --> E
```

**2. File map — who owns what**

```mermaid
flowchart LR
  CLAUDE["<b>CLAUDE.md</b><br/>AI rules · DoD · 9 procedures<br/>(SSOT router)"]
  README["README.md<br/>external-facing"]
  AGENTS["AGENTS.md<br/>env gotchas"]
  SRC["src/<br/>your code"]

  subgraph SSOT["docs/ — single source of truth (project)"]
    direction TB
    SPEC["SPEC.md · immutable"]
    PLAN["PLAN.md · scope / schedule / §N map"]
    DESIGN["DESIGN.md · ADRs + SPEC origin"]
    PROCESS["PROCESS.md · implementation order"]
    CHECK["CHECKLIST.md · tasks tagged §N"]
  end

  subgraph KITDOC["docs/kit/ — kit-meta"]
    direction TB
    HARN["HARNESS.md · design rationale"]
    OVW["OVERVIEW.md · structure guide"]
    TOOLS["TOOLS.md · dev tools"]
    HIST["HISTORY.md · changelog"]
    IMPR["improvements/ · self-improvement loop"]
  end

  subgraph CLAUDE_DIR[".claude/ — agent configuration"]
    direction TB
    SK["skills/ — multi-vendor triggers<br/>cadence · checklist-trace · dod-verify<br/>phase-a-guide · pre-ship-review · spec-drift<br/>doc-gardening · code-review · security-audit"]
    AG["agents/ — subagent definitions<br/>code-review-mapper (read-only mapper, Proc 8)<br/>pre-commit-reviewer (critical review, Proc 1)"]
  end

  subgraph CHOOKS["scripts/hooks/ — Claude Code event hooks"]
    direction TB
    SREF["session-reflect.sh · Stop"]
    SSTA["session-start.sh · UserPromptSubmit · cadence injection"]
    PEL["post-edit-lint.sh · PostToolUse"]
  end

  subgraph EXEC["Enforcement + sensors"]
    direction TB
    HOOK[".githooks/pre-commit<br/>gates 1-5b, stack-auto"]
    CAD["scripts/cadence.sh<br/>8-line digest"]
    WRAP["wrap-up/ · per-session log"]
  end

  CLAUDE --> SSOT
  CLAUDE --> KITDOC
  CLAUDE --> CLAUDE_DIR
  CLAUDE --> CHOOKS
  CLAUDE --> EXEC
  CLAUDE --> README
  CLAUDE --> AGENTS
  HOOK -. reads staged blobs .-> SRC
  CAD -. reads git log .-> SRC
  SREF -. writes .-> IMPR
```

**3. Per-commit flow — chat-time + git-time double safety net**

```mermaid
sequenceDiagram
  autonumber
  participant U as User
  participant AI as Claude (chat)
  participant Git
  participant Hook as pre-commit

  U->>AI: implements feature in src/
  U->>AI: "ready to commit" / "커밋해도 돼"
  Note over AI: Proc.1 DoD verify<br/>auto 1-5 (lint / test / build / no-escape / no-debug)<br/>manual 6-7 (CHECKLIST · msg fmt)<br/>6b doc drift · 3b README ↔ scripts
  AI-->>U: result table (fix & retry on fail)
  U->>AI: approves commit message
  AI->>Git: git commit
  Git->>Hook: invokes hook automatically
  Note over Hook: re-runs gates 1-5b on STAGED blobs<br/>docs-only → skip 1-3<br/>bypass: SKIP_HOOK=1 (justify in body)<br/>NEVER --no-verify
  alt hook PASS
    Hook-->>Git: exit 0 → commit recorded
  else hook FAIL
    Hook-->>Git: exit ≠ 0 → commit rejected
  end
```

---

## Reading guide (4 lines)

1. **Top time-axis** = work order — `A doc align → B toolchain → C implement × N → D polish → E ship`.
2. **CLAUDE.md (center)** = brain — routes natural-language input ("ready to commit", "review", "progress check") into 9 project procedures, enforces 7-gate DoD.
3. **docs/ (SSOT)** = project info · **docs/kit/** = kit-meta (reference + maintainer area) · **.claude/skills/** = procedures exposed to multi-vendor agents · **.claude/agents/** = subagent definitions (read-only explorers) · **.githooks/pre-commit** = git-time safety net for commits that bypass chat.
4. **scripts/hooks/** = Claude Code event hooks — chat-time companions: instant lint on edit (PostToolUse), session context injection on start (UserPromptSubmit), and kit self-improvement reflection on stop (Stop) feeding `docs/kit/improvements/` for `kit-improve` review.

---

## Key design properties

| Property | Where it shows up | Why it matters |
|---|---|---|
| **Dual safety net** | Proc.1 DoD (chat-time) + pre-commit hook (git-time) | If user forgets, if AI gets lazy, git refuses |
| **Natural-language triggers** | CLAUDE.md "AI agent procedures" table | No slash commands required — "커밋해도 돼" → Proc.1 |
| **SSOT separation** | CLAUDE.md routing table | Each fact lives in exactly one document; duplicates get consolidated |
| **Multi-vendor reach** | `.claude/skills/SKILL.md` frontmatter | Codex / Cursor / Aider auto-discover via the SKILL.md convention |
| **Subagent exploration** | `.claude/agents/code-review-mapper.md` | Large-scope reviews spawn a read-only subagent to map the subsystem before the main agent edits |
| **Independent critical review** | `.claude/agents/pre-commit-reviewer.md` | Proc 1 Step 0b spawns a fresh-context subagent to check Correctness vs SPEC and Security before every commit |
| **Read-only observability** | `scripts/cadence.sh` + Procedure 5 | Shows numbers, never recommends — user retains agency |
| **Stack-neutral** | Pre-commit hook auto-detects Node / Python / Rust / Go / Java | One kit, any stack |

---

## File map (flat view)

```
craft-kit/
├── CLAUDE.md              ← AI rules index (routing + rules + procedure trigger table + self-improvement loop)
├── README.md              ← Dual identity: kit-readme → project-readme
├── AGENTS.md              ← Environment-specific gotchas
├── LICENSE
├── docs/
│   ├── SPEC.md            ← (Project) Immutable external contract — paste, then never edit
│   ├── PLAN.md            ← (Project) Interpretation, scope, schedule, requirements (§N) map
│   ├── DESIGN.md          ← (Project) §0 Core beliefs + ADRs with SPEC origin field
│   ├── PROCESS.md         ← (Project) Implementation order, dependency graph
│   ├── CHECKLIST.md       ← (Project) Quality grades + tasks tagged [§N] (criterion), per-phase
│   ├── GUIDE.md           ← (Project) Read-this-first walkthrough for new users
│   ├── procedures/        ← (Project) Procedure details — Proc 1-9, read on demand
│   │   ├── proc-1-dod.md
│   │   ├── proc-2-trace.md
│   │   ├── proc-3-spec-drift.md
│   │   ├── proc-4-review.md
│   │   ├── proc-5-cadence.md
│   │   ├── proc-6-phase-a.md
│   │   ├── proc-7-gardening.md
│   │   ├── proc-8-code-review.md
│   │   └── proc-9-security.md
│   ├── exec-plans/
│   │   ├── active/
│   │   │   └── TEMPLATE.md  ← Copy + rename for each complex feature (3+ files)
│   │   ├── completed/       ← Finished exec-plans (history)
│   │   └── tech-debt-tracker.md  ← Running catalog of known shortcuts
│   └── kit/               ← (Kit-meta) About craft-kit itself — reference + maintainer area
│       ├── HARNESS.md         ← Design rationale (WHY this kit shape) — useful reference
│       ├── OVERVIEW.md        ← This file (WHAT the kit does) — useful reference
│       ├── TOOLS.md           ← Recommended dev tools: context-mode + code-review-graph
│       ├── CODING-STYLE.md    ← Coding standard: §1 tool-enforced + §2 judgment rules
│       ├── templates/         ← Copy-at-Phase-B configs
│       │   ├── eslint.config.mjs ← Bucket A/B style rules (layers on eslint-config-next)
│       │   └── .prettierrc       ← Formatter defaults
│       ├── HISTORY.md         ← Kit version history (v0.7 → v1.x changelog)
│       ├── improvements/      ← Kit self-improvement loop — Stop hook writes here (auto-generated)
│       │   ├── kit-improve.md   ← Process for reviewing pending proposals (no number — not a project procedure)
│       │   ├── pending/         ← Auto-generated by Stop hook
│       │   ├── accepted/        ← Archived after kit-improve approves
│       │   └── rejected/        ← Archived after kit-improve rejects (with reason)
│       └── plans/             ← Manual kit planning docs (harness evaluations, initiatives)
│           ├── done/            ← Completed planning cycles
│           ├── in-progress/     ← Active planning cycles
│           └── todo/            ← Queued planning cycles
├── .claude/
│   ├── settings.json       ← Shared hook config: PreToolUse / Stop / UserPromptSubmit / PostToolUse (tracked)
│   ├── settings.local.json ← User-local permissions + additionalDirectories (gitignored — see Component 16)
│   ├── agents/             ← Subagent definitions (code-review-mapper · pre-commit-reviewer)
│   └── skills/             ← Multi-vendor SKILL.md triggers (Codex/Cursor/Aider)
├── .githooks/
│   ├── pre-commit         ← DoD gates 1-5b enforcement (stack-auto, blocks bad commits)
│   └── post-commit        ← Exec-plan sync reminder + inline TODO scan (advisory only)
├── scripts/
│   ├── cadence.sh         ← Progress digest: commits / §N / quality grades / tech-debt / stale docs / D-day
│   └── hooks/             ← Claude Code event hooks (chat-time, complement git-time pre-commit)
│       ├── session-reflect.sh   ← Stop hook  → writes to docs/kit/improvements/pending/ (kit-scoped)
│       ├── session-start.sh     ← UserPromptSubmit → injects branch / active plans / CHECKLIST% / deadline / last commit
│       └── post-edit-lint.sh    ← PostToolUse → instant lint advisory after Write/Edit on src/
└── wrap-up/               ← Per-session work logs (gitignored)
```

---

## See also

- [CLAUDE.md](../CLAUDE.md) — AI rules, DoD definition, 9 procedures (the actual SSOT the AI reads)
- [HARNESS.md](HARNESS.md) — *why* the kit is shaped this way (mapped to OpenAI harness engineering principles)
- [README.md](../README.md) — bootstrap instructions + project scaffold
