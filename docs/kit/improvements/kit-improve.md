# Kit Improvement Review

**Trigger**: "kit improve" · "개선 반영" · "improvement review"

## Purpose

Close the self-improvement loop. The Stop hook generates improvement proposals in
`docs/kit/improvements/pending/`. This procedure reviews them, applies accepted
changes to CLAUDE.md (and related kit files), and archives each proposal.

---

## Steps

### Step 1 — List pending proposals

```bash
ls -la docs/kit/improvements/pending/*.md 2>/dev/null | grep -v TEMPLATE || echo "No pending proposals"
```

If empty → stop here.

### Step 2 — Read each proposal

For each `.md` file in `pending/`, read it and extract:
- Which `src/` files were edited that session
- Which checklist items were flagged
- Any specific improvement text in "Proposed kit improvements"

### Step 3 — Present and decide (per proposal)

Show the user a summary. User picks one of:

| Choice | Action |
|---|---|
| **(A) Accept** | Incorporate into the right home: `CODING-STYLE.md` / `templates/eslint.config.mjs` (coding rules), CLAUDE.md (non-negotiables / procedures), or prohibitions |
| **(B) Reject** | Move to `rejected/` with a one-line reason appended to the file |
| **(C) Defer** | Leave in `pending/` — revisit next session |

**Never auto-apply.** User approval is required for every accepted change.

### Step 4 — Apply accepted improvements

Edit the target file (usually `CLAUDE.md`, sometimes `docs/kit/HARNESS.md` or `docs/DESIGN.md`).
Keep changes minimal and precise — one new rule, one amended rule, or one new prohibition.

### Step 5 — Log in kit-HISTORY.md

Append an entry to `docs/kit/HISTORY.md`:

```markdown
### <date> — <short description>
- **Source**: `docs/kit/improvements/pending/<filename>`
- **Change**: <what was added or amended, one sentence>
- **Target**: `CLAUDE.md §"<section>"`
```

### Step 6 — Archive the proposal

```bash
# Accepted
mv docs/kit/improvements/pending/<file> docs/kit/improvements/accepted/

# Rejected
mv docs/kit/improvements/pending/<file> docs/kit/improvements/rejected/
```

### Step 7 — Propose commit

```
chore(kit): apply session improvement proposal [§-]
```

User must approve before commit. One proposal per commit — no batching of
unrelated improvements.

---

## Invariants

- Never auto-apply improvements without explicit user approval at Step 3
- Never touch `docs/SPEC.md` through this procedure
- If the proposed change would weaken a prohibition, reject it
- Log every accepted AND rejected proposal in kit-HISTORY.md (rejected with reason)
