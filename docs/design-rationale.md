# Design Rationale

이 템플릿이 왜 이런 구조인지에 대한 기록. `fs-planner`(FuturSchool FE 과제, 5일, 5월 2-6일) 회고에서 검증된 패턴을 추출했음.

---

## 1. 왜 7-document SSOT인가

### 문제

채용 과제는 평가자가 짧은 시간 안에 **여러 축**을 평가해야 함:
- 요구사항 이해 (SPEC vs 우리 해석)
- 설계 능력 (왜 이 구조를 골랐나)
- 실행력 (얼마나 체계적으로 진행했나)
- 코드 품질 (테스트, 타입 안정성)
- 문서화 (README가 깔끔한가)
- AI 활용 능력 (인간/AI 책임 분리)

이걸 한두 개 문서에 욱여넣으면 평가자가 어디서 어떤 능력을 봐야 할지 알 수 없게 되고, 동시에 우리도 "지금 무엇을 의사결정 하고 있는지" 트래킹이 어려워짐.

### 결정: 책임별 문서 분리 (Single Source of Truth)

| 문서 | 단일 책임 | 평가자가 여기서 보는 능력 |
|---|---|---|
| **SPEC.md** | 회사 명세 (외부 계약, 불변) | 요구사항 이해의 출발점 |
| **PLAN.md** | 우리 해석·스코프·타임라인·리스크 | 우선순위·의사결정·계획 능력 |
| **DESIGN.md** | 아키텍처 결정·트레이드오프 | 설계 능력 (왜 X를 골랐나) |
| **PROCESS.md** | 구현 순서·의존성 그래프 | 실행 계획 능력 |
| **CHECKLIST.md** | 진행 상황 + 평가기준 매핑 | 꼼꼼함·완성도 추적 |
| **AI_USAGE.md** | AI가 한 일 vs 인간이 결정한 일 | AI 협업 책임 분리 |
| **CLAUDE.md** | AI 협업 그라운드 룰 | (평가자에게는 보너스) AI 통제력 |
| **README.md** | 위 모든 문서를 합성한 제출용 | 문서화 능력 |

**핵심 원칙**: 한 사실은 한 문서에만. 다른 곳에서 필요하면 링크.

### 왜 SPEC을 따로 빼는가

명세는 "외부 계약"이라 일단 paste 후 절대 수정 안 함. 우리 해석은 PLAN.md에 들어감. 이렇게 분리해야:
1. 평가 시 `git diff` 했을 때 "지원자가 명세를 멋대로 바꾼 건 아닌가" 의심받을 일 없음
2. 우리도 "회사가 시킨 일"과 "우리가 결정한 일"을 헷갈리지 않음

---

## 2. 왜 8-gate Definition of Done인가

### 문제

기능 구현 직후엔 모두 "다 된 것 같다"고 착각함. 그러나 평가 시점에:
- 빌드가 안 되거나
- 타입이 `any`로 도배돼 있거나
- 디버그용 `console.log`가 남아있거나
- 체크리스트와 실제 동작이 어긋나면

순식간에 감점됨. 5일 과제는 "마지막에 한 번 정리"할 시간이 없음.

### 결정: 매 커밋마다 8개 게이트 통과 필수

**자동 검증 가능 (5):**
1. `npm run lint` (혹은 해당 언어 lint) PASS
2. `test` PASS (모든 테스트 통과)
3. `build` PASS (TypeScript strict, 컴파일러 OK)
4. `grep -r ": any" src/` 결과 0 (혹은 명시적으로 허용된 케이스만)
5. `grep -r "console.log" src/` 결과 0 (warn/error 제외)

**수동 검증 (3):**
6. CHECKLIST.md 해당 아이템 `[x]` 마킹
7. AI_USAGE.md에 이번 작업의 AI 기여 로깅
8. 커밋 메시지가 컨벤션 준수 + `[§N]` 태그 포함

자동 5개는 `/dod-check` 슬래시 커맨드로 한 번에 검증. 수동 3개는 사용자 승인 절차에서 확인.

### 왜 8개여야 하나 (5도 7도 아닌)

5개로 줄이면 (자동만) 문서 동기화가 깨짐. 평가자는 코드와 README/체크리스트가 어긋나는 걸 가장 싫어함.

10개로 늘리면 (보안 점검 등 추가) 매 커밋이 부담돼서 결국 우회하게 됨. 5일 과제 페이스에선 8개가 한계.

---

## 3. 왜 `[§N]` rubric tagging인가

### 문제

평가자가 "코드 품질" 점수를 매길 때, 우리가 한 작업 중 **어디가** 코드 품질에 기여하는지 직접 찾아야 함. 100+ 커밋·체크리스트 200+ 아이템에서 그걸 찾는 건 시간 낭비.

### 결정: 모든 체크리스트·커밋이 평가 기준 §N 명시

```markdown
## §2 코드 구조와 설계 (25점)

- [x] [§2] State separation: TanStack Query (server) ⊥ Zustand (edit)
- [x] [§2] Time logic isolated in `lib/time.ts` (pure functions only)
- [x] [§2] No direct cache mutation; sync via `setQueryData` after PUT success
```

커밋 메시지에도:
```
test(time): cover boundary, overlap, and grid math [§3]

- 69 unit tests across DST, week math, conflict detection
- All edge cases passing
```

### 효과

- 평가자가 §2 점수 매길 때 `git log --grep "\[§2\]"` 한 번에 모든 기여 작업 확인
- 우리도 작업할 때 "이거 어느 평가 항목에 기여하지?"가 머릿속에서 명확해짐
- "체크리스트는 다 했는데 점수 부족한" 케이스를 사전에 잡을 수 있음 (§5에 1개도 없으면 위험 신호)

---

## 4. 왜 commit-by-commit user approval인가

### 문제

AI 협업에서 가장 흔한 실수: AI가 5-10개 변경을 한 번에 커밋해버림. 이러면:
- 평가자가 git history를 봐도 "한 사람이 천천히 작업한 게 아니라 AI가 갈아버린 느낌"
- 한 커밋이 lint 깨면 5-10개 변경이 함께 깨짐
- 롤백할 때 단위가 너무 커서 못 되돌림

### 결정: 한 기능 = 한 커밋, 사용자 승인 필수

CLAUDE.md의 "Absolute Prohibitions":
> **Never commit without user approval.** Even single-line fixes. AI must show the file list + commit message + DoD result, wait for explicit approval.

### 효과 (fs-planner 검증)

- 61개 커밋, 평균 18줄 변경/커밋 (linear, 깔끔)
- 평가 기준 §6 (Git history, 10점) 만점 가능 구조
- 어떤 커밋도 "롤백하면 다른 기능 깨지는" 결합도 없음

---

## 5. 기술-중립으로 가는 이유

### 대안 검토

- **A안 (Next.js+TS 기본 스택 고정)**: 빠르지만 BE/ML 과제에서 깡통이 됨
- **B안 (FE/BE/FS 3종 분기)**: 유연하지만 변종 유지 비용 ↑
- **C안 (기술 중립, placeholder만)**: 첫 시동(scaffold)이 느리지만 어떤 과제든 적용 가능

`fs-planner`는 FE였지만 다음 과제가 BE일 가능성 충분. 따라서 C안.

DESIGN.md는 "Decision Records" 포맷(옵션·기준·결정·근거 4컬럼)으로 만들어, 기술 결정 자체를 사용자가 채우게 함. 이게 오히려 평가자에게 "이 사람이 기술 선택의 이유를 명시하는 사람"이라는 시그널을 줌.

---

## 6. 의도적으로 빠진 것

| 항목 | 이유 |
|---|---|
| Boilerplate 코드 (Next.js scaffold 등) | 기술 중립이라 불가 + 어차피 `create-next-app` 등이 더 잘함 |
| 자동 평가/채점 | 평가는 회사가 함. 우리는 시뮬레이션(`rubric-reviewer`)만 |
| CI/CD 셋업 | 채용 과제는 보통 로컬 평가. 필요시 사용자 추가 |
| 다국어 변형 | v2. 현재는 한국어 분석문서/영어 코드/영어 커밋 1세트 |
| Web UI | 불필요. CLI로 충분 |

---

## 7. 검증 가설

이 템플릿은 다음 조건에서 가치 있음:
- **5-10일짜리 채용 과제** (3일 미만은 오버헤드, 2주+는 과제 한계)
- **평가 기준이 명시적** (rubric tagging 의미 있음)
- **AI 협업 허용** (AI_USAGE.md가 의미 있음)

위 조건에 맞지 않으면 일부 문서(SPEC/PLAN/DESIGN/PROCESS/CHECKLIST/README)만 활용하거나, 단순 README + 체크리스트로 축소 사용.
