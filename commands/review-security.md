---
description: Run a focused security review for the supplied path or topic.
allowed-tools: Read, Glob, Grep
---

Use the `threat-model-review` and `requirement-traceability` skills as
applicable to review: $ARGUMENTS

Focus on deny-by-default RBAC, session/CSRF handling, credential custody (BE-8
is still ⚠️), the append-only triage audit trail, input/upload validation,
error-contract hygiene, and external integrations. Keep ⚠️ items ⚠️; never
assert certification/ATO/air-gap suitability from implementation alone. End
with a proposed commit message.
