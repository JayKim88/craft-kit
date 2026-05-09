---
description: Definition of Done 8-gate auto-verification — run before every commit
---

# /dod-check

This command verifies the 8 gates from [CLAUDE.md "Definition of Done"](../../CLAUDE.md) using a mix of automation and manual checks. Run it before every feature commit.

## Command inference (sequential bash auto-detection)

Run the following in order to infer the project's lint/test/build commands:

1. **If `package.json` exists** (Node/JS):
   ```bash
   cat package.json | python3 -c "import json,sys; s=json.load(sys.stdin).get('scripts',{}); print('LINT:', s.get('lint','')); print('TEST:', s.get('test:run', s.get('test',''))); print('BUILD:', s.get('build',''))"
   ```
   → Use the inferred commands for gates 1-3. Missing scripts → `(skipped: no script)`.

2. **If `pyproject.toml` or `requirements.txt` exists** (Python):
   - Lint: `ruff check . 2>&1` or `flake8 . 2>&1`
   - Test: `pytest 2>&1` or `python -m pytest 2>&1`
   - Build: `python -m build 2>&1` (only if applicable)

3. **If `Cargo.toml` exists** (Rust):
   - Lint: `cargo clippy --all-targets`
   - Test: `cargo test`
   - Build: `cargo build`

4. **If `go.mod` exists** (Go):
   - Lint: `go vet ./...`
   - Test: `go test ./...`
   - Build: `go build ./...`

5. **Otherwise**: ask the user for lint/test/build commands and recommend adding them to a standard location (e.g. `package.json`).

## Verification items

### Auto gates (1-5)

Concrete commands per gate:

| # | Gate | Command (Bash) | PASS condition |
|---|---|---|---|
| 1 | Lint clean | `<inferred lint command>` | exit 0, 0 errors |
| 2 | Tests green | `<inferred test command>` | exit 0, all tests pass |
| 3 | Build OK | `<inferred build command>` | exit 0 |
| 4 | No type-escape | language-specific grep (below) | 0 matches, or `// allow:` comment present |
| 5 | No debug logs | `grep -rn 'console\.log\|print(\|dbg!\|fmt\.Println\|System\.out\.println' src/ \| grep -v "// allow:"` | 0 matches |

**Type-escape grep (per language)**:
- TypeScript: `grep -rEn ': any($\|[^a-zA-Z])\|as any\| any\[\]' src/ --include="*.ts" --include="*.tsx" \| grep -v "// allow:"`
- Python: `grep -rEn 'cast\(|# type: ignore' src/ \| grep -v "# allow:"`
- Rust: `grep -rEn 'unsafe \|#\[allow\(' src/ \| grep -v "// allow:"`
- Java: `grep -rEn '@SuppressWarnings\|Object ' src/`

### Manual gates (6-8)

6. **CHECKLIST sync**:
   ```bash
   # Match files changed since last commit against the [ ] items in CHECKLIST.md
   git diff --name-only HEAD~1 2>/dev/null > /tmp/dod-changed.txt
   grep -nE "^- \[ \]" docs/CHECKLIST.md > /tmp/dod-pending.txt
   ```
   → Show changed files and pending checklist items, report any missing matches.

7. **AI_USAGE sync**:
   ```bash
   # Compare last-modified time of AI_USAGE.md to last commit time
   AI_LAST=$(git log -1 --pretty=%at -- docs/AI_USAGE.md 2>/dev/null || echo 0)
   COMMIT_LAST=$(git log -1 --pretty=%at 2>/dev/null || echo 0)
   if [ "$AI_LAST" -lt "$COMMIT_LAST" ]; then
     echo "WARN: AI_USAGE.md not updated since last commit"
   fi
   ```

8. **Commit-message convention**:
   ```bash
   # Validate the proposed next commit message
   # Format: <type>(<scope>): <subject> [§N]
   # type: feat|fix|refactor|test|chore|docs|style|perf
   # subject: ≤ 50 chars
   # [§N]: rubric criterion (use [§-] for infra)
   ```

## Output format

```
=== DoD Check (8 gates) ===

Inferred commands:
  Lint:  npm run lint
  Test:  npm run test:run
  Build: npm run build

Auto gates:
  1. Lint clean         ✅ PASS  (0 errors)
  2. Tests green        ✅ PASS  (91/91)
  3. Build OK           ✅ PASS  (typecheck OK)
  4. No type-escape     ✅ PASS  (0 `: any`)
  5. No debug logs      ✅ PASS  (0 console.log)

Manual gates (review needed):
  6. CHECKLIST sync     ⚠ 1 pending item matches diff:
                          - "Inline conflict-detection message on collision"
  7. AI_USAGE sync      ✅ updated 2 min ago
  8. Commit convention  ⚠ proposed message lacks [§N] tag

Suggested commit:
  feat(modal): add conflict detection inline message [§3]

Action: mark gate 6 [x] + add [§3] to gate 8, then re-run.
```

## Notes

- **Do not commit until every gate passes** (if any of auto gates 1-5 FAIL, do not proceed to user approval).
- Early in a project (lint/test not configured): print `(skipped: not configured)` and continue. Activate every gate from the moment Phase B (toolchain lock) completes.
- On gate failure, print file/line info so the issue can be fixed immediately.
- `.claude/commands/dod-check.md` is the copy in your assignment folder, so customize that copy only.
