# Customizing for Different Assignment Types

`recruit-kit` 은 기술-중립이지만, 과제 유형별로 어떻게 커스터마이즈할지 가이드.

---

## FE (Frontend) 과제

**대상**: React/Vue/Angular SPA, Next.js, 시각화 UI, 시간 기반 UI 등

### CLAUDE.md 추가 코딩 규칙
- 컴포넌트는 책임별 분리 (Presentational vs Container)
- 상태 분리: 서버 상태(TanStack Query/SWR) ⊥ 편집/UI 상태(Zustand/Redux/useState)
- 시간/계산 로직은 `src/lib/<domain>.ts` 에 격리 (컴포넌트 내부 계산 금지)
- a11y: focus ring, ARIA, keyboard nav

### DESIGN.md 추가 ADR 슬롯
- 상태 관리 라이브러리 (TanStack Query / Zustand / Redux / Jotai)
- Mock API 전략 (MSW / json-server / 정적 JSON)
- 모달/접근성 라이브러리 (Radix / Headless UI / 직접)
- 토스트 (react-hot-toast / Sonner / 직접)
- 차트 (Recharts / D3 / 직접 SVG)

### CHECKLIST.md 추가 항목
```
### 그리드/리스트 시각화 (FE 공통)
- [ ] 정확한 위치 계산 (CSS Grid / absolute / flex)
- [ ] 가독성 — 타이포그래피, 색상 대비
- [ ] 충돌/오버랩 시각적 구분
- [ ] 빈 상태 처리

### 폼/모달 (FE 공통)
- [ ] 검증 (서버 사전 검증 + UI 즉시 피드백)
- [ ] 키보드 nav (Tab, Esc, Enter)
- [ ] focus trap

### 반응형 (FE 공통)
- [ ] 모바일 뷰 (필요 시)
- [ ] 접근성 키보드 흐름
```

### 테스트 전략 (FE)
- Tier 1: 도메인 로직 (시간 계산·정렬·필터) — 순수 함수, 가장 많은 테스트
- Tier 2: RTL 컴포넌트 — 자동완성, 검증, 충돌 표시
- Tier 3: 통합 — 캐시 동기화, 에러 처리

---

## BE (Backend) 과제

**대상**: REST API, GraphQL, CRUD, 스케줄링, 정산, 알림 시스템

### CLAUDE.md 추가 코딩 규칙
- DB 트랜잭션은 service layer 에서만 시작 (controller/middleware 에서 ❌)
- 인증된 user context 없이 권한 검증 우회 ❌
- 동시성: optimistic vs pessimistic 명시적 결정
- 모든 API 응답은 명시적 schema (자동 생성 ❌, 검증된 typed schema)

### DESIGN.md 추가 ADR 슬롯
- DB 선택 (Postgres / MySQL / Redis / NoSQL)
- ORM (Prisma / TypeORM / Sequelize / 직접 SQL)
- 인증 (JWT / Session / OAuth)
- 동시성 제어 (transaction isolation / optimistic locking)
- 멱등성 (idempotency key / 자연 멱등성)
- 재시도/타임아웃 (exponential backoff / circuit breaker)
- 로깅·모니터링

### CHECKLIST.md 추가 항목
```
### 동시성 (BE 공통)
- [ ] 동시 요청 시 race condition 없음
- [ ] Optimistic locking 또는 transaction isolation 명시
- [ ] 정원/한도 도달 시 정확한 응답

### 멱등성 (BE 공통)
- [ ] 동일 요청 N번 → 결과 1번
- [ ] idempotency key 또는 자연 키 처리

### 데이터 정확성
- [ ] 정산/집계 경계값 (월말, 자정 근처, timezone)
- [ ] 부분 실패 시 일관성 유지 (transaction rollback / saga)
- [ ] 외부 API 호출 실패 시 재시도/dead letter

### 운영
- [ ] 구조화된 로깅 (request id, trace)
- [ ] 에러 응답 표준화 (code + message + details)
- [ ] OpenAPI / 문서 자동 생성
```

### 테스트 전략 (BE)
- Tier 1: 도메인 로직 (정산 계산·상태 전이) — 순수 함수
- Tier 2: API 엔드포인트 (request → response, 인증/권한)
- Tier 3: 통합 (실제 DB, 트랜잭션, 동시성 시나리오)

---

## ML/Data 과제

**대상**: 모델 학습, 평가 파이프라인, 데이터 처리

### CLAUDE.md 추가 코딩 규칙
- Random seed 고정 (재현 가능성)
- Train/val/test 분리 명시
- Feature engineering 파이프라인을 코드로 (notebook out of CI)
- Model versioning (실험별 metric 기록)

### DESIGN.md 추가 ADR 슬롯
- Framework (PyTorch / TF / sklearn / JAX)
- Experiment tracking (W&B / MLflow / 자체)
- Data 분할 전략 (random / time-based / stratified)
- 평가 메트릭 (accuracy / F1 / AUC / RMSE)
- 베이스라인 비교

### CHECKLIST.md 추가 항목
```
### 재현 가능성
- [ ] Random seed 고정
- [ ] Requirements lock (pyproject.toml / requirements.txt)
- [ ] 데이터 전처리 파이프라인이 결정론적

### 평가
- [ ] 베이스라인 비교 (단순 모델 vs 제안 모델)
- [ ] 통계적 유의성 (CV, std)
- [ ] Edge case (out of distribution, class imbalance)
```

---

## Mobile 과제

**대상**: React Native, Flutter, iOS/Android native

### CLAUDE.md 추가 코딩 규칙
- 화면 회전 처리
- 백그라운드/포그라운드 전환
- 권한 요청 흐름 (위치/카메라/푸시)

### DESIGN.md 추가 ADR 슬롯
- 네비게이션 라이브러리 (React Navigation / Flutter Navigator 2.0)
- 상태 관리
- 오프라인 처리
- 푸시 알림

### CHECKLIST.md 추가 항목
- 다양한 디바이스 크기 대응
- iOS/Android 네이티브 차이
- 권한 거부 시 UX

---

## 공통: 평가 기준이 6개가 아닐 때

`init.mjs` 의 `CRITERIA_COUNT` 입력에서 1-9 자유 선택. 일반적으로:

- **5개**: 요구사항 / 코드 / 안정성 / 문서화 / git
- **6개** (fs-planner): + UI/UX
- **7개**: + 성능 / 또는 + 보안

평가 기준이 0개 (회사가 명시 안 함)이면:
1. SPEC 의 "면접 연계 질문" / "판단 근거" / "실무 시나리오" 등에서 역추론
2. 추론한 카테고리를 `CHECKLIST.md` 에 §1~§N 으로 명시
3. PLAN.md §5 "평가 대응 매핑" 에서 우리가 가정한 가중치 명시

평가자가 "이 사람이 자기 평가 기준을 만들어 일하네"로 받음 — 추가 점수 가능.

---

## 공통: 도구 부재 시

기존 프로젝트의 lint/test 셋업이 없거나 다른 형태일 때 `/dod-check` 가 못 돌아감.

해결:
1. Phase B (기술스택 락) 에서 lint/test/build 명령 확정
2. `package.json` / `pyproject.toml` / `Cargo.toml` 등에 표준 명령 추가:
   - `lint`, `test`, `build`
3. `/dod-check` 가 자동 추론하도록

수동 명령:
```bash
# Manual DoD check
npm run lint && npm test && npm run build && \
  ! grep -rn ': any\|console\.log' src/ && \
  echo "DoD: 5/5 auto gates passed"
```
