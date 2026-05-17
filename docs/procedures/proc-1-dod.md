# Procedure 1 — DoD Verification

**Trigger**: "ready to commit" / "DoD check" / "커밋해도 돼" / any commit approval request.

---

## Steps

### 0. Pre-DoD self-review (runs before gates 1-5)

Read `git diff HEAD` (or staged diff if nothing committed yet). For each changed `src/` file, evaluate the following dimensions. **Fix issues silently before proceeding to gates.** Report only what was found and changed.

#### 0-A. Correctness — "SPEC 요구사항을 구현했나?"
- Read the SPEC clause for this feature (from exec-plan **SPEC clause** field, or CHECKLIST `[§N]`).
- Verify every stated requirement is present in the diff.
- Check edge cases explicitly listed in SPEC (empty input, null, boundary values, error codes).
- **Flag**: any requirement with zero evidence in the diff.

#### 0-B. Simplicity — "더 단순하게 쓸 수 있나?"
- Is there a 5-line version of something written in 20 lines?
- Is `Promise.all` / `asyncio.gather` / goroutine used where a simple loop suffices?
- Are there intermediate variables or abstractions that add no clarity?
- **Auto-fix**: inline trivially extractable single-use wrappers. Report what was simplified.

#### 0-C. Domain isolation — "도메인 로직이 제자리에 있나?"
- Business logic (calculations, validation, rules) must live in `lib/<domain>/` (or stack equivalent), not in components, endpoints, or handlers.
- If domain logic is found in a component or endpoint: extract it. This is a coding rule violation (not advisory).
- **Auto-fix**: extract and move. Report the extraction.

#### 0-D. Duplication — "같은 코드가 두 군데 이상 있나?"
- Identical or near-identical blocks (3+ lines) appearing in 2+ places → extract to shared helper.
- Exception: if the two contexts have different change rates, duplication is acceptable — note why.
- **Auto-fix**: extract if clearly the same intent. Flag if ambiguous.

#### 0-E. Size / Complexity — "함수·파일이 너무 크지 않나?"
- Function > 40 lines: consider splitting by responsibility.
- File > 200 lines: consider splitting by domain concern.
- Nesting depth > 3: consider early-return or extraction.
- **Do not split blindly.** Only when a natural boundary exists. Flag if unsure.

#### 0-F. Naming — "이름만 보고 의도를 알 수 있나?"
- Function/variable names that require a comment to understand → rename.
- Boolean variables: prefer `isLoading`, `hasError` over `flag`, `status`.
- Flag but do not auto-rename (renaming has call-site impact).

#### 0-G. Performance (obvious only) — "명백한 비효율이 있나?"
- O(n²) where O(n) is straightforward (e.g., nested loop over the same array).
- Unnecessary re-computation inside a loop.
- N+1 query pattern (DB call inside a loop).
- Flag only obvious cases. Do not optimize prematurely.

#### Self-review output format

```
=== Self-Review (pre-DoD) ===
0-A Correctness   ✅ all §2 requirements present
                  ⚠ empty-input case unhandled — fixing...
0-B Simplicity    ✅ clean
0-C Domain iso.   ⚠ validation logic in UserController — extracting to lib/user/validate.ts
0-D Duplication   ⚠ same date-format block in 3 files — extracting to lib/util/date.ts
0-E Size          ⚠ processOrder() 92 lines — split into parseOrder() + validateOrder()
0-F Naming        ⚠ `flag` → `isExpired` (flagged, not auto-renamed)
0-G Performance   ✅ no obvious issues

Fixed automatically: 0-C (extraction), 0-D (extraction), 0-E (split)
Needs your decision: 0-F (rename) — approve or reject?
```

If all dimensions are ✅: skip the self-review block in output, proceed directly to gates.

---

### 1. Detect stack commands

Inspect project root:
- `package.json` → `scripts.lint`, `scripts.test:run` (fallback `scripts.test`), `scripts.build`
- `pyproject.toml` / `requirements.txt` → `ruff check .` / `pytest` / `python -m build`
- `Cargo.toml` → `cargo clippy --all-targets` / `cargo test` / `cargo build`
- `go.mod` → `go vet ./...` / `go test ./...` / `go build ./...`
- Missing script → mark gate `(skipped: not configured)` and continue.

### 2. Run auto gates 1-5

Stop on first FAIL and surface the file/line.

- **Gate 1** Lint — run detected lint command
- **Gate 2** Tests — run detected test command
  **TDD Red bypass**: if `TDD_RED=1` was set, Gate 2 was skipped at hook time. Note: `2. Tests green  ⏭ SKIPPED (TDD Red phase)`. Verify that the matching Green commit will run Gate 2 normally.
- **Gate 3** Build — run detected build command
- **Gate 4** No type-escape:
  - TS: `grep -rEn ': any($|[^a-zA-Z])|as any| any\[\]' src/ --include='*.ts' --include='*.tsx' | grep -v '// allow:'`
  - Python: `grep -rEn 'cast\(|# type: ignore' src/ | grep -v '# allow:'`
  - Rust: `grep -rEn 'unsafe |#\[allow\(' src/ | grep -v '// allow:'`
  - Java: `grep -rEn '@SuppressWarnings' src/`
  - Go: skip
- **Gate 5** No debug logs: `grep -rn 'console\.log\|print(\|dbg!\|fmt\.Println\|System\.out\.println' src/ | grep -v '// allow:'`

### 3. Manual gates 6-8

- **Gate 6** CHECKLIST sync: compare `git diff --name-only HEAD` against `[ ]` items. Suggest `[x]`.
  - **Exec-plan sync**: if active exec-plan exists, check step correspondence. All `[x]` → suggest move to `completed/`.
- **Gate 6b** Doc drift: scan diff for interface markers → grep DESIGN/PLAN/README. On mismatch offer (a)/(b)/(c).
- **Gate 7** AI_USAGE sync: check timestamp vs latest commit. Propose row if stale.
- **Gate 8** Commit message: validate `<type>(<scope>): <subject> [§N]`.

### 3b. Optional auto-corrective (Node only)

Trigger: stack=node AND staged diff touches `package.json` `scripts`.  
Detect renamed scripts → grep README "How to run" → propose `sed` patch (never auto-apply).

### 4. Output table

```
=== DoD Check ===
Self-review:      ✅ clean / ⚠ N issues found, M fixed automatically
Auto gates:
  1. Lint clean         ✅ PASS / ❌ FAIL (location)
  2. Tests green        ✅ PASS (N/N) / ⏭ SKIPPED (TDD Red)
  3. Build OK           ✅ PASS
  4. No type-escape     ✅ PASS / ❌ N matches
  5. No debug logs      ✅ PASS / ❌ N matches
Manual gates:
  6.  CHECKLIST sync    ⚠ items needing [x]: ...
  6b. Doc drift         ⚠ DESIGN ADR-002 stale / ✅ in sync
  7.  AI_USAGE sync     ⚠ row missing
  8.  Commit convention ⚠ proposed: <message>
```

### 5. Gate rule

Do NOT propose a commit until self-review issues are resolved AND auto gates 1-5 pass.
