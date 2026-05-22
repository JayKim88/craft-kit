# Procedure 6 — Phase A Guided Fill

**Trigger**: "fill PLAN" / "start Phase A" / "Phase A 시작" / "PLAN 채우자" / "docs/PLAN.md 같이 채우자" / "doc alignment" / first attempt to populate `docs/PLAN.md` §2.

---

## Prerequisites

- `docs/SPEC.md` `<!-- SPEC PASTE START -->` region must contain real content. If still `[[ paste original project spec here ]]`, **halt** — tell user to paste SPEC first.
- `docs/PLAN.md` exists.

---

## Steps

### 1. Read SPEC completely

Pay attention to:
- "Required implementation" / "Optional / Bonus" lists
- "Background scenario" / "Usage flow"
- "Error codes" / "Error handling"
- "Library choice is free" / free-choice phrasing
- Type definitions / schema fragments
- Sample code (and whether samples agree with spec text)

### 2. Identify SPEC ambiguities

Look for:
- **Boundary cases unaddressed**: empty inputs, maximum bounds, time boundaries, concurrent requests
- **Soft-modal language**: "should", "recommended", "preferably", "may", "could"
- **Sample-vs-spec mismatches**: type definition diverges from example payload
- **Missing error semantics**: error codes without response shapes
- **Free-choice areas**: library, persistence, auth scope
- **Implicit assumptions**: per-user vs per-team, in-memory vs DB

### 3. Surface ONE ambiguity at a time

```
SPEC §<section> says: "<verbatim quote>"

Three reasonable interpretations:

| Option | Decision | Trade-off |
|--------|----------|-----------|
| A.     | ...      | ...       |
| B.     | ...      | ...       |
| C. Ask | ...      | delay     |

Which fits your judgment? (Or propose D.)
```

- **Do NOT pre-pick.** User must own the judgment.
- **Do NOT propose out-of-scope options.**

### 4. After user picks → append to PLAN.md §2

| SPEC ambiguity | Our decision | Rationale | Confidence | Verified by |
|----------------|--------------|-----------|------------|-------------|
| "<verbatim>"   | chosen       | reason    | High/Med/Low | Inferred / Asked / Cross-checked |

### 5. Move to next ambiguity

Typical: 4-7 ambiguities. Stop when all surfaced or user says "enough" / "충분".

### 6. Do NOT write code

Phase A is doc-only. Procedure 1 + pre-commit hook block premature implementation.

---

## Anti-patterns

- Don't pitch one option as obviously correct.
- Don't propose scope-creep options.
- Don't decide for the user.
- Don't bundle ambiguities — one per round.
- Don't write code.
