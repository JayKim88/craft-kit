# Walkthrough — 새 과제 받아서 제출까지

가상 시나리오: **AcmeCo Backend Engineer 채용 과제, "크리에이터 정산 API" 5일**.

이 문서는 시간 순서대로 무엇을 입력하고 무엇을 보는지를 따라가는 가이드입니다. 원칙·철학은 [workflow-guide.md](workflow-guide.md), 도메인별 변형은 [customizing.md](customizing.md), 설계 의도는 [design-rationale.md](design-rationale.md) 참고.

---

## 사전 환경

- **Node.js ≥ 18** (init.mjs 가 의존하는 표준 라이브러리만 사용)
- **git** + **gh CLI** (선택, repo 생성 자동화에 사용)
- **Claude Code** (선택이지만 권장 — 슬래시 커맨드 + subagent 사용)
- **TTY 터미널** (인터뷰 진행 — 파이프 입력은 자동으로 quiet 모드 fallback)

---

## D-5 (1시간) — 부팅 + SPEC 정렬

### Step 1. 템플릿 받기 (30초)

```bash
# degit (권장 — git 히스토리 깨끗)
npx degit JayKim88/recruit-kit acmeco-task
cd acmeco-task

# 또는 git clone + .git 제거
git clone https://github.com/JayKim88/recruit-kit acmeco-task
cd acmeco-task && rm -rf .git
```

### Step 2. 인터뷰 (5분)

```bash
node bin/init.mjs
```

실제 화면 (응답 예시):

```
=== recruit-kit interview ===

답변은 한국어/영어 자유. 빈 값이면 기본값 사용.

회사명 (COMPANY) [AcmeCo]: AcmeCo
제품/과제 이름 (PRODUCT) [Take-Home Assignment]: 크리에이터 정산 API
역할 (ROLE) [Software Engineer]: Backend Engineer 3+ years
과제 유형 (TASK_TYPE: FE|BE|FS|ML|Mobile|Other) [FE]: BE
마감일 (DEADLINE_DATE, YYYY-MM-DD) [2026-05-08]: 2026-05-13
마감 시각 (DEADLINE_TIME) [23:59]:
한 줄 핵심 도전 과제: 정산 정확성 + 동시성 + 멱등성
기술 스택 힌트 (free-form): Node.js + TypeScript + Postgres + Jest
환경 주의사항 (없으면 빈 입력): 특이사항 없음

--- 실행 명령 ---
런타임 (TECH_RUNTIME): Node.js
런타임 버전 (RUNTIME_VERSION): 22.19
설치 명령 (INSTALL_COMMAND): npm install
개발 서버 명령 (DEV_COMMAND): npm run dev
테스트 명령 (TEST_COMMAND): npm run test
빌드 명령 (BUILD_COMMAND): npm run build

--- 평가 기준 입력 ---
평가 기준 개수 [6]: 6
§1 카테고리명: 요구사항 이해 및 문제 정의
§1 배점: 20
§2 카테고리명: 설계 및 코드 구조
§2 배점: 25
§3 카테고리명: 안정성 및 예외 처리
§3 배점: 20
§4 카테고리명: 데이터 정확성
§4 배점: 15
§5 카테고리명: 문서화 및 설명 가능성
§5 배점: 10
§6 카테고리명: Git / 작업 흔적
§6 배점: 10

총 배점: 100점 (6개 카테고리)

--- 평가 기준 인덱스 매핑 ---
요구사항 이해 카테고리는 §몇? [1]:
설계·코드 구조 카테고리는 §몇? [2]:
문서화 카테고리는 §몇? [5]:
Git / 작업 흔적 카테고리는 §몇? [6]:

=== scaffold complete ===
git: initialized + first commit ("chore(init): scaffold recruit-kit for AcmeCo — 크리에이터 정산 API")
```

생성된 폴더:

```
acmeco-task/
├── CLAUDE.md, AGENTS.md, README.md, .gitignore  ← AI 협업 룰 + 제출용 README 골격
├── docs/
│   ├── SPEC.md         ← 다음 단계: 회사 명세 paste
│   ├── PLAN.md         ← 우리 해석·일정·리스크·평가 매핑 (자동 6행 표)
│   ├── DESIGN.md       ← ADR 5-10개 작성 영역
│   ├── PROCESS.md      ← Phase 0-4 골격
│   ├── CHECKLIST.md    ← Phase A/B/C 골격
│   └── AI_USAGE.md     ← 협업 로그 표
└── .claude/
    ├── commands/  ← /init-recruit, /dod-check, /spec-sync, /checklist-trace
    └── agents/    ← rubric-reviewer
```

### Step 3. SPEC paste (5분)

`docs/SPEC.md` 의 `<!-- SPEC PASTE START -->` 영역에 회사 명세 붙여넣기. **이후 절대 수정 안 함**.

자동 생성된 평가 기준 표 6행에 회사 명세의 "낮은/높은 숙련도" 기준을 옮겨 적습니다.

### Step 4. 인터뷰 결과 검증 (5분)

```bash
# 잘못 입력했다면 다시 시작
rm -rf acmeco-task && npx degit JayKim88/recruit-kit acmeco-task && cd acmeco-task && node bin/init.mjs

# placeholder 잔존 확인 (인터뷰 모드에선 0 기대)
grep -rn "{{" docs/ README.md CLAUDE.md
```

남은 placeholder가 있다면:
- `{{TECH_RUNTIME}}`, `{{INSTALL_COMMAND}}` 등 → 인터뷰 응답 빈 입력으로 둔 것. 직접 채움.
- `{{DECISION_1_TITLE}}` 등 narrative — Phase 4 마무리 시점에 채우는 영역.

---

## D-5 ~ D-4 (6시간) — 기획·설계 (Phase A)

Claude Code를 열고:

```
사용자: docs/PLAN.md 채우자. SPEC §2 (구현 범위) 모호점부터 정리해줘.

Claude: SPEC §2의 다음 3개 모호점 발견:
1. "동시 정산 요청 처리"가 명시 안 됨 → 우리 결정 필요
2. "환불 기간 경계값" 미정의
3. "음수 잔액" 처리 정책 부재

옵션 비교:
[옵션 A/B/C 표와 트레이드오프]

→ PLAN.md §2 표에 4행 추가하시겠어요?

사용자: A로 결정. 추가해줘.
Claude: [docs/PLAN.md §2 표 갱신]
```

같은 패턴으로 채울 문서:
- `PLAN.md` §2 (해석), §3 (스코프), §4 (D-5~D-0 일정), §5 (평가 매핑), §6 (리스크)
- `DESIGN.md` ADR 5-10개 (DB 스키마·트랜잭션 격리·멱등성 키 전략·동시성 락 등)
- `PROCESS.md` Phase 0-4 (DB 마이그레이션 → 도메인 모델 → API → 통합 테스트)
- `CHECKLIST.md` Phase A/B (문서·도구체인 락) → Phase C (구현 항목 50-100개, 각 `[§N]` 태그)

이 단계의 git log 예시:
```
e8a3f1b docs(plan): align scope and timeline with SPEC §3 [§5]
4c2b9d8 docs(design): ADR-001 transaction isolation (REPEATABLE READ) [§2]
1f7e6a3 docs(design): ADR-002 idempotency key strategy [§2,§3]
```

---

## D-4 ~ D-1 — 구현 사이클 (반복)

**한 feature = 한 commit**. 매 사이클:

### 1. 코드 작성

Claude Code에서:
```
사용자: src/lib/billing/calculate.ts 구현해줘.
        SPEC §4 (데이터 정확성) 핵심.
        경계값(월말, 자정 timezone) 필수.

Claude: [코드 + 테스트 작성]
        - src/lib/billing/calculate.ts (152 lines)
        - src/lib/billing/calculate.test.ts (38 tests)
```

### 2. DoD 8-gate 검증

Claude Code 슬래시 커맨드:
```
/dod-check
```

> **`.claude/commands/dod-check.md` 가 어떻게 호출되나?**
> Claude Code가 프로젝트 루트의 `.claude/commands/` 폴더를 자동 인식.
> 채팅창에 `/dod-check` 입력 시 해당 .md 의 instruction 으로 작업 실행.
> Claude Code 가 아닌 Claude.ai 사용자는 `.claude/commands/dod-check.md` 내용을 직접 paste 후 "이대로 실행해줘".

출력 예시:
```
Inferred commands:
  Lint:  npm run lint
  Test:  npm run test
  Build: npm run build

Auto gates:
  1. Lint clean         ✅ PASS
  2. Tests green        ✅ PASS (38/38)
  3. Build OK           ✅ PASS
  4. No type-escape     ✅ PASS (0 `: any`)
  5. No debug logs      ✅ PASS

Manual gates:
  6. CHECKLIST sync     ⚠ 1 pending matches diff:
                          - "정산 계산 boundary cases" 가 [ ]
  7. AI_USAGE sync      ⚠ AI_USAGE.md not updated
  8. Commit convention  ⚠ no proposed message yet
```

### 3. 동기화 작업 (수동 게이트 보강)

```
사용자: docs/CHECKLIST.md 의 "정산 계산 boundary cases" 줄을 [x] 로,
        docs/AI_USAGE.md 에 1행 추가:
        | AI 작성 / 인간이 negative balance 케이스 추가 + isolation 검증 |
        커밋 메시지 제안해줘.

Claude: [업데이트]
        feat(billing): implement settlement calculation with boundary cases [§4]

        - 38 tests cover month-end, partial refund, negative balance
        - All DoD gates PASS
```

### 4. 사용자 승인 → commit

```
사용자: 커밋해
Claude: git add ... && git commit -m "feat(billing): ..."
```

이 사이클을 5일간 30-60회 반복.

---

## D-1 — Polish

### 1. §N 분포 점검

```
/checklist-trace
```

출력:
```
| §N | Category | Points | Commits | Status |
|----|----------|--------|---------|--------|
| §1 | 요구사항  | 20     | 6       | ✅ healthy |
| §2 | 설계·구조 | 25     | 18      | ✅ healthy |
| §3 | 안정성    | 20     | 9       | ✅ healthy |
| §4 | 데이터    | 15     | 12      | ✅ healthy |
| §5 | 문서화    | 10     | 3       | ⚠ low coverage |
| §6 | Git       | 10     | (auto)  | (자동 평가) |

Coverage gap: §5 commits 부족. README 보강 권장.
```

→ 약점 보완 커밋:
```
docs(readme): clarify isolation/idempotency rationale [§5]
docs(ai-usage): add 5 representative AI/human decision examples [§5]
```

### 2. SPEC drift 점검 (선택)

회사가 마감 직전 명세 수정한 경우 (드물지만):
```
/spec-sync
```

→ SPEC.md 변경분이 PLAN/DESIGN/CHECKLIST 에 반영됐는지 검사.

---

## D-0 — 자가 평가 + 제출

### 1. rubric-reviewer 시뮬레이션

Claude Code 에서:
```
사용자: rubric-reviewer 서브에이전트로 평가 시뮬레이션 돌려줘
```

> **`.claude/agents/rubric-reviewer.md` 가 어떻게 호출되나?**
> Claude Code가 `.claude/agents/` 폴더의 subagent 자동 인식.
> "rubric-reviewer 로 X 해줘" 자연어 호출 시 해당 .md frontmatter `description` 매칭.
> Claude Code 외 환경: 해당 .md 내용을 system prompt 처럼 paste 후 분석 요청.

출력 (4 섹션):
1. **점수 시뮬레이션 표** — §N별 시뮬 점수 + 근거
2. **약점 분석** — 만점까지 가는 데 필요한 것
3. **Critical (제출 전 반드시)** — 30분 내 보강 항목
4. **시간 박스** — 1h / 2h 추가 점수 추정

### 2. README 최종 합성

```
사용자: README.md 의 "설계 결정과 이유" 를 DESIGN ADR-001~005 발췌로 채워줘.
        평가 §5 5개 세부 항목 모두 커버되도록.
```

`_작성 영역_` 마커가 남아있는 곳을 모두 채움. 마지막 grep:
```bash
grep -rn "_작성 영역_\|<!-- TODO" README.md docs/
# → 0 hit 이어야 제출 가능
```

### 3. Repo 공개 + 제출

```bash
# D-1: private 으로 먼저
gh repo create acmeco-task --private --source=. --push

# D-0 마감 직전: public 전환
gh repo edit --visibility public

# 또는 한 번에 (권장 X — 마감 직전 push 실수 회수 불가)
# gh repo create acmeco-task --public --source=. --push
```

---

## 평가자가 받는 것

| 위치 | 내용 | 평가 매핑 |
|---|---|---|
| `README.md` | 8 섹션 평가용 (SPEC 템플릿 100% 충족) | §1 §5 |
| `docs/SPEC.md` | 회사 원본 명세 (불변) | 추적 자료 |
| `docs/PLAN.md` | 해석·스코프·일정·리스크·평가 매핑 | §1 §5 |
| `docs/DESIGN.md` | ADR 5-10개 (옵션→결정→근거→트레이드오프) | §2 §3 §5 |
| `docs/PROCESS.md` | Phase 0-4 의존 그래프 | §5 |
| `docs/CHECKLIST.md` | 모든 항목 `[x]` + `[§N]` 태그 | §1 §3 |
| `docs/AI_USAGE.md` | 협업 로그 (인간 결정·검증 명시) | (감점 회피) |
| `git log` | 30-60 commits, 의미 단위 + `[§N]` 태그 | §6 |
| `src/`, `test/` | 코드 + 3-tier 테스트 | §1-§4 |

---

## 도구 호출 빠른 참조

| 도구 | 위치 | Claude Code 호출 | 일반 환경 호출 |
|---|---|---|---|
| `init.mjs` | `bin/init.mjs` | (없음) | `node bin/init.mjs [target] [options]` |
| `/init-recruit` | `.claude/commands/init-recruit.md` | `/init-recruit` | .md 내용 paste 후 "이대로 진행" |
| `/dod-check` | `.claude/commands/dod-check.md` | `/dod-check` | .md 내용 + "검증해줘" |
| `/spec-sync` | `.claude/commands/spec-sync.md` | `/spec-sync` | .md 내용 + "검사해줘" |
| `/checklist-trace` | `.claude/commands/checklist-trace.md` | `/checklist-trace` | .md 내용 + "분석해줘" |
| `rubric-reviewer` | `.claude/agents/rubric-reviewer.md` | "rubric-reviewer 로 평가해줘" | .md 내용 + "이 역할로 분석" |

---

## Recovery — 실수했을 때

### 인터뷰 잘못 입력
```bash
# 가장 단순: 폴더 삭제 후 처음부터
cd ..
rm -rf acmeco-task
npx degit JayKim88/recruit-kit acmeco-task
cd acmeco-task && node bin/init.mjs
```

### 일부 placeholder 일괄 치환
```bash
# {{COMPANY}} 를 모든 .md 에서 일괄 변경
find . -name "*.md" -not -path "./node_modules/*" -exec sed -i '' 's/{{COMPANY}}/AcmeCo/g' {} +
# Linux: sed -i 's/...' (인용부호 위치 다름)
```

### TTY 자동 quiet 가 의도와 다름
파이프 입력이 아닌데 "stdin is not a TTY" 메시지가 뜨면:
```bash
# CI 환경 변수 등으로 인한 오탐 — 강제 interactive
node bin/init.mjs < /dev/tty
```

### git 첫 커밋 author 가 잘못됨
```bash
git config user.name "Your Name"
git config user.email "you@example.com"
# 이미 commit 했다면:
git commit --amend --reset-author --no-edit
```

### `/dod-check` 가 lint/test/build 명령을 못 찾음
프로젝트 초기에 `package.json` scripts 섹션이 없을 때:
```json
{
  "scripts": {
    "lint": "eslint src/",
    "test": "vitest run",
    "build": "tsc --noEmit"
  }
}
```
이걸 Phase B 에서 락. `/dod-check` 가 자동 추론.

### 슬래시 커맨드가 인식 안 됨
- 작업 디렉토리가 과제 폴더 루트인지 확인 (`.claude/` 가 거기 있어야)
- Claude Code 재시작 (드물게 캐시 문제)
- 그래도 안 되면 .md 파일 내용을 채팅에 직접 paste

---

## fork 사용자 (JayKim88 외)

본인 GitHub 계정으로 가져갈 때:

1. **GitHub fork 또는 새 repo 생성**
   ```bash
   gh repo fork JayKim88/recruit-kit --clone
   # 또는
   git clone https://github.com/JayKim88/recruit-kit my-recruit-kit
   cd my-recruit-kit && git remote set-url origin https://github.com/USER/my-recruit-kit
   ```

2. **저작자 정보 변경**
   - `LICENSE`: `Copyright (c) 2026 Jay Kim` → 본인 이름
   - `package.json`: `"author": "Jay Kim"` → 본인 이름
   - `bin/init.mjs --help` 출력의 `JayKim88/recruit-kit` 예시 → 본인 repo

3. **README의 degit URL 변경**
   ```bash
   # README.md 안의 JayKim88/recruit-kit → USER/my-recruit-kit 일괄 치환
   sed -i '' 's|JayKim88/recruit-kit|USER/my-recruit-kit|g' README.md docs/walkthrough.md
   ```

4. **본인 GitHub push**
   ```bash
   gh repo create my-recruit-kit --public --source=. --push
   ```

이후 본인 사용 시 `npx degit USER/my-recruit-kit my-task` 로 부팅.

---

## 다음 읽을 문서

- 원칙·철학: [workflow-guide.md](workflow-guide.md), [design-rationale.md](design-rationale.md)
- TASK_TYPE 별 변형: [customizing.md](customizing.md)
- 검증 결과: [../examples/fs-planner-reverse/README.md](../examples/fs-planner-reverse/README.md)
- 본 repo 자체 개발: [../CLAUDE.md](../CLAUDE.md)
