---
description: Definition of Done 8-gate 자동 검증 — 매 커밋 직전 실행
---

# /dod-check

이 커맨드는 [CLAUDE.md "Definition of Done"](../../CLAUDE.md) 의 8개 게이트를 자동/수동 혼합으로 검증합니다. 매 feature 커밋 직전 실행하세요.

## 명령 추론 (Bash 자동 실행 순서)

다음을 순차 실행해 프로젝트의 lint/test/build 명령을 추론:

1. **`package.json` 존재 시** (Node/JS):
   ```bash
   cat package.json | python3 -c "import json,sys; s=json.load(sys.stdin).get('scripts',{}); print('LINT:', s.get('lint','')); print('TEST:', s.get('test:run', s.get('test',''))); print('BUILD:', s.get('build',''))"
   ```
   → 추론된 명령으로 게이트 1-3 실행. 없으면 `(skipped: no script)`.

2. **`pyproject.toml` 또는 `requirements.txt` 존재 시** (Python):
   - Lint: `ruff check . 2>&1` 또는 `flake8 . 2>&1`
   - Test: `pytest 2>&1` 또는 `python -m pytest 2>&1`
   - Build: `python -m build 2>&1` (있을 때만)

3. **`Cargo.toml` 존재 시** (Rust):
   - Lint: `cargo clippy --all-targets`
   - Test: `cargo test`
   - Build: `cargo build`

4. **`go.mod` 존재 시** (Go):
   - Lint: `go vet ./...`
   - Test: `go test ./...`
   - Build: `go build ./...`

5. **그 외**: 사용자에게 lint/test/build 명령을 묻고, `package.json` 등 표준 위치에 추가 권장.

## 검증 항목

### 자동 게이트 (1-5)

각 게이트별 구체 명령:

| # | 게이트 | 명령 (Bash) | PASS 조건 |
|---|---|---|---|
| 1 | Lint clean | `<inferred lint command>` | exit 0, 0 errors |
| 2 | Tests green | `<inferred test command>` | exit 0, 모든 테스트 PASS |
| 3 | Build OK | `<inferred build command>` | exit 0 |
| 4 | No type-escape | 언어별 grep (아래) | match 0건 또는 `// allow:` 주석 있음 |
| 5 | No debug logs | `grep -rn 'console\.log\|print(\|dbg!\|fmt\.Println\|System\.out\.println' src/ \| grep -v "// allow:"` | match 0건 |

**Type-escape grep (언어별)**:
- TypeScript: `grep -rEn ': any($\|[^a-zA-Z])\|as any\| any\[\]' src/ --include="*.ts" --include="*.tsx" \| grep -v "// allow:"`
- Python: `grep -rEn 'cast\(|# type: ignore' src/ \| grep -v "# allow:"`
- Rust: `grep -rEn 'unsafe \|#\[allow\(' src/ \| grep -v "// allow:"`
- Java: `grep -rEn '@SuppressWarnings\|Object ' src/`

### 수동 게이트 (6-8)

6. **CHECKLIST 동기화**:
   ```bash
   # 마지막 커밋 이후 변경된 파일과 CHECKLIST.md 의 [ ] 항목 매칭
   git diff --name-only HEAD~1 2>/dev/null > /tmp/dod-changed.txt
   grep -nE "^- \[ \]" docs/CHECKLIST.md > /tmp/dod-pending.txt
   ```
   → 사용자에게 변경 파일과 pending 체크리스트 항목을 제시, 매칭 누락 항목 보고.

7. **AI_USAGE 동기화**:
   ```bash
   # AI_USAGE.md 마지막 수정 시간 vs 마지막 커밋 시간
   AI_LAST=$(git log -1 --pretty=%at -- docs/AI_USAGE.md 2>/dev/null || echo 0)
   COMMIT_LAST=$(git log -1 --pretty=%at 2>/dev/null || echo 0)
   if [ "$AI_LAST" -lt "$COMMIT_LAST" ]; then
     echo "WARN: AI_USAGE.md not updated since last commit"
   fi
   ```

8. **커밋 메시지 컨벤션**:
   ```bash
   # 사용자가 제안한 다음 커밋 메시지를 검증
   # 형식: <type>(<scope>): <subject> [§N]
   # type: feat|fix|refactor|test|chore|docs|style|perf
   # subject: 50자 이내
   # [§N]: 평가 기준 번호 (인프라는 [§-])
   ```

## 출력 형식

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
                          - "충돌 시 어떤 블록과 충돌하는지 명시"
  7. AI_USAGE sync      ✅ updated 2 min ago
  8. Commit convention  ⚠ proposed message lacks [§N] tag

Suggested commit:
  feat(modal): add conflict detection inline message [§3]

Action: 6번 [x] 마킹 + 8번 [§3] 추가 후 재실행 권장.
```

## 주의

- **모든 게이트 PASS 전 커밋 금지** (자동 게이트 1-5가 FAIL이면 사용자 승인 절차도 진행하지 말 것).
- 프로젝트 초반(lint/test 미설정) 에는 `(skipped: not configured)` 명시 후 진행. CHECKLIST Phase B 완료 시점부터 모든 게이트 활성화.
- 게이트 FAIL 시 파일/라인 정보 함께 출력해 즉시 수정 가능하도록.
- `.claude/commands/dod-check.md` 자체는 사용자 과제 폴더에 복사된 파일이므로, 커스터마이즈 시 자기 폴더 내 사본만 수정.
