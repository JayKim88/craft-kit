# takehome-kit / Development Context

> This repo is a **meta-template** consumed by other take-home assignment projects.
> This document is the ground rules for **developing takehome-kit itself**.
> (Not to be confused with [`template/CLAUDE.md.tpl`](template/CLAUDE.md.tpl) in the generated assignment folder — that one ships to users.)

---

## Document routing (this repo)

| What you're looking for | Where it lives |
|---|---|
| User-facing README | [README.md](README.md) |
| Why we designed it this way | [docs/design-rationale.md](docs/design-rationale.md) |
| Workflow operating guide (for users) | [docs/workflow-guide.md](docs/workflow-guide.md) |
| Per-domain customization (FE/BE/ML/Mobile) | [docs/customizing.md](docs/customizing.md) |
| Validation results (fs-planner reverse-engineer) | [examples/fs-planner-reverse/README.md](examples/fs-planner-reverse/README.md) |
| Development rules for this repo | **This document** |

---

## Core structure

```
takehome-kit/
├── bin/init.mjs       # Zero-dependency cookiecutter CLI
├── template/          # .tpl files scaffolded into the user project
├── .claude/           # Slash commands + subagents copied into the user project
├── docs/              # This repo's own docs
├── examples/          # Validation artifacts
└── tests/smoke.sh     # Smoke test
```

---

## Development rules

### Coding

- `bin/init.mjs` **must stay zero-dependency**. Node 18+ stdlib only (`fs/promises`, `readline/promises`, `child_process`, `path`).
- When adding a new placeholder, **synchronize all three locations**:
  1. Add `{{VAR}}` in the relevant `template/*.tpl`
  2. Add the variable-collection code in `runInterview()` in `bin/init.mjs`
  3. Document the new variable in `docs/customizing.md` or `README.md`
- If a placeholder cannot be filled by the interview, add `<!-- HINT [Phase X]: ... -->` next to it in the template to guide the user.

### Tests

`bash tests/smoke.sh` must PASS after every change.

Additional checks:
- After `node bin/init.mjs --quiet --target /tmp/<name>`, run `grep -r "<!--" <name>/` to ensure no HTML comments leaked into non-markdown files (e.g. `.gitignore`).
- When adding a new placeholder, verify it does not survive in quiet-mode output.

### Commits

This repo also uses **conventional commits + scope**:

- `feat(template): ...` — `template/` additions/changes
- `feat(cli): ...` — `bin/init.mjs` changes
- `feat(tooling): ...` — `.claude/commands/` or `.claude/agents/` changes
- `fix: ...` — bug fixes
- `docs(<area>): ...` — `docs/` or README changes in this repo
- `test: ...` — `tests/` changes
- `chore: ...` — version bumps, etc.

This repo does **not** enforce the commit-by-commit user-approval pattern — light dog-fooding only. But:
- No oversized PRs/commits (the bootstrap commit at v0.1.0, 41 files +4264, was a one-time exception).
- Every commit must be PR-ready (smoke PASS).

### Version

Use SemVer in `package.json`'s `version` field:
- patch (`0.1.0 → 0.1.1`): bug fixes, doc improvements
- minor (`0.1.x → 0.2.0`): new interview variables, new slash commands, backward-compatible `.tpl` changes
- major (`0.x → 1.0`): changes that require degit users to manually migrate

### Never do this

- Add a dependency to `bin/init.mjs` (forces `npm install`). Breaking 0-dep breaks the one-line `npx degit + node` boot.
- Add HTML comments (`<!-- -->`) to `template/.gitignore.tpl`. `.gitignore` syntax does not recognize them.
- Omit the `description` frontmatter field in `.claude/commands/<name>.md`. Slash commands won't be detected.
- Commit `examples/fs-planner-reverse/regenerated/`. It is `.gitignore`-d.

---

## Adding a new feature

1. Add a one-paragraph "why this feature?" to `docs/design-rationale.md`
2. Implement in `template/` `.tpl` or `.claude/`
3. Add variable / logic to `bin/init.mjs` (if needed)
4. Extend `tests/smoke.sh` coverage
5. Update `docs/customizing.md` or README usage notes
6. Bump `package.json` version
7. Re-validate match rate in `examples/fs-planner-reverse/README.md` (when structure changes)
8. Commit
