---
description: 커밋 메시지의 [§N] 태그와 CHECKLIST.md 매핑 검증
---

# /checklist-trace

이 커맨드는 `git log` 의 모든 커밋이 `[§N]` 태그를 가지고 있는지, 그리고 CHECKLIST.md 의 `[§N]` 항목과 정합하는지 검증합니다.

평가 기준 §N (예: 코드 구조 25점, Git 작업 10점) 별로 어떤 작업이 기여했는지를 평가자가 즉시 확인할 수 있도록 하는 시스템.

## 동작

1. **커밋 스캔**: `git log --pretty=%H|%s` 로 모든 커밋 메시지 수집.
2. **태그 추출**: 각 메시지에서 `[§N]` 또는 `[§N,§M]` 패턴 추출. 없으면 untagged.
3. **CHECKLIST 스캔**: `docs/CHECKLIST.md` 에서 `[§N]` 표기가 있는 항목 추출.
4. **매핑 검증**:
   - 각 §N 별 커밋 카운트 + 체크리스트 항목 카운트
   - **untagged 커밋** 보고 (인프라/chore 가 아닌데 태그 없으면 경고)
   - 평가 카테고리에 커밋 0개인 §N 보고 (점수 누락 위험)

## 출력 예시

```
=== Checklist Trace ===

Total commits: 61
Tagged commits: 58
Untagged commits: 3
  - 79ed36e chore(init): scaffold ... [acceptable: chore]
  - a3b2c1d docs: typo fix [⚠ should have [§5] or [§-]]
  - 5f7e9d2 fix: revert breaking change [⚠ missing tag]

Per-criterion mapping:

| §N | Category                  | Points | Commits | Checklist items | Status |
|----|---------------------------|--------|---------|-----------------|--------|
| §1 | 요구사항 이해              | 20     | 8       | 12              | ✅ healthy |
| §2 | 코드 구조 + 설계           | 25     | 24      | 35              | ✅ healthy |
| §3 | 안정성 + 예외 처리         | 20     | 11      | 18              | ✅ healthy |
| §4 | UI/UX                     | 15     | 9       | 14              | ✅ healthy |
| §5 | 문서화                    | 10     | 4       | 8               | ⚠ low coverage |
| §6 | Git history               | 10     | 0       | 0               | (자동 평가) |

Untagged risk:
  - 3 untagged commits: 2 acceptable (chore/init), 1 concerning (a3b2c1d)
  - Recommendation: amend a3b2c1d with [§5] tag if not yet pushed, else add tag in next commit body

Coverage gap:
  - §5 (문서화) commits 부족 — README/docs 갱신 커밋이 적음. 별도 docs: 커밋으로 보강 권장.
```

## 사용법

```
/checklist-trace
```

옵션:
- `--strict` — untagged 커밋이 있으면 exit 1
- `--criterion <N>` — 특정 §N 의 커밋만 나열

## 주의

- `[§-]` 는 "평가에 직접 기여 안 함" 을 의도적으로 표시 (예: `chore(deps)`, `chore(format)`).
- 한 커밋이 여러 §N에 기여하면 `[§2,§3]` 식으로 다중 표기.
- Git history 자체가 평가 항목 (§Git) 인 경우, 의미 단위 커밋 분리 + refactor/test 별도 커밋이 가산점.
