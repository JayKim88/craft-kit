---
description: Definition of Done 8-gate 자동 검증 — 매 커밋 직전 실행
---

# /dod-check

이 커맨드는 [CLAUDE.md "Definition of Done"](../../CLAUDE.md) 의 8개 게이트를 자동/수동 혼합으로 검증합니다. 매 feature 커밋 직전 실행하세요.

## 검증 항목

### 자동 게이트 (1-5)

1. **Lint clean** — 프로젝트의 lint 명령 실행. 실패 시 차단.
2. **Tests green** — 테스트 명령 실행. 실패 시 차단.
3. **Build OK** — 빌드 명령 실행. 실패 시 차단.
4. **No type-escape** — 언어별 패턴:
   - TypeScript: `grep -rn ': any\|as any\| any\[\]' src/ --include="*.ts" --include="*.tsx" | grep -v "// allow:"` → 0 expected
   - Python: `grep -rn 'cast(\|# type: ignore' src/` (의도적 ignore만 허용)
   - Rust: `grep -rn 'unsafe \|#\[allow(' src/`
5. **No debug logs** — `grep -rn 'console\.log\|print(\|dbg!\|fmt\.Println' src/` → 0 expected (의도적 logging은 logger 사용)

### 수동 게이트 (6-8)

6. **CHECKLIST 동기화** — `git diff HEAD~1` 의 변경 영역과 `docs/CHECKLIST.md` 의 `[x]` 마킹이 일치하는가? 누락된 항목 보고.
7. **AI_USAGE 동기화** — 마지막 커밋 이후 `docs/AI_USAGE.md` 가 갱신됐는가? AI 사용했다면 새 행이 있어야 함.
8. **커밋 메시지 컨벤션** — 다음 커밋의 제안 메시지를 검증:
   - `<type>(<scope>): <subject> [§N]` 형식 준수
   - subject 50자 이내
   - `[§N]` 태그 존재 (인프라 작업은 `[§-]`)

## 실행 흐름

1. `package.json` / `pyproject.toml` / `Cargo.toml` 등을 읽어 lint/test/build 명령을 추론.
2. Bash로 자동 게이트 1-5 실행. 결과를 표로 출력:
   ```
   Gate | Status | Detail
   -----|--------|--------
   1. Lint   | ✅ PASS | 0 errors, 0 warnings
   2. Tests  | ✅ PASS | 91/91 passed
   3. Build  | ❌ FAIL | TypeScript error in src/foo.ts:42
   4. No `any` | ✅ PASS | 0 occurrences
   5. No log | ⚠ WARN | 2 console.log in src/utils.ts
   ```
3. `git diff --cached` 와 `docs/CHECKLIST.md` 를 비교해 6번 점검.
4. `git log -1 --pretty=%ai docs/AI_USAGE.md` 와 `git log -1 --pretty=%ai` 를 비교해 7번 점검.
5. 사용자에게 다음을 보고:
   - PASS/FAIL 표
   - 차단 사유 (FAIL 게이트별 구체 메시지)
   - 권장 다음 액션

## 출력 예시

```
=== DoD Check (8 gates) ===

Auto gates:
  1. Lint clean         ✅ PASS
  2. Tests green        ✅ PASS (91/91)
  3. Build OK           ✅ PASS
  4. No type-escape     ✅ PASS (0 `any`)
  5. No debug logs      ✅ PASS (0 console.log)

Manual gates (review needed):
  6. CHECKLIST sync     ⚠ 1 item not marked [x]:
                          - "충돌 시 어떤 블록과 충돌하는지 명시"
  7. AI_USAGE sync      ✅ updated 2 min ago
  8. Commit convention  ⚠ proposed message lacks [§N] tag

Suggested commit:
  feat(modal): add conflict detection inline message [§3]

Action: 6번 [x] 마킹 + 8번 [§3] 추가 후 재실행 권장.
```

## 주의

- 자동 게이트가 모두 PASS여도 수동 게이트(6-8) 미충족이면 커밋하지 않음.
- 게이트 실패 시 파일/라인 정보 함께 출력해 즉시 수정 가능하도록.
- 프로젝트 초반 (lint/test 미설정) 에는 "skipped" 명시 후 진행.
