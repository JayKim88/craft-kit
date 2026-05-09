# Customizing for Different Assignment Types

`takehome-kit` is tech-neutral, but here's how to tailor it for different kinds of assignments.

---

## FE (Frontend) assignments

**Targets**: React/Vue/Angular SPAs, Next.js apps, visualization UIs, time-based UIs, etc.

### Extra coding rules in CLAUDE.md
- Split components by responsibility (Presentational vs Container)
- Separate state: server state (TanStack Query/SWR) ⊥ edit/UI state (Zustand/Redux/useState)
- Time / computation logic isolated in `src/lib/<domain>.ts` (no in-component computation)
- a11y: focus ring, ARIA, keyboard nav

### Extra ADR slots in DESIGN.md
- State-management library (TanStack Query / Zustand / Redux / Jotai)
- Mock-API strategy (MSW / json-server / static JSON)
- Modal / accessibility library (Radix / Headless UI / hand-rolled)
- Toast (react-hot-toast / Sonner / hand-rolled)
- Charts (Recharts / D3 / hand-rolled SVG)

### Extra CHECKLIST.md sections
```
### Grid / list visualization (FE)
- [ ] Accurate positioning (CSS Grid / absolute / flex)
- [ ] Readability — typography, color contrast
- [ ] Visual differentiation for collisions/overlap
- [ ] Empty-state handling

### Forms / modals (FE)
- [ ] Validation (server pre-check + immediate UI feedback)
- [ ] Keyboard nav (Tab, Esc, Enter)
- [ ] Focus trap

### Responsive (FE)
- [ ] Mobile view (when needed)
- [ ] Accessible keyboard flow
```

### Test strategy (FE)
- Tier 1: domain logic (time math, sorting, filtering) — pure functions, the bulk of tests
- Tier 2: RTL component tests — autocompletion, validation, conflict display
- Tier 3: integration — cache sync, error handling

---

## BE (Backend) assignments

**Targets**: REST APIs, GraphQL, CRUD, scheduling, settlement, notification systems.

### Extra coding rules in CLAUDE.md
- DB transactions start only in the service layer (never in controllers/middleware)
- No bypassing authorization checks without an authenticated user context
- Concurrency: explicitly choose optimistic vs pessimistic
- Every API response has an explicit schema (no auto-generated; use validated, typed schemas)

### Extra ADR slots in DESIGN.md
- DB choice (Postgres / MySQL / Redis / NoSQL)
- ORM (Prisma / TypeORM / Sequelize / raw SQL)
- Auth (JWT / Session / OAuth)
- Concurrency control (transaction isolation / optimistic locking)
- Idempotency (idempotency key / natural idempotency)
- Retry / timeout (exponential backoff / circuit breaker)
- Logging & monitoring

### Extra CHECKLIST.md sections
```
### Concurrency (BE)
- [ ] No race conditions under concurrent requests
- [ ] Optimistic locking or transaction isolation explicit
- [ ] Correct response when capacity/limit is reached

### Idempotency (BE)
- [ ] Same request N times → effect once
- [ ] Idempotency key or natural-key handling

### Data correctness
- [ ] Settlement / aggregation boundary cases (month-end, midnight, timezone)
- [ ] Consistency on partial failure (transaction rollback / saga)
- [ ] Retry / dead-letter on external API failures

### Operations
- [ ] Structured logging (request id, trace)
- [ ] Standardized error responses (code + message + details)
- [ ] OpenAPI / generated docs
```

### Test strategy (BE)
- Tier 1: domain logic (settlement math, state transitions) — pure functions
- Tier 2: API endpoints (request → response, auth/permissions)
- Tier 3: integration (real DB, transactions, concurrency scenarios)

---

## ML / Data assignments

**Targets**: model training, evaluation pipelines, data processing.

### Extra coding rules in CLAUDE.md
- Fix random seeds (reproducibility)
- Train/val/test split explicit
- Feature engineering pipeline as code (notebooks out of CI)
- Model versioning (per-experiment metrics)

### Extra ADR slots in DESIGN.md
- Framework (PyTorch / TF / sklearn / JAX)
- Experiment tracking (W&B / MLflow / homegrown)
- Data-split strategy (random / time-based / stratified)
- Evaluation metric (accuracy / F1 / AUC / RMSE)
- Baseline comparison

### Extra CHECKLIST.md sections
```
### Reproducibility
- [ ] Random seed fixed
- [ ] Requirements lock (pyproject.toml / requirements.txt)
- [ ] Data preprocessing pipeline is deterministic

### Evaluation
- [ ] Baseline comparison (naive model vs proposed model)
- [ ] Statistical significance (CV, std)
- [ ] Edge cases (out-of-distribution, class imbalance)
```

---

## Mobile assignments

**Targets**: React Native, Flutter, native iOS/Android.

### Extra coding rules in CLAUDE.md
- Handle screen rotation
- Background / foreground transitions
- Permission-request flows (location / camera / push)

### Extra ADR slots in DESIGN.md
- Navigation library (React Navigation / Flutter Navigator 2.0)
- State management
- Offline handling
- Push notifications

### Extra CHECKLIST.md sections
- Various device sizes
- iOS/Android native differences
- UX when permissions are denied

---

## Common: when the rubric is not 6 criteria

`init.mjs` accepts any 1-9 in `CRITERIA_COUNT`. Typical shapes:

- **5**: Requirements / Code / Stability / Documentation / Git
- **6** (fs-planner): + UI/UX
- **7**: + Performance / or + Security

When the rubric has 0 criteria (the company didn't specify):
1. Reverse-engineer categories from the spec's "interview questions" / "rationale" / "real-world scenario" sections
2. Codify the inferred categories as §1~§N in `CHECKLIST.md`
3. Make the assumed weighting explicit in PLAN.md §5 ("Rubric mapping")

Reviewers read this as "this candidate built their own rubric and worked to it" — likely bonus points.

---

## Common: missing tooling

If the project's lint/test setup is absent or non-standard, `/dod-check` can't run.

Fix:
1. Lock `lint`/`test`/`build` commands in Phase B (toolchain lock)
2. Add the standard scripts to `package.json` / `pyproject.toml` / `Cargo.toml`:
   - `lint`, `test`, `build`
3. `/dod-check` then auto-infers them

Manual fallback:
```bash
# Manual DoD check
npm run lint && npm test && npm run build && \
  ! grep -rn ': any\|console\.log' src/ && \
  echo "DoD: 5/5 auto gates passed"
```
