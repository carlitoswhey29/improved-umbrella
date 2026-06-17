---
description: Plan and implement a backend or frontend feature slice using the matching implementation skill.
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
---

Implement the feature slice for: $ARGUMENTS

Select the matching skill:
- Backend / Python / API work → `backend-slice-implementation`
  (DTO → thin router → use case → port → repository → migration), per
  `.claude/rules/backend-api.md` and `architecture-boundaries.md`.
- Frontend / Angular / UI work → `frontend-feature-implementation`
  (domain model → core API service → signal state → component → advisory RBAC
  gating). Note: `frontend/` is not started — confirm scaffolding intent first.

Then use `test-plan-generation` for the verification matrix. Map the work to a
VD-* requirement in `docs/TRACEABILITY.md` and update its status honestly. End
with a proposed commit message.
