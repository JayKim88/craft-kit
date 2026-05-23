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
      HARN["HARNESS.md · design rationale"]
    end

    subgraph SKILLS["⚡ .claude/skills/ — multi-vendor triggers"]
      SK["cadence · checklist-trace · dod-verify<br/>phase-a-guide · pre-ship-review · spec-drift<br/>doc-gardening · code-review · security-audit"]
    end

    subgraph GUARD["🛡 Auto safety net (git-time)"]
      HOOK[".githooks/pre-commit<br/>stack-auto · re-runs gates 1-5<br/>docs-only → auto-skip"]
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
    PC -. updates .-> AIU
    PC -- "git commit" --> HOOK
    PD -- "Proc.2 §N trace" --> PROCS
    PE -- "Proc.4 strict review" --> PROCS

    PROCS -. same logic .- SK
    HOOK -- "PASS → record / FAIL → reject" --> GIT[(git repo)]
    CAD -. reads .-> GIT
    User -. "/cadence /dod-verify …" .-> SKILLS
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
  CLAUDE["<b>CLAUDE.md</b><br/>AI rules · DoD · 8 procedures<br/>(SSOT router)"]
  README["README.md<br/>external-facing"]
  AGENTS["AGENTS.md<br/>env gotchas"]
  SRC["src/<br/>your code"]

  subgraph SSOT["docs/ — single source of truth"]
    direction TB
    SPEC["SPEC.md · immutable"]
    PLAN["PLAN.md · scope / schedule / §N map"]
    DESIGN["DESIGN.md · ADRs + SPEC origin"]
    PROCESS["PROCESS.md · implementation order"]
    CHECK["CHECKLIST.md · tasks tagged §N"]
    HARN["HARNESS.md · design rationale"]
    OVW["OVERVIEW.md · structure guide"]
  end

  subgraph SKILLS[".claude/skills/ — multi-vendor triggers"]
    direction TB
    SK["cadence · checklist-trace · dod-verify<br/>phase-a-guide · pre-ship-review · spec-drift<br/>doc-gardening · code-review · security-audit"]
  end

  subgraph EXEC["Enforcement + sensors"]
    direction TB
    HOOK[".githooks/pre-commit<br/>gates 1-5, stack-auto"]
    CAD["scripts/cadence.sh<br/>8-line digest"]
    WRAP["wrap-up/ · per-session log"]
  end

  CLAUDE --> SSOT
  CLAUDE --> SKILLS
  CLAUDE --> EXEC
  CLAUDE --> README
  CLAUDE --> AGENTS
  HOOK -. reads staged blobs .-> SRC
  CAD -. reads git log .-> SRC
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
  Note over Hook: re-runs gates 1-5 on STAGED blobs<br/>docs-only → skip 1-3<br/>bypass: SKIP_HOOK=1 (justify in body)<br/>NEVER --no-verify
  alt hook PASS
    Hook-->>Git: exit 0 → commit recorded
  else hook FAIL
    Hook-->>Git: exit ≠ 0 → commit rejected
  end
```

---

## Reading guide (3 lines)

1. **Top time-axis** = work order — `A doc align → B toolchain → C implement × N → D polish → E ship`.
2. **CLAUDE.md (center)** = brain — routes natural-language input ("ready to commit", "review", "progress check") into 8 procedures, enforces 7-gate DoD.
3. **docs/ (SSOT)** = single info source · **.claude/skills/** = same procedures exposed to multi-vendor agents (Cursor / Codex / Aider) · **.githooks/pre-commit** = git-time safety net for commits that bypass chat.

---

## Key design properties

| Property | Where it shows up | Why it matters |
|---|---|---|
| **Dual safety net** | Proc.1 DoD (chat-time) + pre-commit hook (git-time) | If user forgets, if AI gets lazy, git refuses |
| **Natural-language triggers** | CLAUDE.md "AI agent procedures" table | No slash commands required — "커밋해도 돼" → Proc.1 |
| **SSOT separation** | CLAUDE.md routing table | Each fact lives in exactly one document; duplicates get consolidated |
| **Multi-vendor reach** | `.claude/skills/SKILL.md` frontmatter | Codex / Cursor / Aider auto-discover via the SKILL.md convention |
| **Read-only observability** | `scripts/cadence.sh` + Procedure 5 | Shows numbers, never recommends — user retains agency |
| **Stack-neutral** | Pre-commit hook auto-detects Node / Python / Rust / Go / Java | One kit, any stack |

---

## File map (flat view)

```
craft-kit/
├── CLAUDE.md              ← AI rules index ~140 lines (routing + rules + procedure trigger table)
├── README.md              ← Dual identity: kit-readme → project-readme
├── AGENTS.md              ← Environment-specific gotchas
├── LICENSE
├── docs/
│   ├── SPEC.md            ← Immutable external contract (paste, then never edit)
│   ├── PLAN.md            ← Interpretation, scope, schedule, requirements (§N) map
│   ├── DESIGN.md          ← §0 Core beliefs + ADRs with SPEC origin field
│   ├── PROCESS.md         ← Implementation order, dependency graph
│   ├── CHECKLIST.md       ← Quality grades + tasks tagged [§N] (criterion), per-phase
│   ├── HARNESS.md         ← Design rationale (WHY this kit shape)
│   ├── OVERVIEW.md        ← This file (WHAT the kit does)
│   ├── tools.md           ← Recommended dev tools: context-mode + code-review-graph (install once per machine)
│   ├── procedures/        ← Procedure details (read on demand — not loaded every turn)
│   │   ├── proc-1-dod.md
│   │   ├── proc-2-trace.md
│   │   ├── proc-3-spec-drift.md
│   │   ├── proc-4-review.md
│   │   ├── proc-5-cadence.md
│   │   ├── proc-6-phase-a.md
│   │   ├── proc-7-gardening.md
│   │   ├── proc-8-code-review.md
│   │   └── proc-9-security.md
│   └── exec-plans/
│       ├── active/
│       │   └── TEMPLATE.md  ← Copy + rename for each complex feature (3+ files)
│       ├── completed/       ← Finished exec-plans (history)
│       └── tech-debt-tracker.md  ← Running catalog of known shortcuts
├── .claude/
│   └── skills/            ← Multi-vendor SKILL.md triggers (Codex/Cursor/Aider)
├── .githooks/
│   ├── pre-commit         ← DoD gates 1-5 enforcement (stack-auto, blocks bad commits)
│   └── post-commit        ← Exec-plan sync reminder + inline TODO scan (advisory only)
├── scripts/
│   └── cadence.sh         ← Progress digest: commits / §N / quality grades / tech-debt / stale docs / D-day
└── wrap-up/               ← Per-session work logs (gitignored)
```

---

## See also

- [CLAUDE.md](../CLAUDE.md) — AI rules, DoD definition, 8 procedures (the actual SSOT the AI reads)
- [HARNESS.md](HARNESS.md) — *why* the kit is shaped this way (mapped to OpenAI harness engineering principles)
- [README.md](../README.md) — bootstrap instructions + project scaffold
