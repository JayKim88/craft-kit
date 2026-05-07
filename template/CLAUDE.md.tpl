# {{COMPANY}} {{ROLE}} — {{PRODUCT}} / AI 협업 컨텍스트

> AI(Claude)와 협업할 때의 ground truth.
> 컨텍스트와 **규칙**(코딩·커밋·DoD·금기) 만 담는다.
> 그 외는 단일 책임 문서로 라우팅한다.

---

## 문서 라우팅 (단일 책임 원칙 / SSOT)

작업 중 정보를 찾을 때, 어느 문서를 봐야 하는지:

| 무엇을 찾는가 | 어디에 있는가 |
|---|---|
| 외부 명세 (불변 계약) | [SPEC.md](docs/SPEC.md) |
| **평가 기준 (작업 시 점수 항목 확인)** | **[SPEC.md "## 평가 기준 (세부)"](docs/SPEC.md) + [CHECKLIST.md](docs/CHECKLIST.md) 인라인 `[§N]` 표기** |
| 우리의 기획 (제품 정의·스코프·일정·가산점 우선순위·평가 매핑) | [PLAN.md](docs/PLAN.md) |
| 설계 결정 (아키텍처·라이브러리 선택·트레이드오프) | [DESIGN.md](docs/DESIGN.md) |
| 작업 진행 흐름 (Phase, 의존 그래프, 커밋 사이클) | [PROCESS.md](docs/PROCESS.md) |
| 할 일 목록 / 진행 상태 | [CHECKLIST.md](docs/CHECKLIST.md) |
| AI 사용 규칙·코딩 규칙·DoD·금기 | **이 문서** |
| AI 사용 내역 (제출용) | [AI_USAGE.md](docs/AI_USAGE.md) |
| 평가자 대면 출력물 | [README.md](README.md) |

원칙: **한 정보는 한 문서에만 있어야 한다.** 중복 발견 시 SSOT 문서로 합치고 다른 곳은 링크로 대체.

---

## 과제 개요 (컨텍스트)

- **마감**: {{DEADLINE_DATE}} ({{DEADLINE_TIME}})
- **과제**: {{TASK_TYPE}} — {{PRODUCT}}
- **평가 핵심**: {{ONELINE_CHALLENGE}}

상세 기획·스코프·일정 → [PLAN.md](docs/PLAN.md)

---

## 기술 스택

<!-- HINT: 기술 결정 후 채운다. 결정 전이라면 DESIGN.md "기술 선택 이유" 섹션에서 비교 후 확정.
     예시 표 형식 (역할별):
     | 기술 | 버전 | 용도 |
     |---|---|---|
     | <Runtime> | <X.Y> | 런타임 |
     | <Framework> | <X.Y> | 프레임워크 |
     | <Language> | strict | 타입 안전성 |
-->

| 기술 | 버전 | 용도 |
|------|------|------|
| {{STACK_HINT}} |  |  |

기술 선택 근거 → [DESIGN.md](docs/DESIGN.md) "기술 선택 이유"

---

## 환경 주의사항 (선택)

<!-- HINT: 사용 프레임워크/언어가 학습 데이터와 다른 점이 있으면 여기에 명시.
     예: "Next 16 비동기 dynamic API", "Python 3.13 deprecation", "Java 21 record patterns" 등.
     해당 사항 없으면 이 섹션 자체를 삭제. -->

---

## 코딩 규칙

<!-- HINT: 언어/프레임워크별로 조정. 아래는 TypeScript 기준 기본값. -->

- 타입 우회 금지 (`any` / `unknown` / `as any` 의도 없는 사용 금지)
- 디버깅 코드 금지 (`console.log` / `print()` / `dbg!()` 등 — 의도된 로깅(error/warn)은 허용)
- **도메인 로직은 도메인 모듈에 격리** — 컴포넌트/엔드포인트에서 직접 계산 금지 (예: 시간 계산은 `lib/time.ts`, 권한 계산은 `lib/auth.ts` 등)
- 상태 분리 원칙 — 서버 상태와 편집/UI 상태를 혼용하지 않음 (단방향 흐름 유지)
- **각 항목 구현 시 [CHECKLIST.md](docs/CHECKLIST.md) 의 `[§N]` 표기를 확인 → [SPEC.md "평가 기준 (세부)" §N](docs/SPEC.md) 의 "높은 숙련도" 기준을 충족하는 방향으로 작업한다.**

상세 상태 흐름 → [DESIGN.md](docs/DESIGN.md)

---

## 커밋 컨벤션

형식: `<type>(<scope>): <subject> [§N]`

- **type**: `feat | fix | refactor | test | chore | docs | style | perf`
- **scope**: 프로젝트별 정의 (예: `types | core | api | ui | nav | a11y | mocks` — `<!-- HINT: 프로젝트 시작 시 5-10개로 확정 -->`)
- **subject**: 영문, 명령형, 50자 이내
- **`[§N]`**: 평가 기준 번호. 다중이면 `[§2,§3]`. 인프라/도구 작업은 `[§-]` 명시

예시:
- `feat(api): add user authentication endpoint [§2,§3]`
- `test(core): cover boundary cases for time conflict [§3]`
- `refactor(ui): extract validation hook [§2]`
- `chore(deps): upgrade test framework [§-]`

커밋 순서·의존 관계 → [PROCESS.md](docs/PROCESS.md) + [CHECKLIST.md](docs/CHECKLIST.md)

---

## Definition of Done (각 feature 커밋)

| # | 게이트 | 검증 명령 |
|---|---|---|
| 1 | Lint clean | `<!-- HINT: npm run lint / ruff check . / cargo clippy 등 -->` |
| 2 | Tests green | `<!-- HINT: npm test / pytest / cargo test 등 -->` |
| 3 | Build OK | `<!-- HINT: npm run build / mvn package / cargo build 등 -->` |
| 4 | No type-escape | `grep -rn ': any' src/` → 0 (TypeScript) / 언어별 등가 점검 |
| 5 | No debug logs | `grep -rn 'console\.log\|print(\|dbg!' src/` → 0 |
| 6 | CHECKLIST 항목 [x] 갱신 | — |
| 7 | AI_USAGE.md 항목 추가 (AI 사용 시) | — |
| 8 | 커밋 메시지가 컨벤션 준수 + `[§N]` 태그 | — |

1~5는 코드/품질 게이트(자동), 6~8은 평가 대응 게이트(수동).

`/dod-check` 슬래시 커맨드로 한 번에 자동 게이트 5개 + 동기화 검증 가능.

---

## Git / 작업 흔적 (평가 §{{GIT_CRITERION_INDEX}} 대응)

평가 기준에서 git history 가 직접 평가 항목인 경우, 다음을 지킨다:

- **의미 단위 커밋**: 한 커밋 = 한 의미 단위. [PROCESS.md](docs/PROCESS.md) 단계와 정렬.
- **한 번에 dump 금지**: 마지막에 전체를 한 커밋으로 묶지 않는다 (감점 명시).
- **refactor / test 별도 커밋 (가산점)**: 기능 구현과 별도로 `refactor:` / `test:` 커밋을 두면 가산점.
- **사용자 승인 필수**: 모든 커밋은 사용자 명시적 허가 후에만 실행. AI는 자율적으로 `git commit` 하지 않는다.

  **커밋 승인 요청 시 항상 포함:**
  1. 스테이징 대상 파일 목록 + 핵심 변경 요약
  2. 제안 커밋 메시지 (전체 본문, `[§N]` 포함)
  3. DoD 게이트 통과 결과 (lint / test / build / no any / no debug-log)
  4. **문서 동기화 필요 여부 체크 결과** — 다음을 매 커밋 직전 점검:
     - [docs/CHECKLIST.md](docs/CHECKLIST.md): 이번 커밋으로 완료된 항목이 [ ] 로 남아있는가?
     - [docs/AI_USAGE.md](docs/AI_USAGE.md): 이번 작업에서 AI 활용 항목이 누락되었는가?
     - [docs/DESIGN.md](docs/DESIGN.md) / [docs/PLAN.md](docs/PLAN.md) / [README.md](README.md): 설계 결정·스코프·인터페이스 변경이 미반영된 것이 있는가?
     - 필요한 경우 처리 옵션 제안: (a) 본 커밋에 포함 / (b) 별도 docs 커밋 / (c) 누적 후 일괄 동기화

---

## 절대 하면 안 되는 것

- **커밋을 사용자 승인 없이 실행하지 않는다** (위 §Git 참조)
- SPEC.md / AGENTS.md 를 임의로 수정하지 않는다 (각각 외부 계약 / 환경 제공 문서)
- 편집 상태와 서버 상태를 혼용하지 않는다 (단방향 흐름)
- 도메인 로직을 컴포넌트/엔드포인트에 인라인하지 않는다 (격리 원칙)

<!-- HINT: 프로젝트 도메인에 따라 추가 금지 항목 정의. 예:
- TanStack Query cache를 직접 mutate 하지 않는다
- DB transaction을 service layer 외부에서 시작하지 않는다
- 인증된 사용자 컨텍스트 없이 권한 검증을 우회하지 않는다
-->
