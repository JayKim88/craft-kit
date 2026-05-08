# Workflow Guide

`recruit-kit`로 부팅한 새 과제 폴더에서 사용하는 워크플로우 — **원칙·철학** 중심.

> **시간순 walkthrough**(D-5 부팅 → D-0 제출, 명령 단위 따라가기)는 [walkthrough.md](walkthrough.md). 이 문서는 그 안에서 매 사이클 반복되는 원칙 (Phase 단위·커밋 컨벤션·AI_USAGE 운영·FAQ) 을 다룹니다.

---

## 전체 흐름

```
D-N (마감 N일 전)                           산출물
─────────────────────────────────────────────────────────
D-N    : SPEC.md 채우기                     SPEC.md (불변)
D-N    : 평가 기준 추출 → CHECKLIST §N      CHECKLIST.md 골격
D-N+0~1: PLAN.md (스코프·타임라인·리스크)   PLAN.md
D-N+1~2: DESIGN.md (Decision Records)       DESIGN.md
D-N+2  : PROCESS.md (Phase 의존성)          PROCESS.md
D-N+2~ : 구현 → 매 커밋마다 8-gate DoD      코드 + 커밋 + AI_USAGE.md 갱신
D-1    : Polish (manual smoke, a11y)        모든 게이트 PASS
D-0    : README 합성·제출                   README.md 최종
```

---

## Phase별 가이드

### Phase A: 명세 정렬 (D-N)

1. SPEC.md의 `<!-- SPEC PASTE START -->` 영역에 회사 명세 paste
2. 평가 기준이 명시돼 있다면 §1, §2... 섹션으로 정리, 배점 기록
3. **명세에 모호한 부분이 있으면 PLAN.md "우리 해석" 섹션에 명시** (SPEC은 절대 수정 안 함)
4. `/dod-check`로 초기 상태 확인 (대부분 FAIL일 텐데, 그게 정상)

### Phase B: 기획·설계 (D-N+0~2)

1. PLAN.md
   - 우리 정의의 제품/기능 (1단락)
   - 명세 모호점 → 우리가 어떻게 해석했는가 + 면접/이메일 질문 후보
   - 스코프: 필수 N개 + 선택(보너스) M개
   - 타임라인 (D-N → D-0)
   - 리스크 매트릭스
   - 평가기준 매핑 (§N → 어떤 기능/문서가 기여)

2. DESIGN.md
   - "Decision Records" 표 형식: `옵션 | 기준 | 결정 | 근거 | 트레이드오프`
   - 핵심 의사결정 5-10개 (예: 상태 관리 라이브러리, 테스트 전략, 에러 처리 패턴)
   - **"왜 이걸 안 골랐나"도 명시** (평가자가 가장 점수 주는 부분)

3. PROCESS.md
   - Phase 0~N으로 분해, 각 Phase의 의존성 그래프
   - 예: `types → core lib → integration → UI → polish`
   - 병렬 가능한 작업 vs 순차 작업 구분

### Phase C: 구현 (D-N+2 ~ D-1)

매 기능마다 다음 사이클:

```
1. 구현 (코드)
2. 자동 게이트 검증
   ├─ npm run lint
   ├─ npm test
   ├─ npm run build
   ├─ grep ": any" src/  → 0개?
   └─ grep "console.log" src/  → 0개?
3. 수동 게이트 검증
   ├─ CHECKLIST.md 해당 §N 아이템 [x]?
   ├─ AI_USAGE.md에 이번 작업 행 추가?
   └─ 커밋 메시지: <type>(<scope>): <subject> [§N]
4. 사용자 승인 (Claude는 Bash로 git commit 자동 실행 ❌, 사용자가 명시 승인)
5. git commit
```

`/dod-check` 한 번에 자동 게이트 5개 + 수동 동기화 검증 가능.

### Phase D: Polish (D-1)

- Manual smoke test 시나리오 5-10개 작성·실행
- Accessibility 체크 (FE인 경우)
- Performance 체크 (필요 시)
- README.md 최종 정리 (PLAN/DESIGN에서 합성)

### Phase E: 제출 (D-0)

1. `git log --oneline | head -30` 확인 (커밋 히스토리가 깔끔한가)
2. `rubric-reviewer` 서브에이전트로 평가 시뮬레이션
3. 약점 보고서 검토 → 시간 남으면 보강
4. 제출

---

## 커밋 컨벤션

```
<type>(<scope>): <subject> [§N]

[body — optional]

[footer — optional]
```

**type**: `feat | fix | refactor | test | chore | docs | style | perf`

**scope**: 프로젝트별로 정의 (예: `time | grid | modal | save | summary | a11y | mocks`)

**subject**: imperative, 50자 이내, 영어

**`[§N]`**: 평가 기준 번호. 다중이면 `[§2,§3]`. 인프라 작업 등은 `[§-]` 명시.

**예시**:
```
feat(grid): render saved blocks with conflict highlighting [§2,§4]
test(time): cover boundary, overlap, grid math [§3]
docs(readme): add test architecture table [§5]
fix(save): Safari disabled tooltip; mark manual smoke complete [§4]
chore(deps): upgrade vitest to v4 [§-]
```

---

## AI_USAGE.md 운영

매 커밋마다 1행 추가. 표 형식:

| # | 시각 | AI가 한 일 | 인간이 결정/수정한 일 | 비고 |
|---|------|-----------|---------------------|------|

**중요**: "AI가 코드 짰음"으로 끝내지 말고, **인간이 무엇을 결정·수정했는지** 명시. 평가자는 "AI를 도구로 쓸 줄 아는 사람"을 보고 싶지 "AI에 떠넘기는 사람"을 보고 싶지 않음.

좋은 예:
> AI가 conflict detection 알고리즘 초안을 작성. 인간이 boundary case (`a.start < b.end` vs `≤`) 검토 후 strict inequality로 수정 (touching is not overlap).

나쁜 예:
> AI가 conflict detection 구현.

---

## 자주 묻는 질문

**Q. 매 커밋마다 사용자 승인 진짜 필요해?**
A. 네. fs-planner 회고 검증. AI가 한 번 폭주하면 5-10개 변경이 한 커밋에 들어가고, 그 후엔 git history가 망가짐. 평가 기준에 "Git history" 점수가 있으면 직접 영향.

**Q. CHECKLIST.md를 200개 아이템으로 만드는 게 부담인데?**
A. 시작은 §N별 5-10개로 충분. 작업하면서 새 아이템 발견하면 추가. 처음부터 200개 만들 필요 없음.

**Q. AI_USAGE.md 너무 자세하게 적으면 시간 낭비 아닌가?**
A. 1행 = 1줄로. 30초면 됨. 총 30-50행이면 충분 (fs-planner는 32행).
