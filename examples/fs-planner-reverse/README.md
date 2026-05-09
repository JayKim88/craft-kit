# fs-planner Reverse-Engineer Validation Report

Confirms that the `recruit-kit` template faithfully reproduces a real, validated workflow (fs-planner: FuturSchool 5-day FE assignment).

## Method

1. Extract header structure from the 9 actual fs-planner documents (`CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/SPEC.md`, `docs/PLAN.md`, `docs/DESIGN.md`, `docs/PROCESS.md`, `docs/CHECKLIST.md`, `docs/AI_USAGE.md`).
2. Extract header structure from the same documents in `recruit-kit` (using quiet-mode scaffold).
3. Compare matched / missing / added sections.
4. Backport sections that are generically valuable to the template.

Original comparison table → [comparison.txt](comparison.txt)

## Match-rate summary

| Document | Original headers | Template headers | Match | Notes |
|---|---|---|---|---|
| CLAUDE.md | 10 | 10 | **100%** | "Next 16 caveats" generalized to "Environment notes (optional)" |
| AGENTS.md | 1 | 1 | **100%** | Generic equivalent |
| README.md | 16 | 18 | **95%** | DESIGN sub-sections (time-logic split, grid placement, etc.) are filled by users as ADRs. ➕ "Reference docs" section added (improvement) |
| SPEC.md | ~30 | 6 | **100% structural** | Original-spec parts (task list, scope, API schema) are delegated to the PASTE region. Rubric / interview / rationale skeleton preserved |
| PLAN.md | 12 | 12 | **100%** | Backported "External dependency decisions" → 100% match. fs-planner's "Mock API decision" enters as a generic equivalent |
| DESIGN.md | 15 | 14 | **90%** | Domain-specific ADRs (MSW boot / TQ cache / Zustand action signature) abstracted to ADR-001~ADR-N slots. ➕ "Domain-logic isolation principle" and "Test strategy" added (improvement) |
| PROCESS.md | 7 | 7 | **100%** | Phase 0–4 structure preserved; only feature names become placeholders |
| CHECKLIST.md | ~28 | ~17 | **60%** | Phase A/B/C structure preserved. Domain-specific sub-sections (grid shell, block visualization, modal forms, etc.) are filled by users from SPEC — **intentional abstraction** |
| AI_USAGE.md | 4 | 4 | **100%** | Table layout & sections preserved |

**Weighted average**: ~95% (CHECKLIST's domain-specific abstraction is intentional design, not a miss)

## Conclusion

✅ **Validation passes.** The template faithfully reproduces fs-planner's SSOT workflow. Domain-specific areas are delegated to placeholders / HINTs / ADR slots so the same skeleton works for BE/ML and other assignment types.

## Backport applied

Added during validation:

1. **`template/docs/PLAN.md.tpl`** — added an "External dependencies / environment decisions (response to SPEC's 'free-choice' areas)" section at the end of §3 "Scope". Generalizes the fs-planner MSW decision (works for FE/BE/ML alike: Mock API · DB · deployment env, etc.).

## Intentionally NOT backported

- **fs-planner DESIGN.md domain-specific ADRs** (`MSW boot strategy`, `Zustand store signature`, `conflict-detection algorithm`, etc.): these are user-filled in the ADR-001~N slots. Forcing them in the template would gut BE assignments.
- **fs-planner CHECKLIST.md component-level items** (`grid shell`, `block visualization`, etc.): SPEC-dependent. Adding them to the template would force users to mark items irrelevant to their own SPEC.
- **fs-planner README.md 8 design-decision sub-sections**: directly tied to that SPEC's §5 (Documentation) rubric. The template uses `DECISION_1_TITLE`, `DECISION_2_TITLE` placeholders so users write the right number for their own rubric.

## Reproduction artifacts

The `regenerated/` folder holds the 9 documents produced in quiet mode (interview-less, placeholders preserved). After running an actual interview, `{{COMPANY}}`, `{{P1}}`, etc., are substituted with the user's input.
