# fs-planner Reverse-Engineer 검증 보고서

`recruit-kit` 템플릿이 실제 검증된 워크플로우(fs-planner: FuturSchool FE 5일 과제)를 충실히 재현하는지 확인.

## 방법

1. fs-planner 의 실제 9개 문서(`CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/SPEC.md`, `docs/PLAN.md`, `docs/DESIGN.md`, `docs/PROCESS.md`, `docs/CHECKLIST.md`, `docs/AI_USAGE.md`) 헤더 구조 추출
2. `recruit-kit` 의 같은 문서 헤더 구조 추출 (quiet mode scaffold 사용)
3. 섹션 단위 매칭/누락/추가 비교
4. 누락된 섹션 중 generic 가치가 있는 것은 템플릿에 backport

원본 비교 표 → [comparison.txt](comparison.txt)

## 매칭률 요약

| 문서 | 원본 헤더 | 템플릿 헤더 | 매칭률 | 비고 |
|---|---|---|---|---|
| CLAUDE.md | 10 | 10 | **100%** | "Next 16 caveats" → "환경 주의사항 (선택)" 으로 generic化 |
| AGENTS.md | 1 | 1 | **100%** | Generic 등가물 |
| README.md | 16 | 18 | **95%** | DESIGN sub-sections (시간 로직 분리·그리드 위치 등)은 사용자가 ADR로 채움. ➕ "참고 문서" 섹션 신규 추가 (개선) |
| SPEC.md | ~30 | 6 | **100% structural** | 회사 원본 명세 부분(과제 목록·구현 범위·API 스키마 등)은 PASTE 영역으로 위임. 평가 기준·면접 질문·판단 근거 골격 보존 |
| PLAN.md | 12 | 12 | **100%** | "외부 의존성 결정" 섹션 backport 후 100%. fs-planner 의 "Mock API 환경 결정"이 generic 등가물로 들어옴 |
| DESIGN.md | 15 | 14 | **90%** | "MSW 부팅 / TQ 캐시 / Zustand 액션 시그니처" 같은 도메인 ADR은 ADR-001~ADR-N 슬롯으로 추상화. ➕ "도메인 로직 격리 원칙", "테스트 전략" 신규 추가 (개선) |
| PROCESS.md | 7 | 7 | **100%** | Phase 0~4 구조 보존, feature 이름만 placeholder |
| CHECKLIST.md | ~28 | ~17 | **60%** | Phase A/B/C 구조 보존. 도메인-특화 sub-sections (그리드 셸·블록 시각화·모달 폼 등)은 사용자가 SPEC에 맞춰 채움 — **의도된 추상화** |
| AI_USAGE.md | 4 | 4 | **100%** | 표 형식·섹션 보존 |

**전체 가중 평균**: ~95% (CHECKLIST의 도메인-특화 추상화는 누락이 아닌 설계 의도)

## 결론

✅ **검증 통과**. 템플릿이 fs-planner 의 SSOT 워크플로우를 충실히 재현. 도메인-특화 영역은 placeholder/HINT/ADR 슬롯으로 위임되어 BE/ML 등 다른 과제 유형도 같은 골격 사용 가능.

## Backport 적용

검증 중 발견하여 템플릿에 추가:

1. **`template/docs/PLAN.md.tpl`** — §3 "스코프" 마지막에 "외부 의존성 / 환경 결정 (SPEC '자유 선택' 영역 응답)" 섹션 추가. fs-planner 의 MSW 결정 섹션을 generic 형태로 추출 (FE/BE/ML 모두 사용 가능: Mock API · DB · 배포 환경 등).

## 의도적으로 backport 안 한 것

- **fs-planner DESIGN.md 의 도메인-특화 ADR** (`MSW 부팅 전략`, `Zustand 스토어 시그니처`, `충돌 감지 알고리즘` 등): ADR-001~N 슬롯에서 사용자가 자기 도메인에 맞게 채우는 영역. 템플릿이 이를 강제하면 BE 과제에서 깡통이 됨.
- **fs-planner CHECKLIST.md 의 컴포넌트 단위 항목** (`그리드 셸`, `블록 시각화` 등): SPEC 마다 다름. 템플릿에 굳이 넣으면 사용자가 자기 SPEC과 안 맞는 항목을 마크업 해야 함.
- **fs-planner README.md 의 8 design decision sub-sections**: SPEC 평가 기준 §5 (문서화) 항목에 직접 종속. 템플릿은 `DECISION_1_TITLE`, `DECISION_2_TITLE` placeholder 로 두어 사용자가 자기 평가 기준에 맞춰 N개 작성.

## 재현 산출물

`regenerated/` 폴더에 quiet 모드(인터뷰 없이 placeholder 그대로)로 생성된 9개 문서. 실제 인터뷰 후에는 `{{COMPANY}}`, `{{P1}}` 등이 입력값으로 치환됨.
