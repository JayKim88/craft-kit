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

## Workflow phases (D-N to D-0)

| Phase | When | Action | Files touched |
|---|---|---|---|
| **A. Doc alignment** | D-N (~5h) | Paste SPEC verbatim. Transcribe rubric (the 6 placeholder categories in `docs/SPEC.md`). Fill `docs/PLAN.md` §2 (interpretation), §3 (scope), §4 (schedule), §5 (rubric mapping), §6 (risks). Write 5-10 ADRs in `docs/DESIGN.md`. Decompose Phase 0~4 in `docs/PROCESS.md`. Tag 50-100 items with `[§N]` in `docs/CHECKLIST.md`. Fill project-specific HINT zones in this document. | All 6 docs + CLAUDE.md |
| **B. Toolchain lock** | D-N+1 (~30m) | Pin runtime version. Add `lint` / `test` / `build` scripts. Run them — all PASS. Replace `<lint command>` placeholders in the DoD table below with real commands. Mark Phase B items `[x]` in CHECKLIST. | `package.json` (or stack equivalent), CLAUDE.md, CHECKLIST.md |
| **C. Implementation cycle** | D-N+1 ~ D-1 (×30-60) | Per feature: code → run Procedure 1 (DoD verification) → mark CHECKLIST `[x]` + add AI_USAGE row → user approval → commit `<type>(<scope>): <subject> [§N]`. | src/, CHECKLIST.md, AI_USAGE.md, git log |
| **D. Polish** | D-1 (~3h) | Run Procedure 2 (checklist trace) to find under-covered §N. Patch with extra `docs:` commits. Sweep all `_TO FILL_` markers in README. Run manual smoke checklist. | README.md, ad-hoc fixes |
| **E. Submit** | D-0 (~2h) | Run Procedure 4 (strict pre-submission review) in a fresh Claude session. Apply 30-min critical fixes. Verify `grep -rn "_TO FILL_\|<!-- TODO" README.md docs/` returns 0. Make repo public + submit. | README.md, repo settings |

The four procedures referenced above are detailed at the bottom of this document under "## AI agent procedures".

**Phase nomenclature** — this kit uses two compatible naming schemes:

| Scheme | Where | Meaning |
|---|---|---|
| `Phase A` / `Phase B` / `Phase C` / `Phase D` / `Phase E` | This document + [docs/CHECKLIST.md](docs/CHECKLIST.md) | Top-down workflow (doc alignment → toolchain → implementation → polish → submit) |
| `PROCESS Phase 0` ~ `PROCESS Phase 4` | [docs/PROCESS.md](docs/PROCESS.md) + [docs/CHECKLIST.md](docs/CHECKLIST.md) "Phase C" subsections | Implementation steps inside Phase C (infra → required #1 → required #2 → bonus → wrap-up) |

When a HINT comment says "Phase A" with no prefix, it means the workflow phase here. When it says "PROCESS Phase 4", it means the implementation step in PROCESS.md.

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
| 6b | No doc drift (DESIGN / PLAN / README still match code) | heuristic scan in Procedure 1 |
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

| Procedure | Triggered when the user says... | What you do |
|---|---|---|
| **1. DoD verification** | "ready to commit", "DoD check", "커밋해도 돼" | Run the 8-gate check (lint/test/build + grep type-escapes per stack + grep debug logs + CHECKLIST/AI_USAGE/commit-msg sync + Gate 6b doc drift heuristic). Do not propose a commit until all auto gates pass. |
| **2. Checklist trace** | "§N coverage", "어디 부족", "rubric trace" | Count commits and CHECKLIST items per §N; flag under-covered categories. |
| **3. SPEC drift check** | "SPEC updated", "company changed spec" | Map the SPEC change region to impacted PLAN / DESIGN / CHECKLIST sections; never auto-edit, propose changes only. |
| **4. Pre-submission review** | "리뷰", "final review", "제출 전 점검", "self-eval" | Switch to strict-reviewer mode; output score simulation + weakness analysis + critical fixes + time-boxed patches. Prefer running in a fresh Claude session. |

The detailed steps for each procedure are below.

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
   - **Gate 6b — Doc drift check** (interface vs documentation alignment):
     - From `git diff --name-only HEAD`, identify changed files under `src/` (or stack equivalent: `lib/`, `internal/`, `pkg/`, `app/`).
     - If no source files changed, skip this gate (docs-only commit).
     - For each changed source file, scan the diff for interface markers:
       - Exported function / class / type signatures (added, removed, or signature changed)
       - New or removed HTTP route paths (`router.get(...)`, `@app.route(...)`, `app.Post(...)`, etc.)
       - DB schema changes (column add/remove/rename, new tables)
       - Public API surface changes (CLI flags, config keys, env vars)
     - For each interface change found, grep:
       - `docs/DESIGN.md` for the interface name — does an ADR mention it? Is the ADR now inconsistent with the change?
       - `docs/PLAN.md` §3 for new feature names — is this in `Required` / `Optional` scope, or scope-creep?
       - `README.md` "How to run" / "Project structure" / "Tech stack" — does any of these become stale?
     - On mismatch, present options to the user:
       (a) include the doc fix in this commit
       (b) make a separate `docs:` commit before this one
       (c) defer and record in `docs/CHECKLIST.md` "📌 Extra TODO" for batch sync later
     - This is a heuristic check — false negatives possible (e.g., subtle behavior change without signature change). User judgment is final.
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
     6.  CHECKLIST sync    ⚠ items needing [x]: ...
     6b. Doc drift         ⚠ DESIGN ADR-002 stale vs new signature / (or ✅ in sync)
     7.  AI_USAGE sync     ⚠ row missing
     8.  Commit convention ⚠ proposed: <message>
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
