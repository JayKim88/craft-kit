# Procedure 8 — Deep Code Review

**Trigger**: "코드 리뷰해줘" / "code review" / "리뷰해줘" / "review this code"

> Pre-DoD self-review (Procedure 1 Step 0) is lightweight and auto-fixes what it can.
> This procedure is a deliberate, deeper review session — no auto-fix, full diagnosis,
> user owns all decisions.

---

## Scope

Default: all files in `git diff HEAD` (or staged diff).  
If the user names specific files, review only those.

> **Step 0 overrides this scope** for projects with source code: the blast-radius file list from code-review-graph replaces `git diff HEAD` as the review target.

---

## ⚠ Rationalization check — read before executing

Each feels like a reasonable exception. None are.

| If you think... | What actually happens |
|---|---|
| "Small file — a quick skim is enough" | Subtle bugs and layer violations survive; they compound later |
| "It's the user's code — harsh feedback feels wrong" | Softened findings mislead; the user asked for a review, not approval |
| "I reviewed similar code before — this is probably fine" | Prior context biases the read; every diff deserves fresh eyes |
| "No obvious bugs — skip the architecture check" | Architecture rot is invisible at the line level; it needs a deliberate pass |
| "Performance and security seem fine at a glance" | Glances miss N+1 queries and injection paths; run the checklist |

**Iron law**: All 10 dimensions must be checked. Skipping one because it "looks fine" is not a review — it is an assumption.

---

## Steps

### 0. Blast-radius scope

Before reading any code, narrow the review scope to files actually affected:

```bash
# skip if already running `code-review-graph watch`
code-review-graph build
```

Query the MCP for the blast-radius of files in `git diff HEAD` — use the returned file list as the review scope instead of reading all changed files.

> **Required** for projects with source code (`src/` exists).
> If not installed, set up first → [docs/tools.md](../tools.md).
> Kit-only work (docs + scripts only, no `src/`) may skip this step.

---

### 1. Read the relevant SPEC clause

Before reviewing any code, read the SPEC section for this feature:
- From `git diff HEAD`, identify the commit scope or feature name.
- Locate the matching `[§N]` clause in `docs/CHECKLIST.md` → `docs/SPEC.md`.
- The SPEC clause is the ground truth for correctness checks.

If no SPEC context exists (e.g. reviewing existing code without a ticket), skip SPEC cross-checks and note it.

---

### 2. Correctness

**Question**: "Does this code do what it's supposed to do?"

- Cross-reference SPEC requirements against actual implementation.
- For each SPEC requirement: does the code address it? Partially? Not at all?
- Check edge cases explicitly listed in SPEC: empty input, null, boundary values, error codes.
- Check edge cases implied but not listed: off-by-one, empty collection, concurrent mutation.
- Check error propagation: does the failure mode match the SPEC's stated error codes/shapes?

**Flag format**: `❌ Correctness — <requirement not met> (SPEC §N says: "<quote>")`

---

### 3. Architecture fit

**Question**: "Does this code belong where it is?"

- Is domain logic (computation, validation, rules) in `lib/<domain>/` or equivalent?
- Is UI/endpoint layer free of business logic?
- Does data flow unidirectionally (source-of-truth → derived state, not mixed)?
- Are new modules consistent with existing ADRs in `docs/DESIGN.md`?
- Is any ADR now violated by this code?

**Flag format**: `⚠ Architecture — <what's wrong and where it belongs instead>`

---

### 4. Simplicity

**Question**: "Is this code doing more work than necessary?"

Look for:
- More than 20 lines where 5 would do (conditional collapse, early return, map/filter/reduce)
- Unnecessary abstraction layers (functions that are called once and add no clarity)
- Wrong-tool choices: `Promise.all` where a plain loop is clearer, regex where `split()` works, state machine where a flag would do
- Over-generalization: parameterizing things that will never vary
- Framework fighting: reimplementing something the framework provides

**Flag format**: `⚠ Simplicity — <specific instance>. Simpler approach: <sketch>`

---

### 5. Domain isolation

**Question**: "Is business logic where it can be tested in isolation?"

- Any calculation, validation rule, or transformation in a component, endpoint, or handler → should be in `lib/<domain>/`
- Any function in `lib/` that imports from UI libraries / HTTP frameworks → layer violation
- Any pure function that could be moved without changing its callers

**Flag format**: `⚠ Domain isolation — <function name> in <file> should move to lib/<domain>/<file>`

---

### 6. Duplication

**Question**: "Is the same logic written twice?"

- Identical or near-identical blocks (3+ lines) in 2+ places
- Same shape of validation in 3+ endpoints
- Same date/time formatting in 3+ components

**Exception**: If two contexts have different change rates (e.g., two similar rules that will diverge), duplication is intentional. Note it explicitly.

**Flag format**: `⚠ Duplication — same pattern in <file1>:<lines> and <file2>:<lines>. Extract to <suggestion>`

---

### 7. Size and complexity

**Question**: "Can a reader understand this function in 2 minutes?"

Thresholds:
- Function > 40 lines → consider splitting by responsibility
- File > 200 lines → consider splitting by domain concern
- Nesting depth > 3 → early-return or extraction candidate
- Cyclomatic complexity: if you count more than 5 branches in one function, name them

**Flag format**: `⚠ Complexity — <function> is <N> lines / <depth> deep. Natural split: <suggestion>`

---

### 8. Naming

**Question**: "Can you understand what this does from its name alone?"

Red flags:
- `data`, `result`, `temp`, `flag`, `status` — require a comment to understand
- Boolean variables not prefixed with `is`, `has`, `should`, `can`
- Function names that describe implementation rather than intent (`loopAndFormat` vs `renderItems`)
- Abbreviations that aren't industry-standard (`usrCfg` vs `userConfig`)

**Flag format**: `⚠ Naming — \`<name>\` is unclear. Suggest: \`<betterName>\` (reason)`

*Do not auto-rename — call-site impact requires user decision.*

---

### 9. Error handling

**Question**: "Does the code handle failure correctly at system boundaries?"

- External calls (HTTP, DB, file I/O): is the error caught and shaped to the contract?
- User input validation: at the boundary, not deep inside domain logic
- Missing error paths: what happens when an async call rejects? When a DB row is null?
- Over-broad catches: `catch (e) {}` swallowing errors silently

**Only at system boundaries** — do not add error handling inside pure domain functions.

**Flag format**: `⚠ Error handling — <path> has no error boundary. <what can go wrong>`

---

### 10. Type safety

**Question**: "Do the types tell the whole truth?"

Beyond no-escape (Gate 4), check:
- Types that are technically correct but too broad (`string` where a union type would constrain callers)
- Optional fields that should be required (or vice versa)
- Return types that don't match actual behavior
- Structural types used where nominal types prevent accidental interchange

**Flag format**: `⚠ Types — <type> is broader than necessary. <what a tighter type would prevent>`

---

### 11. Performance (non-obvious only)

**Question**: "Is there a clear performance hazard that justifies the complexity of a fix?"

Flag only:
- O(n²) where O(n) is straightforward (nested loop over the same array)
- N+1 query pattern (DB call inside a loop, solvable with a batch query)
- Unnecessary re-computation inside a hot loop (a value computed every iteration when it could be hoisted)

**Do NOT flag**: micro-optimizations, anything requiring profiling data, anything that adds code complexity for <10% gain.

**Flag format**: `⚠ Performance — <pattern> is O(n²) / N+1. Fix: <sketch>`

---

### 12. Security (surface scan only)

**Question**: "Is there an obvious vulnerability that a reviewer would catch without a scanner?"

Flag only:
- User-controlled input concatenated into SQL / shell commands (injection)
- Secrets or credentials in source code
- Missing authentication/authorization check on a sensitive route
- XSS: user content rendered as raw HTML without sanitization

**This is a surface scan only.** For a full audit (secrets archaeology, dependency CVEs, CI/CD pipeline, OWASP Top 10) → trigger **Procedure 9**: "보안 감사"

**Flag format**: `🚨 Security — <vulnerability type> at <file>:<line>. Fix: <direct action>`

---

## Output format

```
=== Code Review ===
Scope: <files reviewed> (<N> files, <M> changed functions)
SPEC clause: §N — <title> (or "no SPEC context")

── Correctness ──
  ✅ All §2 requirements implemented
  ❌ Empty-input case: getItems([]) returns undefined, should return [] (§2 says "always return array")

── Architecture ──
  ⚠ validateEmail() in UserController.ts:88 — move to lib/user/validate.ts
  ✅ Data flow unidirectional

── Simplicity ──
  ⚠ formatAddress() (32 lines) can collapse to 8 with template literal + early-return
  ✅ No unnecessary abstraction

── Domain isolation ── ✅ clean

── Duplication ──
  ⚠ Same date-format block in OrderCard.tsx:44 and InvoiceList.tsx:91 — extract to lib/util/date.ts

── Size / Complexity ──
  ⚠ processOrder() is 94 lines, nesting depth 4 — natural split: parseOrder() + validateOrder()

── Naming ──
  ⚠ `flag` (UserService.ts:23) → `isExpired`
  ⚠ `data` (api/orders.ts:55) → `orderDraft`

── Error handling ──
  ⚠ fetchUser() (api/user.ts:31) has no error boundary — if network fails, caller receives undefined silently

── Type safety ──
  ⚠ getUserById returns User | undefined but callers don't check undefined

── Performance ── ✅ no obvious issues

── Security ── ✅ no obvious vulnerabilities

──────────────────────────────────────────
Summary
  🚨 Critical (block commit):  1 (correctness)
  ⚠  Important (fix soon):     6
  ℹ  Minor (flag only):        2
──────────────────────────────────────────
Decisions needed from you:
  1. Rename `flag` → `isExpired`? (UserService.ts:23)
  2. Rename `data` → `orderDraft`? (api/orders.ts:55)
  3. Split processOrder() now or log to tech-debt-tracker?
```

---

## Output rules

- **Critical (🚨)**: correctness miss vs SPEC, security vulnerability → block commit
- **Important (⚠)**: architecture, domain isolation, error handling → fix before next sprint
- **Minor (ℹ)**: naming, minor complexity → user decision
- **Never mark something as a problem when it's not** — false positives erode trust
- **Never auto-rename** — flag for user decision, include the exact location
- **Do NOT propose refactors outside the reviewed scope** — scope creep in review is noise

After the review, if the user says "fix it" for an auto-fixable item (duplication extraction, domain isolation move): execute it and report what changed. For naming and structural changes, require explicit approval per item.
