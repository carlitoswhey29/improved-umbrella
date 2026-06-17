---
name: threat-model-review
description: Review VulnDash feature changes for threats, abuse cases, trust boundaries, data flows, and mitigations.
allowed-tools: Read, Glob, Grep
---

# Threat Model Review Skill

Use this when a change adds or modifies a feature, integration, data flow,
identity boundary, upload path, or external dispatch.

## VulnDash-specific surfaces to consider

- SBOM uploads (size/schema validation, parser robustness, worker isolation).
- Feed ingestion (untrusted external JSON, SSRF via custom feed URLs,
  rate-limit/retry behavior).
- Sessions & CSRF (BFF cookie model, double-submit, CORS allowlist).
- RBAC (deny-by-default, object-level scoping gaps, IDOR).
- Feed credentials (custody, BE-8 encryption-at-rest still ⚠️).
- Triage audit trail (append-only trigger, tamper evidence, retention ⚠️).
- External dispatch (email/webhook/ticketing payload content; air-gap config).

## Required analysis

- Assets involved.
- Actors and roles.
- Trust boundaries crossed.
- Entry points.
- Abuse cases.
- Sensitive data touched.
- Existing mitigations (cite the actual code/rule).
- Required tests.

## Output format

| Threat / Abuse Case | Impact | Existing Mitigation | Gap | Recommended Control | Test Evidence |
|---|---|---|---|---|---|

End with a proposed commit message.
