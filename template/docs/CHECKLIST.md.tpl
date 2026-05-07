# 구현 체크리스트

> 진행 추적 + 평가 기준 검증.
> 항목 순서는 [PROCESS.md](PROCESS.md) 의 Phase 와 정렬.
> 각 항목의 `[§N]` 표기는 [SPEC.md "평가 기준 (세부)"](SPEC.md) 의 카테고리 번호.

---

## Phase A — 문서 정합성

<!-- HINT: 작업 시작 전 모든 문서가 정렬됐는지 확인. -->

- [ ] CLAUDE.md (DoD + 커밋 컨벤션 + 평가 기준 참조)
- [ ] CHECKLIST.md (평가 §N 인라인 매핑 — 본 문서)
- [ ] PROCESS.md (구현 순서)
- [ ] PLAN.md (스코프·일정·리스크 매트릭스·평가 매핑)
- [ ] DESIGN.md (Decision Records 5-10개)
- [ ] SPEC.md (회사 원본 paste, 평가 기준 §1~§N)
- [ ] README.md 골격 (SPEC 템플릿 섹션 + 평가 §{{DOC_CRITERION_INDEX}} 항목)
- [ ] 자유 라이브러리 결정 (DESIGN.md §4)
- [ ] UI/UX 참고 결정 (FE 과제만, DESIGN.md §7)

## Phase B — 기술스택·아키텍처 락

<!-- HINT: 첫 코드 한 줄 쓰기 전 도구체인이 동작하는지 검증. -->

- [ ] 런타임/언어 버전 고정 (.nvmrc / .python-version / Dockerfile 등)
- [ ] `<lint command>` clean
- [ ] `<test command>` passing
- [ ] `<build command>` passing
- [ ] 타입 체커 strict 모드 통과 (해당 시)

---

# Phase C — 구현 (PROCESS 순서)

## 0. 사전작업 (인프라)

<!-- HINT: PROCESS.md Phase 0 항목들을 작업 단위로 분해. 각 항목에 [§N] 태그. -->

### 환경

- [ ] {{TECH_RUNTIME}} 셋업
- [ ] {{TECH_FRAMEWORK}} 셋업
- [ ] 폴더 구조

### 추가 라이브러리 설치 (자유 선택 영역, DESIGN.md §4)

- [ ] ...

### 타입 / 모델 정의

- [ ] ...

### 도메인 로직 + 단위 테스트 `[§{{DESIGN_CRITERION_INDEX}} 도메인 로직 분리]`

- [ ] ...
- [ ] ...

### 도메인 단위 테스트 `[§{{REQ_CRITERION_INDEX}} 경계값 명시]`

- [ ] 일반 케이스
- [ ] 경계값 케이스
- [ ] ...

### Mock API / 외부 의존성 더블

- [ ] ...

### 상태 관리 셋업 (FE) / DB·트랜잭션 셋업 (BE)

- [ ] ...

---

## 1. {{REQUIRED_FEATURE_1_NAME}} (SPEC 필수 #1)

<!-- HINT: 세부 작업 + [§N] 매핑. fs-planner 예시처럼 5-15개 항목. -->

- [ ] ... `[§N]`
- [ ] ... `[§N]`

### 엣지 케이스 `[§{{REQ_CRITERION_INDEX}} 엣지 케이스 인식]`

- [ ] 긴 데이터 / 큰 입력
- [ ] 빈 상태
- [ ] 경계값 (자정, 0원, 최대값 등)
- [ ] 동시성 (해당 시)
- [ ] 성능 (N개 이상 시 재렌더/쿼리)

---

## 2. {{REQUIRED_FEATURE_2_NAME}} (SPEC 필수 #2)

- [ ] ...

---

## 3. 선택 구현 (가산점)

> 정상 완료 = 아래 N개 항목 모두 [x]. 비상 컷 라인 발동 시(필수 위협) 만 일부 미완 허용.

- [ ] {{BONUS_FEATURE_1}}
- [ ] {{BONUS_FEATURE_2}}
- [ ] ...

---

## 4. 마무리

### 수동 스모크 테스트

- [ ] fresh install + dev 서버 부팅
- [ ] 초기 시드 데이터 정확히 렌더/응답
- [ ] 핵심 플로우 1: <!-- HINT: 가장 중요한 사용자 시나리오 -->
- [ ] 핵심 플로우 2: ...
- [ ] 에러 케이스 1: ...
- [ ] 에러 케이스 2: ...
- [ ] 빈 상태 처리
- [ ] 경계값 (시간/숫자/문자열 길이)
- [ ] 100개 이상 데이터에서 성능
- [ ] 모든 테스트 PASS
- [ ] Lint clean
- [ ] Build PASS

### 문서 마무리

- [ ] README "프로젝트 개요 / 기술 스택 / 실행 방법 / 구조 설명"
- [ ] README "요구사항 해석 및 가정"
- [ ] README "설계 결정과 이유" — 평가 §{{DOC_CRITERION_INDEX}} 항목 모두 포함
- [ ] README "미구현 / 제약사항"
- [ ] README "AI 활용 범위" — AI_USAGE.md 링크
- [ ] AI_USAGE.md 최종 정리

### 제출

- [ ] Repository public
- [ ] Public URL 제출
- [ ] (선택) `rubric-reviewer` subagent로 평가 시뮬레이션

---

## 📌 추가 TODO (커스텀, 선택 항목)

> 작업 중 발견된 개선 항목. 필수 + 가산점 완료 후 시간 허용 시 진행.
>
> **우선** 범례: 🔴 높음 (평가 직접 영향) / 🟡 중간 / 🟢 낮음 (polish)
> **상태** 범례: [ ] 대기 / [-] 진행 중 / [x] 완료 / [~] 드롭

| 우선 | 상태 | 항목 | 영역 | 발견 출처 |
|------|------|------|------|----------|
| 🟡 | [ ] | ... | ... | ... |
