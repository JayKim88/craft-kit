# recruit-kit

기업 채용 과제마다 **5분 안에** 검증된 Claude 협업 워크플로우(7-document SSOT + 8-gate DoD + rubric tagging)를 부팅하는 cookiecutter 스타일 템플릿.

> 한 번 잘 검증된 워크플로우(`fs-planner`, FuturSchool FE 5일 과제)에서 추출. 기술-중립이라 FE/BE/FS/ML/Mobile 어떤 도메인에도 적용 가능.

---

## 무엇이 들어 있나

```
새 과제 폴더/
├── CLAUDE.md            # AI 협업 그라운드 룰 (DoD, 커밋 컨벤션, 금지사항)
├── AGENTS.md            # 환경/세팅 메모
├── README.md            # 평가 제출용 README 골격
└── docs/
    ├── SPEC.md          # 회사 명세 (외부 계약 — 절대 수정 금지)
    ├── PLAN.md          # 우리 해석·스코프·타임라인·리스크
    ├── DESIGN.md        # 아키텍처 결정·트레이드오프 (Decision Records)
    ├── PROCESS.md       # 구현 순서 + 의존성 그래프
    ├── CHECKLIST.md     # 평가기준 §N별 체크박스
    └── AI_USAGE.md      # AI 협업 로그 (감사 추적)
```

추가로 `.claude/` 안에 슬래시 커맨드 4종 + subagent 1종이 함께 설치됨:

| 도구 | 용도 |
|---|---|
| `/init-recruit` | 인터뷰 기반 7-doc scaffold |
| `/dod-check` | 8-gate Definition of Done 자동 검증 |
| `/spec-sync` | SPEC 변경 vs PLAN/DESIGN drift 감지 |
| `/checklist-trace` | 커밋 ↔ §N 매핑 누락 감지 |
| `rubric-reviewer` (subagent) | 평가자 시뮬레이션 |

---

## 사용법

### 1. 새 과제 폴더 받기

```bash
# degit 사용 (권장 — git 히스토리 없이 깨끗하게)
npx degit JayKim88/recruit-kit my-task
cd my-task

# 혹은 git clone
git clone https://github.com/JayKim88/recruit-kit my-task && rm -rf my-task/.git
```

### 2. 인터뷰 실행

```bash
node bin/init.mjs
```

물어볼 항목:
- 회사명 (`COMPANY`)
- 제품/과제 이름 (`PRODUCT`)
- 역할 (`ROLE`, 예: "Frontend Engineer 3+ years")
- 마감일 (`DEADLINE_DATE`, ISO 8601)
- 후보 기술 스택 (`STACK_HINT`, free-form)
- 평가 기준 N개 + 배점 (예: "요구사항 이해 20, 코드 품질 25, ...")
- 한 줄 핵심 도전 과제

→ 7개 문서 placeholder 치환 + `.claude/` 복사 + `git init` + 첫 커밋 자동.

### 3. SPEC 채우기

`docs/SPEC.md`의 `<!-- SPEC PASTE START -->` 영역에 회사 원본 명세 붙여넣기. **이후 절대 수정 금지** (외부 계약).

### 4. PLAN/DESIGN 채우기, 작업 시작

`CLAUDE.md`에 정의된 8-gate DoD가 모든 커밋의 게이트. `/dod-check`로 자가 점검 가능.

---

## 왜 이 워크플로우?

`docs/design-rationale.md` 참고. 요약:

- **7문서 분리**: 한 사실은 한 문서에만. SPEC ≠ PLAN ≠ DESIGN ≠ 진행상황 — 평가자도 리뷰가 빨라짐.
- **8-gate DoD**: 자동 검증 가능한 5게이트(lint/test/build/no-any/no-console) + 수동 3게이트(체크리스트/AI_USAGE/커밋포맷)로 "다 됐다고 착각하기" 방지.
- **`[§N]` rubric tagging**: 모든 작업이 평가 기준 어느 항목에 기여하는지 명시. 누락 시 평가자가 "이 점은 어디서 평가하지?"가 안 됨.
- **Commit-by-commit user approval**: 한 기능 = 한 커밋, 매번 사용자 승인 — git history가 곧 평가 자료(fs-planner는 git history 자체가 10점 항목).

---

## 검증

`fs-planner` (FuturSchool FE 과제) 의 7개 문서를 reverse-engineer로 재생성 → 섹션 구조 매칭률 ≥ 95%. 결과는 `examples/fs-planner-reverse/` 참고.

---

## 라이선스

MIT.
