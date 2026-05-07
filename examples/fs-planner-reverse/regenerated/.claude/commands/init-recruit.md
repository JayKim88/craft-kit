---
description: 기업 채용 과제 워크스페이스를 인터뷰 기반으로 부트스트랩 (recruit-kit cookiecutter)
---

# /init-recruit

이 슬래시 커맨드는 사용자와의 대화로 채용 과제 메타데이터를 모은 뒤, `recruit-kit` 템플릿을 현재 작업 디렉토리(또는 사용자가 지정한 폴더)에 scaffold 합니다.

## 동작

1. **현재 위치 확인**: 작업 디렉토리가 비어있는지 + git repo 인지 확인. 비어있지 않으면 사용자 확인.
2. **인터뷰 진행** (한국어/영어 자유):
   - 회사명 (COMPANY)
   - 제품/과제 이름 (PRODUCT)
   - 역할 (ROLE) — 예: "Frontend Engineer 3+ years"
   - 과제 유형 (TASK_TYPE) — `FE | BE | FS | ML | Mobile | Other`
   - 마감일 (DEADLINE_DATE) — `YYYY-MM-DD`, 마감 시각 (DEADLINE_TIME, 기본 `23:59`)
   - 한 줄 핵심 도전 과제 (ONELINE_CHALLENGE)
   - 기술 스택 힌트 (STACK_HINT) — free-form
   - 환경 주의사항 (ENV_NOTES) — Next 16 / Python 3.13 등 / 없으면 빈 입력
   - **평가 기준** N개 — 각각 `name`, `points`. 보통 5-7개. 평가 기준 없으면 회사 명세에서 면접 질문/평가 안내 등으로 추론.

3. **scaffold 실행**:
   - `node ${RECRUIT_KIT_ROOT}/bin/init.mjs --target ${PWD}` 를 사용자 응답으로 호출 (또는 직접 Write로 파일 생성)
   - `${RECRUIT_KIT_ROOT}` 는 `~/Documents/Projects/recruit-kit/` 기본 가정. 다르면 사용자에게 확인.

4. **다음 단계 안내**:
   - SPEC.md 의 `<!-- SPEC PASTE START -->` 영역에 회사 원본 명세 paste 요청
   - PLAN.md §2 "우리의 기획적 해석" 채우기
   - DESIGN.md ADR 5-10개 작성
   - `/dod-check` 로 8-gate 검증

## 사용법

```
/init-recruit
```

또는 변수를 미리 알려주는 형태:

```
/init-recruit company=AcmeCo product="Widget Builder" role="FE Engineer 3+yrs" deadline=2026-05-15
```

## 주의

- 생성된 파일에 `{{VAR}}` placeholder 가 남아있으면 인터뷰에서 답하지 않은 항목. 수동 채우기 가능.
- 평가 기준 입력은 회사 명세에서 점수 배분 표를 그대로 옮기는 것이 가장 정확. 추론은 마지막 수단.
- 첫 커밋은 `chore(init): scaffold recruit-kit for {{COMPANY}} {{PRODUCT}}` 메시지로 자동 생성됨.
