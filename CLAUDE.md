# AI Collaboration Context

> Ground truth for collaborating with AI (Claude) on this take-home assignment.
> This document holds **universal rules** (coding · commit · DoD · prohibitions).
> Everything else is routed to a single-responsibility document.
>
> <!-- HINT: Replace this header with `# {Company} {Role} — {Product} / AI Collaboration Context` once you know it. -->

---

## Document routing (Single Source of Truth)

When you need information mid-work, here's where to look:

| What you're looking for | Where it lives |
|---|---|
| External spec (immutable contract) | [SPEC.md](docs/SPEC.md) |
| **Rubric (check while working)** | **[SPEC.md "## Rubric (detail)"](docs/SPEC.md) + the inline `[§N]` markers in [CHECKLIST.md](docs/CHECKLIST.md)** |
| Our planning (product definition · scope · schedule · bonus priority · rubric mapping) | [PLAN.md](docs/PLAN.md) |
| Design decisions (architecture · library choices · trade-offs) | [DESIGN.md](docs/DESIGN.md) |
| Workflow (Phases, dependency graph, commit cycle) | [PROCESS.md](docs/PROCESS.md) |
| Task list / progress | [CHECKLIST.md](docs/CHECKLIST.md) |
| AI usage rules · coding rules · DoD · prohibitions | **This document** |
| AI usage history (for submission) | [AI_USAGE.md](docs/AI_USAGE.md) |
| Reviewer-facing output | [README.md](README.md) |

**Rule**: A single piece of information lives in a single document. If you find a duplicate, consolidate into the SSOT and replace the others with links.

---

## Assignment overview (context)

<!-- HINT [Phase A]: Fill once you've read the SPEC. Keep it to 3 lines. -->

- **Deadline**: `<YYYY-MM-DD HH:MM>`
- **Type**: `<FE | BE | FS | ML | Mobile | Other>` — `<one-line product name>`
- **Core challenge**: `<one-line of what this assignment is really testing>`

Detailed planning · scope · schedule → [PLAN.md](docs/PLAN.md)

---

## Tech stack

<!-- HINT [Phase B]: Fill after tech is decided. If still undecided, compare in the DESIGN.md "Tech selection rationale" section first.
     Example rows (replace per role):
     | Tech | Version | Purpose |
     |---|---|---|
     | Node.js | 22.19 LTS | runtime |
     | TypeScript | strict | type safety |
     | <Framework> | <X.Y> | framework |
-->

| Tech | Version | Purpose |
|------|---------|---------|
| _TO FILL_ | | |

Tech-selection rationale → [DESIGN.md](docs/DESIGN.md) "Tech selection rationale"

---

## Environment notes (optional)

<!-- HINT: If your framework/language differs from typical training data, note it here.
     Examples: "Next 16 async dynamic API", "Python 3.13 deprecation", "Java 21 record patterns".
     Otherwise delete this section or keep [AGENTS.md](AGENTS.md) as the home for these. -->

See [AGENTS.md](AGENTS.md) for environment-specific gotchas.

---

## Coding rules — universal

These apply to every assignment regardless of stack.

- **No type escapes** — no unintended `any` / `unknown` / `as any` / `cast()` / `# type: ignore` etc.
- **No debug code** — `console.log` / `print()` / `dbg!()` / `System.out.println` etc. (intentional `error`/`warn` logging is fine)
- **Isolate domain logic in domain modules** — no direct computation in components / endpoints. Pure functions go to `lib/<domain>/` (or your stack's equivalent), tested in isolation.
- **Unidirectional data flow** — never mix derived/edit state with source-of-truth state. Each piece of state has one owner.
- **For each item you implement, check the `[§N]` marker in [CHECKLIST.md](docs/CHECKLIST.md) → aim to satisfy the "high proficiency" bar in [SPEC.md "Rubric (detail)" §N](docs/SPEC.md).**

## Coding rules — project-specific

<!-- HINT: Add domain-specific rules during Phase A. Examples (delete what doesn't apply):

   FE:
   - State separation: server state (TanStack Query / SWR) ⊥ edit state (Zustand / Redux)
   - Time / date logic isolated in `src/lib/time.ts`
   - Never mutate query cache directly; sync via `setQueryData` after success

   BE:
   - DB transactions start only in the service layer
   - Authorization checked before any mutation
   - Idempotency strategy explicit per endpoint

   ML:
   - Random seeds fixed
   - Train/val/test split deterministic
-->

_TO FILL — add 3-5 rules specific to this assignment's domain_

---

## Commit convention

Format: `<type>(<scope>): <subject> [§N]`

- **type**: `feat | fix | refactor | test | chore | docs | style | perf`
- **scope**: project-defined (e.g. `types | core | api | ui | nav | a11y | mocks`)
  <!-- HINT: lock 5-10 scope tokens at project start; keep them stable -->
- **subject**: English, imperative, ≤ 50 characters
- **`[§N]`**: rubric criterion number. Multiple → `[§2,§3]`. Infrastructure/tooling work → `[§-]`.

Examples:
- `feat(api): add user authentication endpoint [§2,§3]`
- `test(core): cover boundary cases for time conflict [§3]`
- `refactor(ui): extract validation hook [§2]`
- `chore(deps): upgrade test framework [§-]`

Commit ordering · dependencies → [PROCESS.md](docs/PROCESS.md) + [CHECKLIST.md](docs/CHECKLIST.md)

---

## Definition of Done (per feature commit)

| # | Gate | Verification command |
|---|---|---|
| 1 | Lint clean | `<lint command>` <!-- HINT: npm run lint / ruff check . / cargo clippy / go vet ./... --> |
| 2 | Tests green | `<test command>` <!-- HINT: npm test / pytest / cargo test / go test ./... --> |
| 3 | Build OK | `<build command>` <!-- HINT: npm run build / mvn package / cargo build / tsc --noEmit --> |
| 4 | No type-escape | language-specific grep → 0 matches |
| 5 | No debug logs | `grep -rn 'console\.log\|print(\|dbg!\|System\.out\.println' src/` → 0 |
| 6 | CHECKLIST item updated to [x] | — |
| 7 | AI_USAGE.md row added (when AI used) | — |
| 8 | Commit message follows convention + carries `[§N]` | — |

1-5 are automated quality gates; 6-8 are manual rubric-alignment gates. The AI executes them per "Procedure 1 — DoD verification" below; the user does not need to invoke a tool explicitly.

> **Phase A note**: Before the toolchain is locked (CHECKLIST Phase B), gates 1-3 will report `(skipped: not configured)`. That's expected for `docs:` and `chore:` commits — activate gates 1-3 from your first `feat:` commit onward.

---

## Git / Work trail

When git history is itself a rubric criterion (it usually is), follow these:

- **Semantic-unit commits**: one commit = one semantic unit. Align with [PROCESS.md](docs/PROCESS.md) phases.
- **No bulk dump**: never lump everything into a single final commit (explicit deduction).
- **Separate refactor / test commits (bonus)**: keeping `refactor:` / `test:` commits apart from feature commits earns extra credit.
- **User approval required**: every commit runs only after explicit user approval. AI must NOT auto-execute `git commit`.

  **A commit-approval request always includes:**
  1. List of files to stage + summary of key changes
  2. Proposed commit message (full body, including `[§N]`)
  3. DoD gate results (lint / test / build / no-type-escape / no-debug-log)
  4. **Doc-sync check** — verify before every commit:
     - [docs/CHECKLIST.md](docs/CHECKLIST.md): any items completed by this commit still marked [ ]?
     - [docs/AI_USAGE.md](docs/AI_USAGE.md): is an AI-usage row missing for this work?
     - [docs/DESIGN.md](docs/DESIGN.md) / [docs/PLAN.md](docs/PLAN.md) / [README.md](README.md): any unreflected design / scope / interface changes?
     - Offer disposition options when needed: (a) include in this commit / (b) separate docs commit / (c) batch sync later

---

## Absolute prohibitions — universal

- **Never run a commit without user approval** (see "Git / Work trail" above)
- **Never modify [SPEC.md](docs/SPEC.md)** — it is the external contract. Our interpretation goes in PLAN.md / DESIGN.md.
- **Never modify [AGENTS.md](AGENTS.md) without intent** — it captures environment-level facts.
- **Never inline domain logic in components / endpoints** — keep domain logic in dedicated modules with isolated tests.
- **Never mix sources of state** — derived/edit state and authoritative state stay separated; data flow stays unidirectional.

## Absolute prohibitions — project-specific

<!-- HINT: Add 2-4 prohibitions tied to this assignment's risk areas. Examples:
- Never directly mutate the TanStack Query cache (FE)
- Never start a DB transaction outside the service layer (BE)
- Never bypass authorization without an authenticated user context (BE)
- Never train on the test split (ML)
-->

_TO FILL — list 2-4 risks specific to this assignment_

---

## AI agent procedures

When the user's intent matches one of these triggers, execute the corresponding procedure inline. Report results in the same conversation. Do not wait for a slash command.

### Procedure 1 — DoD verification

**Trigger**: user says "ready to commit", "DoD check", "verify gates", "커밋해도 돼", or any time you are about to request commit approval.

**Steps**:

1. **Detect commands** by inspecting the project root:
   - `package.json` (Node/JS): read `scripts.lint`, `scripts.test:run` (fallback `scripts.test`), `scripts.build`
   - `pyproject.toml` / `requirements.txt` (Python): `ruff check .` / `pytest` / `python -m build` (build only if applicable)
   - `Cargo.toml` (Rust): `cargo clippy --all-targets` / `cargo test` / `cargo build`
   - `go.mod` (Go): `go vet ./...` / `go test ./...` / `go build ./...`
   - Otherwise: ask the user once for the commands.
   - If a script is missing, mark the gate `(skipped: not configured)` and continue.

2. **Run gates 1-5** in order. Stop on the first FAIL and surface the file/line.

   - Gate 1 (Lint), Gate 2 (Test), Gate 3 (Build) — run the inferred commands.
   - Gate 4 (No type-escape) — language-specific:
     - TypeScript: `grep -rEn ': any($|[^a-zA-Z])|as any| any\[\]' src/ --include='*.ts' --include='*.tsx' | grep -v '// allow:'`
     - Python: `grep -rEn 'cast\(|# type: ignore' src/ | grep -v '# allow:'`
     - Rust: `grep -rEn 'unsafe |#\[allow\(' src/ | grep -v '// allow:'`
     - Java: `grep -rEn '@SuppressWarnings' src/`
     - Go: skip (no equivalent broad escape).
   - Gate 5 (No debug logs): `grep -rn 'console\.log\|print(\|dbg!\|fmt\.Println\|System\.out\.println' src/ | grep -v '// allow:'`

3. **Manual gates 6-8**:
   - Gate 6: Compare `git diff --name-only HEAD` against `[ ]` items in `docs/CHECKLIST.md`. Suggest which to mark `[x]`.
   - Gate 7: Check `git log -1 --pretty=%at -- docs/AI_USAGE.md` vs `git log -1 --pretty=%at`. If AI_USAGE is older, propose a one-line row.
   - Gate 8: Validate the proposed commit message against `<type>(<scope>): <subject> [§N]`.

4. **Output** as a fixed table:

   ```
   === DoD Check (8 gates) ===
   Auto gates:
     1. Lint clean         ✅ PASS / ❌ FAIL (location)
     2. Tests green        ✅ PASS (N/N)
     3. Build OK           ✅ PASS
     4. No type-escape     ✅ PASS / ❌ N matches
     5. No debug logs      ✅ PASS / ❌ N matches
   Manual gates:
     6. CHECKLIST sync     ⚠ items needing [x]: ...
     7. AI_USAGE sync      ⚠ row missing
     8. Commit convention  ⚠ proposed: <message>
   ```

5. **Do not propose a commit** until all auto gates 1-5 pass.

### Procedure 2 — Checklist trace (§N coverage)

**Trigger**: user says "§N coverage", "어디 부족", "rubric trace", "checklist trace", or D-1 polish phase.

**Steps**:

1. Extract per-§N commit counts: `git log --pretty=%s | grep -oE '\[§[0-9-]+(,§[0-9-]+)*\]' | tr -d '[]§' | tr ',' '\n' | sort | uniq -c`
2. Extract per-§N CHECKLIST item counts: `grep -oE '\[§[0-9-]+\]' docs/CHECKLIST.md | sort | uniq -c`
3. Cross-reference with the rubric in `docs/SPEC.md` "Rubric (detail)" to get category names + max points.
4. Output table:

   ```
   | §N | Category | Points | Commits | Checklist items | Status |
   |----|----------|--------|---------|-----------------|--------|
   | §1 | ...      | 20     | 6       | 12              | ✅ healthy |
   | §5 | Docs     | 10     | 1       | 3               | ⚠ low coverage |
   ```

5. Flag any §N with 0 commits as a point-leakage risk (unless the category is auto-evaluated like "Git history").

### Procedure 3 — SPEC drift check

**Trigger**: user says "SPEC updated", "company changed spec", or you observe a recent change to `docs/SPEC.md`.

**Steps**:

1. `git log --follow --pretty='%h %s' docs/SPEC.md` — find the most recent change.
2. Map the changed region to impact zones:
   - Implementation scope → PLAN §3 + CHECKLIST Phase C
   - Rubric → PLAN §5 + CHECKLIST `[§N]` tags
   - API schema → DESIGN ADRs
   - Constraints → PLAN §3 (out-of-scope) + DESIGN §6 (errors)
3. For each impacted doc, check `git log -1 --pretty=%at <doc>` vs the SPEC change time.
4. Report a drift table; never auto-edit other documents — propose changes for user approval.

### Procedure 4 — Pre-submission review (strict reviewer mode)

**Trigger**: user says "리뷰", "final review", "rubric review", "제출 전 점검", "self-eval", or D-0 polish.

**Recommended invocation**: open a **fresh Claude Code session** (so prior conversation context doesn't bias the review). If running in the same session, explicitly clear the working assumption that the project is good.

**Stance for this procedure only**:
- Empathetic but no breaks. A miss is a miss. Never award points by inference.
- Cite specifically: `[DESIGN.md ADR-002]` + `[src/lib/billing/calculate.ts:42-58]`. Never "this is nice".
- No off-rubric points. Pretty UI counts only under the UI/UX category if one exists.
- No time-pressure leniency.

**Read** all of: `docs/SPEC.md`, `README.md`, `docs/CHECKLIST.md`, `docs/AI_USAGE.md`, `docs/DESIGN.md`, `docs/PLAN.md`, `git log --oneline | head -50`. Optionally `Glob "src/**/*"`, `Glob "**/*.test.*"`.

**Output 4 sections**:

1. **Score-simulation table**: per §N, max / sim score / 1-line rationale, ending with `**Total** | | 100 | **NN/100**`.
2. **Weakness analysis** (no praise — weaknesses only): for each §N, 1-3 bullets of what's needed to reach max.
3. **Critical-omission risks**: only items materially affecting the score, split into 🔴 (must fix before submission) and 🟡 (if time permits).
4. **Next actions** (time-boxed): "1 hour for +N points: ..." and "Additional 2 hours for +M points: ...".

End with: "This is a simulation, not the real evaluation. Real reviewers may weight differently."
