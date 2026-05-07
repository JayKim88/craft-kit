---
description: SPEC.md 변경 시 PLAN/DESIGN/CHECKLIST drift 감지
---

# /spec-sync

이 커맨드는 `docs/SPEC.md` 의 변경분이 다른 문서(PLAN/DESIGN/CHECKLIST)에 반영됐는지 검증합니다.

> **주의**: SPEC.md 자체는 회사가 명세를 갱신했을 때만 변경됨 (드물지만 발생). 우리가 멋대로 수정하지 않음. 이 커맨드는 회사 측 갱신을 받았을 때 다른 문서를 동기화하는 데 사용.

## 동작

1. `git log --follow docs/SPEC.md` 로 SPEC.md 변경 히스토리 확인.
2. 가장 최근 SPEC 변경 이후 PLAN/DESIGN/CHECKLIST 가 갱신됐는지 확인.
3. SPEC 변경 영역(섹션 단위)을 식별하고, 그 변경이 어느 다른 문서 섹션에 영향을 주는지 매핑:
   - SPEC "구현 범위" 변경 → PLAN §3 (스코프), CHECKLIST Phase C
   - SPEC "평가 기준" 변경 → PLAN §5 (평가 매핑), CHECKLIST `[§N]` 태그
   - SPEC "API 스키마" 변경 → DESIGN.md ADR (해당 데이터 구조)
   - SPEC "제약사항" 변경 → PLAN.md §3 (비스코프), DESIGN.md §6 (에러 처리)
4. drift 발견 시 표로 보고:
   ```
   SPEC change                          | Doc to update     | Status
   ------------------------------------|-------------------|--------
   §3 가산점 항목 추가 ("주간 비교 차트") | PLAN.md §3 표      | ❌ 미반영
   §5 §2 배점 25→30 변경                | PLAN.md §5 표      | ❌ 미반영
   §5 §2 배점 25→30 변경                | CHECKLIST §2 태그  | ✅ 반영
   ```

## 사용법

```
/spec-sync
```

옵션:
- `--since <commit-sha>` — 특정 커밋 이후 변경분만 점검
- `--diff-only` — drift 표만 출력 (자동 fix 제안 없이)

## 출력 예시

```
=== SPEC Drift Check ===

SPEC.md last modified: 2026-05-04 (commit a3b2c1d)
Documents checked since:
  PLAN.md       — last touched 2026-05-04 ✅
  DESIGN.md     — last touched 2026-05-03 ⚠ (before SPEC change)
  CHECKLIST.md  — last touched 2026-05-04 ✅
  README.md     — last touched 2026-05-02 ⚠

SPEC change summary:
  - §평가 기준 §3 추가 항목: "중복 저장 방지" (회사가 추가 요청)

Drift detected:
  | Where in SPEC                      | Required action                        |
  |------------------------------------|----------------------------------------|
  | §3 (안정성) "중복 저장 방지" 추가    | CHECKLIST §3 에 새 항목 추가, [§3] 태그 |
  | §3 점수 (현행 20점)                 | PLAN.md §5 표 점수 검증                |
  | §3 안내 문구                        | DESIGN.md "에러 처리 전략" 섹션        |

Recommendation: 위 3개 미반영. 별도 docs 커밋으로 동기화 후 작업 재개.
```

## 주의

- 이 커맨드는 SPEC.md 가 변경됐을 때만 의미 있음. 변경 없으면 "all in sync" 보고.
- AI는 자동으로 다른 문서를 수정하지 않음 — 사용자 확인 후 명시적 갱신.
- 회사 측 SPEC 갱신은 평가 시 직접 영향이므로 무시하지 말 것.
