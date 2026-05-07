# PROCESS — 구현 순서

> [SPEC.md](SPEC.md) "구현 범위" 의 순서대로 구현한다.
> 각 단계의 세부 항목과 평가 기준 매핑 → [CHECKLIST.md](CHECKLIST.md) 의 동일 번호 섹션
> 작업 규칙(커밋 컨벤션·DoD·금기) → [CLAUDE.md](../CLAUDE.md)
> 모든 커밋은 사용자 승인 후 실행

---

## Phase 0. 사전작업 (인프라)

<!-- HINT: 사용자에게 안 보이지만 다음 Phase를 위해 먼저 필요한 것들.
     예시 (FE):
     - 타입 정의 (src/types/)
     - 도메인 로직 + 단위 테스트 (src/lib/<domain>/)
     - Mock API 핸들러 (src/mocks/)
     - 상태 관리 셋업 (src/store/, src/hooks/)
     예시 (BE):
     - DB 스키마 + 마이그레이션
     - 도메인 모델 + 단위 테스트
     - 로깅·에러 미들웨어
     - 환경 변수 / config
-->

- ...
- ...

→ **의존 순서**: `{{INFRA_DEPENDENCY_CHAIN}}`

<!-- HINT 예시: types → domain-lib → mocks → providers → store → hooks → UI -->

---

## Phase 1. {{REQUIRED_FEATURE_1_NAME}} (SPEC 필수 #1)

<!-- HINT: SPEC의 첫 번째 필수 구현 항목. 세부 작업 5-10개 bullet. -->

- ...
- ...

→ 컴포넌트/모듈 구현 순서: `...`

---

## Phase 2. {{REQUIRED_FEATURE_2_NAME}} (SPEC 필수 #2)

<!-- HINT: SPEC의 두 번째 필수 구현 항목. -->

- ...

---

## Phase 3. 선택 구현 (가산점)

<!-- HINT: SPEC "선택 구현" 항목들. 우선순위 기준은 PLAN.md §3 표 참조.
     "5개 모두 구현 예정" 식으로 적극 명시 (드롭은 비상 컷 라인). -->

1. ...
2. ...
3. ...

Phase 0~2 완료 후 진입. 비상 컷 라인 (우선순위) 은 [PLAN.md §3](PLAN.md) 안전망 표 참조.

---

## Phase 4. 마무리

- 수동 스모크 테스트 (CHECKLIST.md "4. 마무리" 의 N항목)
- README "미구현 / 제약사항" 채움
- AI_USAGE.md 최종 정리
- Repository public 설정 후 제출

---

## 작업 사이클 (각 Phase마다 반복)

```
구현 → DoD 게이트 (lint / test / build / no-any / no-debug-log)
     → CHECKLIST 항목 [x] + AI_USAGE 갱신 (AI 사용 시)
     → 사용자 승인 → 커밋
```

DoD 상세 → [CLAUDE.md](../CLAUDE.md)

`/dod-check` 슬래시 커맨드로 한 번에 자동 게이트 검증 가능.
