# 작업 가이드 — 지금 어디 있고 다음은 무엇인가

> **대상**: 과제 진행 중 "내가 지금 뭘 해야 하지?"가 헷갈릴 때 참고하는 운영 지도.
> 구조 설명 → [OVERVIEW.md](OVERVIEW.md) / 설계 원칙 → [HARNESS.md](HARNESS.md)

---

## 역할 범례

| 표시 | 의미 |
|---|---|
| 👤 | **사용자 결정 필요** — AI가 대신할 수 없음 |
| 🤖 | **AI 실행** — 트리거 발화 후 AI가 처리 |
| ⚙️ | **자동** — git / script가 개입 없이 실행 |

---

## 상태 1 — Phase A (문서 정렬)

**판단 기준**: SPEC이 없거나 PLAN/DESIGN이 미작성 상태

```mermaid
flowchart TD
    A1["👤 docs/SPEC.md에 회사 스펙 붙여넣기"]
    A2["🗣 'Phase A 시작' 발화"]
    A3["🤖 Procedure 6 실행\nSPEC 읽기 → 모호점 하나씩 질문"]
    A4(["👤 A / B / C 결정 — 반복 4~7회"])
    A5["🤖 docs/PLAN.md §2 기록"]
    A6["👤 스코프 확정 (Required / Optional)\ndocs/PLAN.md §3 채우기"]
    A7["🤖 docs/DESIGN.md ADR 초안 제시"]
    A8["👤 ADR 승인 / 수정"]
    A9["🤖 docs/CHECKLIST.md 항목 + §N 태그 제안"]
    A10["👤 확인 후 승인"]
    A11["⚙️ git commit — docs: fill Phase A\npre-commit: docs-only → Gates 1-3 자동 skip\npost-commit: exec-plan 알림"]

    A1 --> A2 --> A3 --> A4 --> A5 --> A6 --> A7 --> A8 --> A9 --> A10 --> A11
```

**→ 완료 기준**: PLAN §2~6, DESIGN ADR 5-10개, CHECKLIST §N 태깅 완료

---

## 상태 2 — Phase B (툴체인 고정)

**판단 기준**: PLAN은 됐는데 lint/test/build 스크립트 미설정

```mermaid
flowchart TD
    B1["👤 런타임 버전 고정\n(.nvmrc / .python-version / ...)"]
    B2["👤 lint / test / build 스크립트 추가\n(package.json 또는 스택 동등물)"]
    B3["⚙️ git config core.hooksPath .githooks\n훅 활성화 — 최초 1회"]
    B4["👤 bash scripts/cadence.sh 실행\n'deadline placeholder' 뜨면 CLAUDE.md 채우기"]
    B5["👤 docs-only commit으로 pre-commit hook smoke test"]

    B1 --> B2 --> B3 --> B4 --> B5
```

**→ 완료 기준**: lint/test/build 모두 PASS, cadence.sh 정상 출력

---

## 상태 3 — Phase C (구현 루프, ×30-60)

**판단 기준**: 툴체인 준비됨, 기능 구현 중

### 3-A. 기능 시작

```mermaid
flowchart TD
    Start["👤 기능 요청\n예: '로그인 기능 만들어줘'"]
    Judge{{"🤖 복잡도 판단"}}
    Simple["🤖 직접 구현 → src/"]
    Done(["DoD 체크로 이동"])

    subgraph complex["복잡 경로 — 3+ 파일 or 2+ 레이어"]
        direction TB
        EP["🤖 exec-plan 생성 제안\ndocs/exec-plans/active/YYYYMMDD-feature.md"]
        EU["👤 exec-plan 승인"]
        subgraph tdd["TDD 루프 — domain logic만"]
            direction TB
            T1["🤖 Step 1: 타입 정의\ncommit: chore(types): define ... §N"]
            T2["🤖 Step 2: 실패 테스트 작성 — Red\ncommit: test(...): failing test §N\n⚙️ TDD_RED=1 git commit → Gate 2 skip"]
            T3["🤖 Step 3: 구현 — Green\ncommit: feat(...): implement ... §N\n⚙️ Gate 2 정상 실행 → 통과해야 함"]
            T4["🤖 Step 4: Refactor (선택)"]
            T5["🤖 Step 5: API/UI 연결 — TDD 없이"]
            T1 --> T2 --> T3 --> T4 --> T5
        end
        EP --> EU --> tdd
    end

    Start --> Judge
    Judge -- "단순 (1-2 파일, 단일 레이어)" --> Simple
    Judge -- "복잡 (3+ 파일 or 2+ 레이어)" --> complex
    Simple --> Done
    complex --> Done
```

### 3-B. 커밋 루프

```mermaid
flowchart TD
    Trigger["🗣 '커밋해도 돼' 발화"]
    Proc1["🤖 Procedure 1 실행 (proc-1-dod.md)"]

    subgraph sr["Step 0: Pre-DoD Self-Review"]
        direction LR
        SR["0-A Correctness · 0-B Simplicity · 0-C Domain iso.\n0-D Duplication · 0-E Size · 0-F Naming · 0-G Performance\n─────────────────────────────────────────\nC·D: 자동 수정 완료 후 보고 / F: flag → 👤 결정"]
    end

    subgraph ag["Auto Gates 1-5"]
        direction LR
        AG["1. Lint · 2. Tests · 3. Build · 4. No type · 5. No debug"]
    end

    subgraph mg["Manual Gates 6-8"]
        direction LR
        MG["6. CHECKLIST sync · 6b. Doc drift\n7. AI_USAGE row · 8. Commit message §N"]
    end

    Fix["🤖 수정 제안\n👤 수정 후 재시도"]
    Submit["🤖 커밋 요청 제출\n파일목록 + 메시지 + gate 결과"]
    Approve{"👤 승인?"}
    Commit["⚙️ git commit 실행"]

    subgraph hook["pre-commit hook (안전망)"]
        direction LR
        HC["gates 1-5 재실행\nFAIL → commit 거부"]
    end

    Post["⚙️ post-commit\nexec-plan 스텝 알림 · TODO/FIXME 스캔 · D-2 권고"]

    Trigger --> Proc1 --> sr --> ag
    ag -- "❌ FAIL" --> Fix --> ag
    ag -- "✅ PASS" --> mg --> Submit --> Approve
    Approve -- "거부" --> Fix
    Approve -- "승인" --> Commit --> hook --> Post
```

### 3-C. 진행 상황 확인 (언제든지)

```mermaid
flowchart TD
    C1["🗣 '어디까지 왔어' 발화"]
    C2["🤖 Procedure 5 → ⚙️ scripts/cadence.sh 실행"]
    C3["출력: commits · §N 분포 · CHECKLIST %\nquality grades · tech-debt 수 · stale docs · D-day"]
    C4["👤 숫자 해석 후 다음 행동 결정\nAI는 추천하지 않음"]

    C1 --> C2 --> C3 --> C4
```

---

## 상태 4 — Phase D (폴리시, D-1)

**판단 기준**: 기능 구현 완료, 마감 1일 전

```mermaid
flowchart TD
    D1["🗣 '어디 부족' 발화"]
    D2["🤖 Procedure 2 (proc-2-trace.md)\n§N별 commit 수 + CHECKLIST 항목 수 → 커버리지 표"]
    D3["👤 약한 §N에 추가 작업 결정"]
    D4["🗣 '가든' 발화"]
    D5["🤖 Procedure 7 (proc-7-gardening.md)\ndocs/ stale 파일 vs src/ 최근 diff 비교"]
    D6{{"👤 처리 방향 선택"}}
    Da["(a) 즉시 수정"]
    Db["(b) 별도 docs: commit"]
    Dc["(c) defer"]
    D7["👤 README _TO FILL_ 제거\nexec-plans/active/ → completed/ 이동\ntech-debt-tracker.md 🔴 해소"]

    D1 --> D2 --> D3 --> D4 --> D5 --> D6
    D6 --> Da & Db & Dc --> D7
```

---

## 상태 5 — Phase E (제출, D-0)

**판단 기준**: 마감 당일, 최종 검토

```mermaid
flowchart TD
    E1["🗣 'final review' 발화\n새 Claude 세션 권장"]
    E2["🤖 Procedure 4 (proc-4-review.md)\nSelf-review pass: git diff → rubric 직접 대조\nSPEC origin 커버리지 체크"]
    E3["출력: 점수 시뮬레이션 / weakness / 🔴🟡 액션"]
    E4["👤 🔴 항목 30분 내 수정"]
    E5["👤 grep -rn '_TO FILL_' README.md docs/ → 0 확인"]
    E6["👤 repo public + URL 제출"]

    E1 --> E2 --> E3 --> E4 --> E5 --> E6
```

---

## 빠른 참조 — 트리거 치트시트

| 상황 | 발화 | 실행되는 것 |
|---|---|---|
| 커밋하고 싶다 | `"커밋해도 돼"` | Procedure 1 DoD (self-review + 8 gates) |
| 지금 진행 상황 | `"어디까지 왔어"` | Procedure 5 cadence.sh |
| 약한 §N 찾기 | `"어디 부족"` | Procedure 2 §N trace |
| 코드 품질 점검 | `"코드 리뷰해줘"` | Procedure 8 deep code review |
| 문서 신선도 확인 | `"가든"` | Procedure 7 stale docs |
| 최종 리뷰 | `"final review"` | Procedure 4 strict review |
| SPEC 해석 | `"Phase A 시작"` | Procedure 6 guided fill |
| SPEC 변경됨 | `"SPEC 바뀌었어"` | Procedure 3 drift check |

---

## 사용자 개입이 반드시 필요한 것 (요약)

1. 모든 **커밋 승인** — AI가 절대 자동 commit 불가
2. **SPEC 모호점 A/B/C 선택** — Phase A, Procedure 6
3. **스코프 경계 결정** — Required vs Optional
4. **Quality grades 평가** — 🟢/🟡/🔴 직접 판단
5. **doc-gardening 처리 방향** — (a)/(b)/(c) 선택
6. **TDD_RED commit 승인** — Red phase임을 사용자가 인지
