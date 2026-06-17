---
name: requirement-traceability
description: Map a code, feature, or documentation change to the VD-* requirement matrix in docs/TRACEABILITY.md and keep status marks honest.
allowed-tools: Read, Glob, Grep
---

# Requirement Traceability Skill

Use this when reviewing whether a change is reflected honestly in
`docs/TRACEABILITY.md` and the `.claude/runtime/plans/*` phase plans.

## Rules

- Status legend: ✅ implemented **and** verified offline · 🟡 implemented,
  runtime verification pending · ⬜ not started · ⚠️ requires security review
  (not met by implementation alone) · 🗓️ planned.
- Never mark ✅ because code compiles; runtime paths (endpoints, migrations,
  Postgres upserts/triggers, Redis, OIDC) stay 🟡 until exercised against live
  services.
- VD-* IDs are stable — never renumber; mark superseded items instead of
  deleting. New capabilities (including anything ported from
  `legacy/vulndash-platform/` via `docs/PLATFORM-MERGE.md`) get a new VD-* ID
  before implementation.
- ⚠️ items (OIDC hardening, credential encryption BE-8, retention) stay ⚠️
  regardless of code changes; no certification/ATO/air-gap claims.
- Keep the `_Last reviewed_` date current when status changes.

## Output format

| Requirement (VD-*) | Current status | Evidence (file/test) | Correct status | Action |
|---|---|---|---|---|

List the exact TRACEABILITY/plan rows to edit, then a proposed commit message.
