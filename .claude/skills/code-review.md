---
name: code-review
description: Deep code quality review — correctness vs SPEC, architecture, simplicity, duplication, naming, error handling, types, security. No auto-fix; user owns all decisions.
triggers:
  - "코드 리뷰해줘"
  - "code review"
  - "리뷰해줘"
  - "review this code"
---

# Deep Code Review

Run [CLAUDE.md "Procedure 8 — Deep Code Review"](../../CLAUDE.md).

**Scope**: `git diff HEAD` by default. If user names specific files, review only those.

**Stance**: diagnose, don't fix. Flag with severity:
- `🚨 Critical` — correctness miss vs SPEC, security vulnerability → block commit
- `⚠ Important` — architecture, domain isolation, error handling → fix before next sprint
- `ℹ Minor` — naming, minor complexity → user decision

**10 review dimensions** (per procedure): Correctness · Architecture · Simplicity · Domain isolation · Duplication · Size/Complexity · Naming · Error handling · Type safety · Performance · Security.

**Never auto-rename** — flag location + suggestion, require explicit approval per item.
