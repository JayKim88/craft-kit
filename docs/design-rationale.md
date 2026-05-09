# Design Rationale

A record of why the template is shaped this way. Patterns were extracted from the post-mortem of `fs-planner` (FuturSchool FE assignment, 5 days, May 2-6).

---

## 1. Why a 7-document SSOT?

### Problem

A recruitment assignment is graded across **multiple axes** in a short window:
- Requirements understanding (SPEC vs our interpretation)
- Design ability (why this structure?)
- Execution (how systematically did they work?)
- Code quality (tests, type safety)
- Documentation (clean README?)
- AI utilization (clear human/AI responsibility split)

If you cram all of these into one or two documents, the reviewer can't tell where to look for which signal — and you lose track of "what am I deciding right now?".

### Decision: separate documents by responsibility (Single Source of Truth)

| Document | Single responsibility | Signal the reviewer reads here |
|---|---|---|
| **SPEC.md** | Company spec (external contract, immutable) | Starting point for understanding the requirements |
| **PLAN.md** | Our interpretation, scope, timeline, risks | Prioritization, decision-making, planning |
| **DESIGN.md** | Architecture decisions and trade-offs | Design ability (why X over Y) |
| **PROCESS.md** | Implementation order, dependency graph | Execution-planning ability |
| **CHECKLIST.md** | Progress + criteria mapping | Thoroughness, completion tracking |
| **AI_USAGE.md** | What AI did vs what the human decided | AI/human responsibility split |
| **CLAUDE.md** | AI collaboration ground rules | (Bonus) AI command and control |
| **README.md** | Synthesis of all the above for submission | Documentation quality |

**Core rule**: One fact, one document. If another document needs it, link to it.

### Why isolate SPEC

The spec is an "external contract" — paste it once, never edit. Our interpretation goes in PLAN.md. This separation matters because:
1. When the reviewer runs `git diff`, they will not suspect "did the candidate alter the spec?"
2. We don't confuse "what the company asked for" with "what we decided".

---

## 2. Why an 8-gate Definition of Done?

### Problem

Right after implementing a feature, everyone *feels* "done". But by the time the assignment is graded:
- The build doesn't run, or
- Types are riddled with `any`, or
- Debug `console.log` calls are still there, or
- The checklist and the actual behavior don't match —

…and points evaporate. A 5-day assignment leaves no room for "one big cleanup pass at the end".

### Decision: 8 gates must pass on every commit

**Auto-verifiable (5):**
1. `npm run lint` (or equivalent) PASSes
2. `test` PASSes (every test green)
3. `build` PASSes (TypeScript strict, compiler happy)
4. `grep -r ": any" src/` returns 0 (or only explicitly allow-listed cases)
5. `grep -r "console.log" src/` returns 0 (warn/error excluded)

**Manual (3):**
6. Mark the corresponding CHECKLIST.md item `[x]`
7. Log the AI contribution for this commit in AI_USAGE.md
8. Commit message follows the convention + carries `[§N]` tag

The 5 auto gates are checked in one shot via the `/dod-check` slash command. The 3 manual gates are confirmed during the user-approval step.

### Why exactly 8 (not 5, not 7)

Drop to 5 (auto only) and document sync rots. Reviewers hate inconsistency between code and README/checklist most.

Push to 10 (add security checks, etc.) and every commit becomes a chore — you'll start bypassing them. 8 is the practical ceiling for a 5-day assignment.

---

## 3. Why `[§N]` rubric tagging?

### Problem

When the reviewer scores "code quality", they have to manually find **where** in our work that quality shows up. Hunting through 100+ commits and a 200-item checklist is a waste of their time.

### Decision: every checklist item / commit cites a criterion §N

```markdown
## §2 Code Structure & Design (25 pts)

- [x] [§2] State separation: TanStack Query (server) ⊥ Zustand (edit)
- [x] [§2] Time logic isolated in `lib/time.ts` (pure functions only)
- [x] [§2] No direct cache mutation; sync via `setQueryData` after PUT success
```

Commit messages too:
```
test(time): cover boundary, overlap, and grid math [§3]

- 69 unit tests across DST, week math, conflict detection
- All edge cases passing
```

### Effect

- Reviewer scoring §2 can run `git log --grep "\[§2\]"` once and see every contributing piece of work
- We also gain clarity at write-time: "what criterion does this contribute to?" becomes explicit
- Catches the "checklist all green but score still low" case — if §5 has zero commits, that's a warning sign

---

## 4. Why commit-by-commit user approval?

### Problem

The most common AI-collaboration mistake: AI commits 5-10 changes at once. The result:
- Reviewer reads git history and gets "this wasn't a person working steadily — AI bulldozed it"
- One broken lint takes down 5-10 changes together
- Rollback granularity is too coarse to be useful

### Decision: one feature = one commit, user approval required

From CLAUDE.md "Absolute Prohibitions":
> **Never commit without user approval.** Even single-line fixes. AI must show the file list + commit message + DoD result, wait for explicit approval.

### Effect (validated on fs-planner)

- 61 commits, average 18 lines changed per commit (linear, clean)
- §6 (Git history, 10 pts) max-score-eligible structure
- No "rolling back this commit breaks an unrelated feature" coupling

---

## 5. Why tech-neutral?

### Alternatives considered

- **Option A (fix on Next.js + TS)**: Fast boot, but useless for BE/ML assignments
- **Option B (FE/BE/FS variants)**: Flexible but high variant maintenance cost
- **Option C (tech-neutral, placeholders only)**: Slow first scaffold but applies to any assignment

`fs-planner` was FE; the next assignment may well be BE. Option C wins.

DESIGN.md uses a "Decision Records" format (option / criterion / decision / rationale) so the user fills in the tech decisions themselves. That actually signals to the reviewer "this candidate makes their reasoning explicit".

---

## 6. Intentionally omitted

| Item | Reason |
|---|---|
| Boilerplate code (Next.js scaffold, etc.) | Tech neutrality forbids it + `create-next-app` etc. do this better anyway |
| Auto grading | The company grades. We only simulate (`rubric-reviewer`) |
| CI/CD setup | Recruitment assignments are usually graded locally. Add when needed |
| Multi-language variants | v2. Currently a single set: English documents/code/commits |
| Web UI | Unnecessary. CLI is enough |

---

## 7. Validation hypothesis

This template is valuable when:
- **5–10 day assignment** (under 3 days = overhead; 2 weeks+ goes beyond template scope)
- **Explicit grading rubric** (rubric tagging makes sense)
- **AI collaboration permitted** (AI_USAGE.md is meaningful)

Outside those conditions, use only some documents (SPEC/PLAN/DESIGN/PROCESS/CHECKLIST/README) or shrink to a single README + checklist.
