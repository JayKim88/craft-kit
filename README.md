# takehome-kit

A cookiecutter-style template that boots a verified Claude collaboration workflow (7-document SSOT + 8-gate DoD + rubric tagging) for any corporate take-home assignment in **under 5 minutes**.

> Distilled from a single well-validated workflow (`fs-planner`, FuturSchool 5-day FE assignment). Tech-neutral — works for FE/BE/FS/ML/Mobile assignments alike.

---

## What's inside

```
new-assignment/
├── CLAUDE.md            # AI collaboration ground rules (DoD, commit convention, prohibitions)
├── AGENTS.md            # Environment / setup notes
├── README.md            # Submission-ready README skeleton
└── docs/
    ├── SPEC.md          # Company spec (external contract — never edit)
    ├── PLAN.md          # Our interpretation, scope, timeline, risks
    ├── DESIGN.md        # Architecture decisions & trade-offs (Decision Records)
    ├── PROCESS.md       # Implementation order + dependency graph
    ├── CHECKLIST.md     # Per-criterion (§N) checkboxes
    └── AI_USAGE.md      # AI collaboration log (audit trail)
```

A `.claude/` directory is also installed alongside, containing 4 slash commands + 1 subagent:

| Tool | Purpose |
|---|---|
| `/init-takehome` | Interview-driven 7-doc scaffold |
| `/dod-check` | Automated 8-gate Definition-of-Done check |
| `/spec-sync` | Detect SPEC drift vs PLAN/DESIGN |
| `/checklist-trace` | Detect missing commit ↔ §N mappings |
| `rubric-reviewer` (subagent) | Reviewer simulation |

---

## How to use

> **First time?** See [docs/walkthrough.md](docs/walkthrough.md) — a hypothetical scenario (AcmeCo BE settlement API, 5 days) walking through every step from D-5 boot to D-0 submission. Includes slash command invocation, recovery scenarios, and the fork-user flow.

The quick reference (3 steps):

### 1. Get a fresh assignment folder

```bash
# degit (recommended — clean, no git history)
npx degit JayKim88/takehome-kit my-task
cd my-task

# or git clone
git clone https://github.com/JayKim88/takehome-kit my-task && rm -rf my-task/.git
```

### 2. Run the interview

```bash
node bin/init.mjs
```

You'll be asked for:
- Company name (`COMPANY`)
- Product / assignment name (`PRODUCT`)
- Role (`ROLE`, e.g. "Frontend Engineer 3+ years")
- Deadline (`DEADLINE_DATE`, ISO 8601)
- Stack hint (`STACK_HINT`, free-form)
- N evaluation criteria with point allocations (e.g. "Requirements 20, Code Quality 25, ...")
- One-line core challenge

→ Placeholders in 7 documents are substituted, `.claude/` is copied in, `git init` runs, and a first commit is made — automatically.

### 3. Fill in SPEC

Paste the company's original spec into the `<!-- SPEC PASTE START -->` region of `docs/SPEC.md`. **Never edit it after that** (external contract).

### 4. Fill PLAN/DESIGN, start working

The 8-gate DoD defined in `CLAUDE.md` is the gate for every commit. Use `/dod-check` for self-verification.

---

## Why this workflow?

See `docs/design-rationale.md` for the full reasoning. Summary:

- **7-document separation**: One fact lives in one document. SPEC ≠ PLAN ≠ DESIGN ≠ progress — reviewers read faster too.
- **8-gate DoD**: 5 auto-verifiable gates (lint/test/build/no-any/no-console) + 3 manual gates (checklist/AI_USAGE/commit format) prevent the "looks done but isn't" trap.
- **`[§N]` rubric tagging**: Every piece of work explicitly cites which evaluation criterion it contributes to. Prevents the reviewer asking "where do I score this?".
- **Commit-by-commit user approval**: One feature = one commit, each requiring explicit approval — git history becomes evaluation material in itself (in fs-planner, git history was a 10-point criterion).

---

## Validation

Reverse-engineering the 7 documents of `fs-planner` (FuturSchool FE assignment) regenerated them with ≥ 95% section-structure match. See `examples/fs-planner-reverse/`.

---

## Forking under your own GitHub account

If you want to operate this from your own repo (not JayKim88's), see the 4-spot change list and procedure in [docs/walkthrough.md "Forking" section](docs/walkthrough.md#forking-non-jaykim88-users).

## License

MIT. When forking, change `Copyright (c) 2026 Jay Kim` in [LICENSE](LICENSE) to your own name (a redistribution requirement).
