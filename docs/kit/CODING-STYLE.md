# Coding Style

> The full coding standard. Two layers: **tool-enforced** (you don't memorize these — the linter blocks them) and **judgment** (read §2 before writing `src/` — these can't be linted).
> Derived from a reviewed reference implementation; examples are inlined so this doc is self-contained.

---

## How this is enforced

| Layer | Where | When it acts |
|---|---|---|
| **Tool-enforced** (§1) | [templates/eslint.config.mjs](templates/eslint.config.mjs) + [.prettierrc](templates/.prettierrc) | post-edit-lint (on Write/Edit) + DoD Gate 1 + pre-commit hook |
| **Judgment** (§2) | this doc | the agent reads it before `src/` work — advisory, not blockable |

The floor is the linter (can't merge below it). This doc is the ceiling (how to do it well). If a rule here can be moved into the linter, move it and delete the prose — tools over prose.

---

## §1 Tool-enforced (do not memorize — listed for reference only)

These live in `eslint.config.mjs`. Copy that template to the project root at Phase B.

| Rule | ESLint enforcement |
|---|---|
| No type escapes (`any` / object-literal `as`) | `@typescript-eslint/no-explicit-any`, `consistent-type-assertions` |
| No debug code | `no-console`, `no-debugger` |
| One-liner arrow: no braces | `arrow-body-style: as-needed` |
| No silent catch | `no-empty` (allowEmptyCatch: false) |
| `const` by default | `prefer-const` |
| Nesting depth ≤ 2 | `max-depth: 2` |
| No `I`/`T` type prefix | `naming-convention` |
| Constant casing by scope | `naming-convention` |
| Magic numbers | `no-magic-numbers` (warn) |
| `import type` for type-only imports | `consistent-type-imports` |
| No `dangerouslySetInnerHTML` | `react/no-danger` |
| Accessibility (most) | `eslint-plugin-jsx-a11y` (via `next/core-web-vitals`) |

**Opt-in (verified to break without extra setup):** `import/order` + `import/no-cycle` (#18, #24) throw on `eslint-config-next` 16's bundled resolver — enable only after `npm i -D eslint-import-resolver-typescript` and adding the resolver setting (see the commented block in the template). Boolean-name prefix enforcement needs typed linting (`parserOptions.project`), so it is **not** enforced — boolean naming is a judgment rule (§2.3).

**Non-Next stacks:** keep the rule *intent*, map to the equivalent linter (Python → ruff `ANN`/`T20`/`PLR`; etc.).

---

## §2 Judgment rules (read before writing `src/`)

Tooling can't enforce these. Each is one directive + a minimal example.

### 2.1 Directory & layering

- **`lib/<domain>/` = domain logic** (pure functions, no framework imports). **`utils/` = generic stateless helpers** (formatting, parsing). Keep the two separate.
- Never inline domain logic in components/endpoints.

```
src/lib/scoring.ts     # isCorrect(), getSetScore()      ← domain, pure
src/utils/time.ts      # formatSeconds()                 ← generic helper
```

### 2.2 Types

- **Placement**: shared domain types → `src/types/`. Types used by one module → colocate in that file.
- **Object shapes & Props: default to `interface`** (extends/composition ergonomics). Reach for `type` *deliberately* when you want a closed, non-mergeable shape or a composition (`A & B`). Unions/mapped/utility types are always `type`. Not linted — it's cosmetic (no correctness impact); the default just stops the agent coin-flipping. Don't mix arbitrarily within one concern.
- **State machines = `as const` object + union**, not `enum`:

```ts
export const SessionStatus = { IDLE: "idle", ACTIVE: "active", COMPLETED: "completed" } as const;
export type SessionStatus = (typeof SessionStatus)[keyof typeof SessionStatus];
export type Phase = "quiz" | "explanation";
```

### 2.3 Naming, conditions & constants

- **Named condition variables** — extract 2+ expression conditions to a `const` before the `if`:

```ts
const canConfirm = allAnswered && !isReview;   // not: if (allAnswered && !isReview)
if (canConfirm) ...
```

- **Positive boolean framing** — `isTestComplete`, not `testNotCompleted`; `hasActiveSession`, not `noActiveSession`. Fully on you: the linter can't enforce this without typed linting, and even then it would only check the `is`/`has` prefix, never the *polarity* (`isNotReady` passes a prefix check but is negative). Guard on the negation at the call site (`if (!isTestComplete)`), keep the variable positive.
- **String keys are magic values too** — extract repeated literal keys to named constants (the linter only catches numbers).

### 2.4 Components

- **Shared across 2+ routes → `src/components/`. Used by one page → colocate** in that page file (don't promote prematurely).
- Conditional `className` via **`clsx`**, not string concatenation.
- Props typed as an `interface`; no positional boolean args (use an options object / named props).

### 2.5 State management

- **One owner per piece of state**; derived values are computed in render, never stored as a second source of truth.
- Client store (e.g. Zustand) with persistence: **guard hydration** before reading persisted state, so SSR markup matches:

```ts
// expose hasHydrated; gate UI on it
if (!hasHydrated) return <LoadingSpinner />;
```

- Subscribe with **selectors** (`useStore((s) => s.session?.phase)`), not whole-store reads, to limit re-renders.

### 2.6 Data fetching

- Encapsulate fetch lifecycle in a hook returning **`{ data, loading, error, refetch }`**. Set an error string on failure (never swallow). Clean up with a `cancelled` flag to avoid post-unmount state writes.

### 2.7 Tests

- **Location**: `__tests__/` colocated next to source. **Extension**: `.test.tsx` for DOM, `.test.ts` for pure logic.
- **Fixtures**: factory builders (`makeQuestion(id, correctId)`), not copy-pasted literals.
- **Structure**: `describe(unit) → describe(scenario) → it("behaviour sentence")`.
- **Component queries are accessibility-first** — `getByLabelText` / `role`, asserting through the a11y layer.
- **Store logic** is tested directly via `getState()` / `setState()` with a `beforeEach` reset — no render needed.

### 2.8 Safety

- Render rich text by building nodes (`createElement` / JSX), **never `dangerouslySetInnerHTML`** (XSS). The linter blocks the escape hatch; this is the positive pattern.

### 2.9 File-internal declaration order

`imports → types/interfaces → module constants → helpers → main export`. Module constants come **before** helper functions (a common slip is declaring a `LABELS` array between two helpers).

---

## §3 Phase B setup

1. Copy [templates/eslint.config.mjs](templates/eslint.config.mjs) and [templates/.prettierrc](templates/.prettierrc) to the project root.
2. `npm i -D prettier` (needed for `.prettierrc` to apply). The §1 ESLint rules need **nothing** beyond `eslint-config-next` — `@typescript-eslint` comes transitively (verified on eslint 9.39 + eslint-config-next 16.2.6).
3. Wire `lint` / `test` / `build` scripts in `package.json` (DoD Gates 1–3 call these).
4. Confirm `post-edit-lint.sh` finds the `lint` script (it greps `package.json`).

> Once wired, the §1 rules are enforced automatically on every edit and commit — the agent does not need to recall them. Only §2 requires reading.

### Optional — import ordering (Prettier route, verified)

ESLint's `import/order` needs a module resolver that `eslint-config-next` 16 ships broken (`"invalid interface"`), so order imports in **Prettier** instead — no resolver, auto-fixed on format:

1. `npm i -D @ianvs/prettier-plugin-sort-imports`
2. Add to `.prettierrc`:
   ```json
   "plugins": ["@ianvs/prettier-plugin-sort-imports"],
   "importOrder": ["<BUILTIN_MODULES>", "<THIRD_PARTY_MODULES>", "^@/(.*)$", "^[./]"]
   ```
3. `npx prettier --write src` → groups sort to **builtin → third-party → `@/` → relative**. (No blank line between groups by default; insert `""` entries in `importOrder` if you want them.)

Trade-off: this does **not** detect circular imports (that was `import/no-cycle`'s job) — rely on `tsc`/the bundler for cycles. Verified: a 5-import sample reordered exactly as above under this config.
