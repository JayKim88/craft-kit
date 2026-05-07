# recruit-kit / 개발 컨텍스트

> 본 repo는 다른 채용 과제 프로젝트가 사용하는 **메타 템플릿**.
> 이 문서는 **recruit-kit 자체를 개발할 때** 의 그라운드 룰.
> (생성된 과제 폴더의 [`template/CLAUDE.md.tpl`](template/CLAUDE.md.tpl) 와 다름 — 그건 사용자에게 배포되는 것)

---

## 문서 라우팅 (이 repo 자체)

| 무엇을 찾는가 | 어디에 있는가 |
|---|---|
| 사용자에게 노출되는 README | [README.md](README.md) |
| 왜 이렇게 설계했는가 | [docs/design-rationale.md](docs/design-rationale.md) |
| 워크플로우 운영 가이드 (사용자용) | [docs/workflow-guide.md](docs/workflow-guide.md) |
| 도메인별 변형 가이드 (FE/BE/ML/Mobile) | [docs/customizing.md](docs/customizing.md) |
| 검증 결과 (fs-planner reverse-engineer) | [examples/fs-planner-reverse/README.md](examples/fs-planner-reverse/README.md) |
| 본 repo 자체 개발 규칙 | **이 문서** |

---

## 핵심 구조

```
recruit-kit/
├── bin/init.mjs       # 의존성 0 cookiecutter CLI
├── template/          # 사용자에게 scaffold 되는 .tpl 파일
├── .claude/           # 사용자 과제 폴더에 복사되는 슬래시 커맨드 + 서브에이전트
├── docs/              # 본 repo 의 자체 문서
├── examples/          # 검증 산출물
└── tests/smoke.sh     # 스모크 테스트
```

---

## 개발 규칙

### 코딩

- `bin/init.mjs` 는 **의존성 0 유지**. Node 18+ 표준 라이브러리만 사용 (`fs/promises`, `readline/promises`, `child_process`, `path`).
- 새 placeholder 추가 시 **세 곳 모두 동기화**:
  1. `template/` 의 `.tpl` 파일에 `{{VAR}}` 추가
  2. `bin/init.mjs` 의 `runInterview()` 에 변수 수집 코드 추가
  3. `docs/customizing.md` 또는 `README.md` 에 새 변수 안내 추가
- 새 placeholder 가 init 인터뷰에서 안 채워지는 경우, `template/` 의 해당 위치에 `<!-- HINT [Phase X]: ... -->` 추가하여 사용자 안내.

### 테스트

매 변경 후 `bash tests/smoke.sh` PASS 필수.

추가 검증:
- `node bin/init.mjs --quiet --target /tmp/<name>` 실행 후 `grep -r "<!--" <name>/` 으로 HTML 주석 누출 확인 (`.gitignore` 등 비-마크다운 파일에 누출되면 안 됨)
- 새 placeholder 추가 시 quiet 모드 출력에서 그 placeholder 가 잔존하는지 확인

### 커밋

본 repo도 **conventional commits + scope** 사용:

- `feat(template): ...` — `template/` 추가/변경
- `feat(cli): ...` — `bin/init.mjs` 변경
- `feat(tooling): ...` — `.claude/commands/` 또는 `.claude/agents/` 변경
- `fix: ...` — 버그 픽스
- `docs(<area>): ...` — 본 repo `docs/` 또는 README 변경
- `test: ...` — `tests/` 변경
- `chore: ...` — version bump 등

본 repo는 **사용자 승인 commit-by-commit 패턴 강제 안 함** — 자기 dog-fooding 의 가벼운 적용. 단:
- 한 PR/한 커밋이 너무 큰 변경 금지 (이전 v0.1.0 첫 커밋 41 files +4264 은 예외, 부트스트랩 한정).
- 각 커밋은 PR-ready 상태 (smoke PASS).

### 버전

`package.json` `version` 필드를 SemVer 로:
- patch (`0.1.0 → 0.1.1`): 버그 픽스, 문서 보강
- minor (`0.1.x → 0.2.0`): 새 인터뷰 변수, 새 슬래시 커맨드, 호환되는 .tpl 변경
- major (`0.x → 1.0`): degit 사용자가 수동 마이그레이션 필요한 변경

### 절대 하면 안 되는 것

- `bin/init.mjs` 에 의존성 추가 (npm 패키지 설치 강제). 0-dep 깨면 `npx degit + node` 한 줄 부팅 깨짐.
- `template/.gitignore.tpl` 에 HTML 주석 (`<!-- -->`) 추가. `.gitignore` syntax 가 인식 안 함.
- `.claude/commands/<name>.md` 의 frontmatter `description` 필드 누락. 슬래시 커맨드 인식 안 됨.
- `examples/fs-planner-reverse/regenerated/` 를 git 에 커밋. `.gitignore` 처리됨.

---

## 새 기능 추가 흐름

1. `docs/design-rationale.md` 에 "왜 이 기능?" 1단락 추가
2. `template/` `.tpl` 또는 `.claude/` 에 구현
3. `bin/init.mjs` 변수/로직 추가 (필요 시)
4. `tests/smoke.sh` 검증 추가
5. `docs/customizing.md` 또는 README 사용 안내 갱신
6. `package.json` version bump
7. `examples/fs-planner-reverse/README.md` 매칭률 재검증 (구조 변경 시)
8. commit
