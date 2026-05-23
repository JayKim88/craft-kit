---
name: security-audit
description: Dedicated security audit — secrets archaeology, dependency CVEs, CI/CD pipeline, OWASP Top 10. Deeper than the surface scan in Procedure 8 Step 12.
triggers:
  - "보안 감사"
  - "security audit"
  - "취약점 확인"
  - "cso"
  - "owasp"
---

# Security Audit

Run [CLAUDE.md "Procedure 9 — Security Audit"](../../CLAUDE.md).

**Authoritative source**: `docs/procedures/proc-9-security.md`. Do not duplicate steps here — if drift is found, proc-9 wins.

**Quick reference**:
- Default mode: confidence gate 8/10 (zero noise)
- Flags: `--comprehensive` · `--diff` · `--secrets` · `--owasp` · `--deps`
- Every finding requires: exact file:line + exploit scenario + variant search
- No auto-fix — user owns all remediation decisions
