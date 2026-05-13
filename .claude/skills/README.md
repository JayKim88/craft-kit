# .claude/skills/

SKILL.md packages of the AI procedures defined in [`CLAUDE.md`](../../CLAUDE.md) "## AI agent procedures".

These exist so Claude Code's skill auto-loader (and compatible agents like Codex / Cursor / Aider) can surface them by trigger keyword without the user typing `/` slash commands. CLAUDE.md remains the canonical source of truth — each skill file is a thin pointer (~5 lines) plus a frontmatter trigger list.

| Skill | Procedure (in CLAUDE.md) | Trigger examples |
|---|---|---|
| `dod-verify.md` | Procedure 1 — DoD verification | "ready to commit", "커밋해도 돼" |
| `checklist-trace.md` | Procedure 2 — Checklist trace | "§N coverage", "어디 부족" |
| `spec-drift.md` | Procedure 3 — SPEC drift check | "SPEC updated" |
| `pre-submission-review.md` | Procedure 4 — Pre-submission review | "리뷰", "final review" |
| `cadence.md` | Procedure 5 — Cadence check | "어디까지 왔어", "cadence" |

**Do not edit skill bodies in isolation.** When a procedure changes, update `CLAUDE.md` first; the skill files only point at it.
