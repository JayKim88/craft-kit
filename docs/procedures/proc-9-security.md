# Procedure 9 — Security Audit

**Trigger**: "보안 감사" / "security audit" / "취약점 확인" / "cso"

> Procedure 8 Step 12 covers obvious surface-level security issues as part of a code review.
> This procedure is a dedicated, deeper security audit — no auto-fix, full diagnosis,
> user owns all decisions.

---

## Modes

| Flag | Gate | Use |
|------|------|-----|
| *(default)* | 8/10 confidence | Daily quick audit — zero noise over zero misses |
| `--comprehensive` | 2/10 confidence | Monthly deep scan — surface everything including speculative |
| `--diff` | 8/10 confidence | Branch changes only (`git diff main...HEAD`) |
| `--secrets` | 8/10 confidence | Secrets archaeology only (Phases 0 + 2) |
| `--owasp` | 8/10 confidence | OWASP Top 10 only (Phases 0 + 5) |
| `--deps` | 8/10 confidence | Dependency supply chain only (Phases 0 + 3) |

---

## Pre-emit gate (apply to every finding before reporting)

Before including any finding in the report:

1. **Quote the motivating line** — paste the exact file path + line of code that triggers the finding. If you cannot point to a specific line, move to appendix only.
2. **Write the exploit scenario** — step-by-step: attacker preconditions → action → impact. If the scenario requires physical access, authenticated admin access, or social engineering as a prerequisite, downgrade confidence by 2.
3. **Check the false positive list** — if the finding matches any exclusion rule below, suppress it entirely (do not include in appendix unless --comprehensive mode).
4. **Variant search** — once a pattern is verified, `grep` the full codebase for the same pattern. Report all instances, not just the one you found first.

---

## Phases

### Phase 0 — Stack detection

Detect: runtime (Node / Python / Go / Rust / Java / other) · framework · auth mechanism · data stores · external integrations · deployment target.

Output: one-line stack summary used to scope subsequent phases.

---

### Phase 1 — Attack surface census

Map all entry points where untrusted input enters the system:
- HTTP routes / API endpoints (REST, GraphQL, WebSocket)
- CLI argument parsing
- File upload handlers
- Environment variable consumption
- Inter-service calls (webhooks received, queue consumers)
- User-controlled configuration fields

Flag format: `ℹ Surface — <entry point> at <file>:<line> accepts <input type>`

This phase is informational only — no severity assignment. Used to focus Phases 4-6.

---

### Phase 2 — Secrets archaeology

**In current code:**
- Hardcoded credentials, API keys, tokens, private keys in source files
- `.env` files tracked by git (`git ls-files | grep -i env`)
- Secrets passed as inline strings to HTTP client calls
- Private keys or certificates committed to repo

**In git history** (last 200 commits):
```bash
git log --all --oneline | head -200
git log --all -p --follow -- "**/.env*" 2>/dev/null | grep "^\+" | grep -iE "(key|secret|token|password|credential)" | head -40
```

Flag format: `🚨 Secrets — <type> found at <file>:<line> (or commit <hash>). Rotate immediately.`

---

### Phase 3 — Dependency supply chain

- Run the stack's native audit tool:
  - Node: `npm audit --json` or `yarn audit` or `pnpm audit`
  - Python: `pip-audit` or `safety check`
  - Go: `govulncheck ./...`
  - Rust: `cargo audit`
- Check for unpinned dependencies (ranges like `^`, `~`, `*`) in production deps
- Check lockfile presence — missing lockfile means non-reproducible installs
- Spot-check install scripts (`postinstall`, `setup.py`) for suspicious commands

Flag format: `🚨 Dependency — <package>@<version> has <CVE-ID> (<severity>). Fix: upgrade to <version>`

---

### Phase 4 — CI/CD pipeline security

Scan `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, or equivalent:
- Actions/steps pinned to a commit SHA, not a branch or tag
- `pull_request_target` trigger with checkout of PR code (privilege escalation risk)
- Script injection: `${{ github.event.pull_request.title }}` interpolated into `run:` blocks
- Secrets printed to logs (`echo $SECRET`, `set -x` with secrets in scope)
- Overly broad permissions (`permissions: write-all`)

Flag format: `🚨 CI/CD — <workflow file>:<line>. Pattern: <what>. Attack: <how>`

---

### Phase 5 — OWASP Top 10

Assess each category. Mark ✅ clean / ⚠ partial / ❌ vulnerable.

| ID | Category | Check |
|----|----------|-------|
| A01 | Broken Access Control | Auth checks on every sensitive route; IDOR patterns |
| A02 | Cryptographic Failures | Sensitive data in plaintext; weak algorithms (MD5, SHA1 for passwords) |
| A03 | Injection | SQL/shell/LDAP/template injection; parameterized queries vs string concat |
| A04 | Insecure Design | Threat model gaps from Phase 1 surface census |
| A05 | Security Misconfiguration | Debug mode in prod; default credentials; verbose errors |
| A06 | Vulnerable Components | Phase 3 results |
| A07 | Auth & Session Failures | Weak password policy; session fixation; token entropy |
| A08 | Software & Data Integrity | Phase 4 CI/CD + Phase 3 deps |
| A09 | Logging & Monitoring Failures | Sensitive data in logs; missing audit trail for auth events |
| A10 | SSRF | User-controlled URLs fetched server-side without allowlist |

Flag format: `❌ <A0N> — <specific instance at file:line>. Exploit: <scenario>`

---

### Phase 6 — False positive filtering

Before finalizing the report, apply all exclusion rules. Suppress any finding that matches.

**Hard exclusions** (never report unless --comprehensive):
1. Denial-of-service via resource exhaustion — unless it also bypasses authentication
2. Memory leaks with no security impact
3. Findings in `test/`, `__tests__/`, `spec/`, `*.test.*`, `*.spec.*` files
4. Findings in generated code (`dist/`, `build/`, `*.generated.*`, vendored `vendor/`)
5. Issues requiring physical device access as a precondition
6. Theoretical attacks with no realistic path given the deployment context
7. Missing rate limiting — unless the endpoint handles authentication or sensitive data
8. Error messages exposing stack traces — flag as informational (ℹ), not critical
9. UUIDs or random tokens described as "guessable" — they are not unless entropy is provably low
10. Secrets present only in test fixture files with fake values (e.g., `"password": "test123"` in a mock)

**Confidence calibration:**
- **9–10** — Verified: you traced the exploit path end-to-end in code
- **7–8** — Pattern match: code pattern is clearly vulnerable, path not fully traced
- **5–6** — Probable: likely vulnerable but requires runtime context to confirm
- **< 5** — Speculative: include only in `--comprehensive` mode, in appendix

---

## Output format

```
=== Security Audit ===
Mode: <default|comprehensive|diff|secrets|owasp|deps>
Stack: <detected stack summary>
Scope: <N files scanned | git diff HEAD | full repo>
Confidence gate: ≥N/10

── Secrets & Credentials ──
  🚨 [9/10] Hardcoded Stripe key in src/config.ts:14
      Exploit: attacker reads source → uses key → charges arbitrary amounts
  ✅ Git history clean (last 200 commits)

── Dependencies ──
  🚨 [8/10] lodash@4.17.4 — CVE-2021-23337 (prototype pollution, CVSS 7.2)
      Fix: upgrade to lodash@4.17.21
  ✅ Lockfile present

── CI/CD ──
  ⚠ [7/10] .github/workflows/deploy.yml:12 — action pinned to branch tag, not SHA
      Fix: pin to commit SHA

── OWASP Top 10 ──
  ❌ A03 Injection — SQL concat in src/db/users.ts:88
      Exploit: POST /users?name='; DROP TABLE users; -- → unparameterized query executed
  ✅ A07 Auth failures — session tokens are cryptographically random (128-bit)
  ⚠ A09 Logging — user passwords logged at src/auth/login.ts:33 on failed attempt

── Below confidence gate (appendix) ──
  [5/10] Missing rate limit on /api/search — low priority, no sensitive data exposed

──────────────────────────────────────────
Summary
  🚨 Critical (≥8/10):  2
  ⚠  High    (6–7/10):  1
  ℹ  Below gate:        1 (appendix)
──────────────────────────────────────────
Decisions needed from you:
  1. Rotate Stripe key immediately? (src/config.ts:14)
  2. Upgrade lodash now or log to tech-debt-tracker?
  3. Fix SQL concat in db/users.ts:88 before next commit?
```

---

## Output rules

- **Every 🚨 finding must include an exploit scenario** — no scenario, no report
- **Quote the exact file:line** — no finding without a pointer to motivating code
- **Never auto-fix** — report only; user owns remediation decisions
- **Do not report what is already in tech-debt-tracker.md** as a new finding — reference it instead
- **No false urgency** — a 5/10 finding is not critical; calibrate language to confidence
- After the report, if the user says "fix it": execute the fix and report what changed. For structural changes (auth architecture, query parameterization), require explicit approval per item.
