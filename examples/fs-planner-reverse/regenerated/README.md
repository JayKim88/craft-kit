# {{PRODUCT}}

> {{COMPANY}} {{ROLE}} 채용 과제 제출물.

<!-- HINT: 한 줄 요약 (사용자 가치 + 핵심 도전). 예: "수강생이 한 주간 학습 스케줄을 시각적으로 편집·저장하는 SPA. 핵심: 시간 충돌 감지 + 편집/저장 상태 분리." -->

---

## 프로젝트 개요

<!-- HINT: SPEC 핵심 요구를 우리 말로 1-2단락 요약 + "이 과제에서 우리가 어디에 집중했는가" 명시.
     평가자가 가장 먼저 읽는 부분 — README의 첫인상이 평가 §{{DOC_CRITERION_INDEX}}에 직결. -->

{{PROJECT_OVERVIEW}}

---

## 기술 스택 및 선택 이유

### 핵심 인프라

<!-- HINT: 언어, 프레임워크, 주요 라이브러리. 각 항목에 1줄 근거. -->

| 기술 | 버전 | 이유 |
|---|---|---|
| ... | ... | ... |

### 자유 선택 영역 — 각 영역에서 가장 검증된 도구

<!-- HINT: SPEC이 "라이브러리 자유 선택 (선택 이유 README에 기술)" 라면 이 섹션이 평가 핵심.
     영역별로 "왜 이거 골랐고 왜 직접 구현 안 했는가" 명시. -->

| 영역 | 선택 | 이유 |
|---|---|---|
| ... | ... | ... |

### 의도적으로 추가하지 않은 것

<!-- HINT: 추가하지 않은 라이브러리. "선택의 의식적 배제" 시그널. -->

| 영역 | 선택 | 이유 |
|---|---|---|
| ... | ... | ... |

---

## 실행 방법

<!-- HINT: SPEC "실행 방법" 필수 섹션. 평가자 환경에서 동작 보장 위해 매우 구체적으로. -->

### 사전 요구사항

- {{TECH_RUNTIME}} {{RUNTIME_VERSION}}
- (기타)

### 설치 및 실행

```bash
# 1. 의존성 설치
{{INSTALL_COMMAND}}

# 2. 개발 서버 실행
{{DEV_COMMAND}}

# 3. 빌드 (선택)
{{BUILD_COMMAND}}
```

### 테스트

```bash
{{TEST_COMMAND}}
```

<!-- HINT: 테스트 카운트와 분류. 평가자가 한눈에 보도록.
     예시:
     | Tier | 대상 | 카운트 |
     |---|---|---|
     | 1. 순수 함수 | lib/time.ts | 69 |
     | 2. 컴포넌트 | components/* | 11 |
     | 3. 통합 | integration | 2 |
     | **합계** | | **82** |
-->

### Mock API 구성 (FE 과제만)

<!-- HINT: BE라면 이 섹션 삭제.
     FE: MSW / json-server / 정적 JSON 등 어떤 방식으로 mock 했는지 + SW detach 시 폴백 등 운영 고려. -->

{{MOCK_SETUP}}

### 개발 시나리오 URL 플래그 (선택)

<!-- HINT: 평가자가 에러/엣지 케이스를 쉽게 재현하도록 URL 플래그 제공.
     예시:
     - `?_seed=empty` — 빈 주차 시드
     - `?_seed=stress` — 100+ 블록 스트레스 테스트
     - `?_simulate=TIME_CONFLICT` — 충돌 에러 응답 트리거
     - `?_slow=2000` — 응답 2초 지연
-->

---

## 프로젝트 구조 설명

<!-- HINT: 폴더 트리 + 각 폴더 책임 1줄.
```
src/
├── app/         # ...
├── components/  # ...
├── hooks/       # ...
├── lib/         # 도메인 로직 (격리 모듈)
├── store/       # ...
└── types/       # ...
```
또는 BE: `src/{controllers,services,repositories,domain,middleware}` 등.
-->

```
{{PROJECT_TREE}}
```

| 폴더/파일 | 책임 |
|---|---|
| ... | ... |

---

## 요구사항 해석 및 가정

<!-- HINT: PLAN.md §2 "우리의 기획적 해석" 표를 평가자 친화적으로 옮긴다.
     SPEC에서 모호했던 부분과 우리 결정 + 근거. -->

{{REQUIREMENT_INTERPRETATION}}

### 선택 구현 (가산점)

<!-- HINT: 어떤 가산점 항목을 구현했고 어떤 것을 빼고 어떤 근거로 그랬는지. -->

{{BONUS_FEATURES_DECISIONS}}

---

## 설계 결정과 이유

<!-- HINT: SPEC의 README 템플릿 "설계 결정과 이유" 섹션은 평가 §{{DOC_CRITERION_INDEX}}의 핵심.
     DESIGN.md의 ADR을 평가자 친화적으로 5-8개 발췌. SPEC의 평가 §5 항목을 모두 커버하도록.

     fs-planner 사례 — 평가 §5에 다음 5항목 명시:
     1. 시간 충돌 판정 기준
     2. 서버 상태 vs 편집 상태 분리 방식과 이유
     3. 시간 로직 분리 + 그리드 UI 구현 방식
     4. 주간 요약 데이터 계산 위치 (프론트 vs 서버)
     5. 저장 전/후 상태 흐름

     본인 과제의 평가 §{{DOC_CRITERION_INDEX}} 세부 항목을 모두 다루는지 확인.
-->

### {{DECISION_1_TITLE}}

{{DECISION_1_BODY}}

### {{DECISION_2_TITLE}}

{{DECISION_2_BODY}}

<!-- ... 5-8개 -->

---

## 미구현 / 제약사항

<!-- HINT: 솔직 기재. 평가 §{{DOC_CRITERION_INDEX}}는 "구현하지 못한 부분이 있다면 이유와 대안 명시"를 명시적으로 봄.
     숨기지 말고 "X는 시간 부족으로 미구현, 대안은 Y" 식으로. -->

- {{LIMITATION_1}}
- {{LIMITATION_2}}

---

## AI 활용 범위

<!-- HINT: AI_USAGE.md 요약 + 링크.
     "AI 사용 자체는 감점 요소가 아닙니다. AI를 사용한 후 결과물을 얼마나 자기 것으로 만들었는지를 봅니다." (SPEC)
     → "내가 무엇을 결정·검증했는가"를 강조. -->

상세 내역은 [docs/AI_USAGE.md](docs/AI_USAGE.md) 참조.

**요약**:
- 1차 구현 대부분은 AI 협업으로 진행
- 의사결정 (라이브러리 선택, 알고리즘 경계값, 상태 분리 패턴) 은 본인이 옵션 비교 후 결정
- 발견된 이슈 (예: ...) 는 본인이 수정 방향 결정

---

## 참고 문서

- [docs/SPEC.md](docs/SPEC.md) — 회사 원본 명세 (불변)
- [docs/PLAN.md](docs/PLAN.md) — 우리의 기획·스코프·일정
- [docs/DESIGN.md](docs/DESIGN.md) — 아키텍처 결정 기록 (ADR)
- [docs/PROCESS.md](docs/PROCESS.md) — 구현 순서
- [docs/CHECKLIST.md](docs/CHECKLIST.md) — 진행 추적 + 평가 §N 매핑
- [docs/AI_USAGE.md](docs/AI_USAGE.md) — AI 협업 내역
- [CLAUDE.md](CLAUDE.md) — AI 협업 규칙·DoD·금기
