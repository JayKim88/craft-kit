---
description: Bootstrap a corporate take-home assignment workspace from an interview (takehome-kit cookiecutter)
---

# /init-takehome

This slash command runs an interview with the user to collect assignment metadata, then scaffolds the `takehome-kit` template into the current working directory (or a target the user specifies).

## Behavior

1. **Confirm location**: check whether the working directory is empty + a git repo. Confirm with the user if not empty.
2. **Run the interview**:
   - Company name (COMPANY)
   - Product / assignment name (PRODUCT)
   - Role (ROLE) — e.g. "Frontend Engineer 3+ years"
   - Assignment type (TASK_TYPE) — `FE | BE | FS | ML | Mobile | Other`
   - Deadline (DEADLINE_DATE) — `YYYY-MM-DD`, deadline time (DEADLINE_TIME, default `23:59`)
   - One-line core challenge (ONELINE_CHALLENGE)
   - Stack hint (STACK_HINT) — free-form
   - Environment notes (ENV_NOTES) — Next 16 / Python 3.13 / etc., or blank
   - **N evaluation criteria** — each with `name`, `points`. Usually 5-7. If absent from the spec, infer from interview questions / scoring guidance.

3. **Scaffold**:
   - Call `node ${TAKEHOME_KIT_ROOT}/bin/init.mjs --target ${PWD}` with the answers (or write files directly).
   - `${TAKEHOME_KIT_ROOT}` defaults to `~/Documents/Projects/takehome-kit/`. If different, confirm with the user.

4. **Next-steps guidance**:
   - Paste original company spec into the `<!-- SPEC PASTE START -->` region of SPEC.md
   - Fill PLAN.md §2 "Our planning interpretation"
   - Write 5-10 ADRs in DESIGN.md
   - Run `/dod-check` for the 8-gate verification

## Usage

```
/init-takehome
```

Or with variables prefilled:

```
/init-takehome company=AcmeCo product="Widget Builder" role="FE Engineer 3+yrs" deadline=2026-05-15
```

## Notes

- Any `{{VAR}}` placeholder remaining in generated files indicates an unanswered interview item. Fill it in manually.
- The most accurate way to enter evaluation criteria is to copy the company spec's score-allocation table verbatim. Inference is a last resort.
- The first commit is auto-created with message `chore(init): scaffold takehome-kit for {{COMPANY}} {{PRODUCT}}`.
