---
name: backend-slice-implementation
description: Plan and implement a VulnDash backend vertical slice (camelCase DTO, thin router, use case, framework-free domain, port, repository/adapter, Alembic migration) per the layering rules. Use before and during backend API work; pair with test-plan-generation for verification.
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
---

# Backend Slice Implementation Skill

Use this when adding or changing a backend API capability so the change lands as
a correct, layered vertical slice rather than logic leaking across boundaries.
This skill governs **how the slice is built**; use `test-plan-generation` for
the verification matrix. Do not restate architecture — it lives in
`docs/architecture/ARCHITECTURE.md` and `.claude/rules/architecture-boundaries.md`.

## Before editing — confirm the slice

- **Requirement.** Map the work to a VD-* requirement and BE phase in
  `docs/TRACEABILITY.md` / `.claude/runtime/plans/BACKEND-DEVELOPMENT-PLAN.md`.
  New capabilities get a VD-* ID first.
- **Wire contract.** DTOs are **camelCase** on the wire (Pydantic v2
  `alias_generator=to_camel`, `populate_by_name=True`) regardless of internal
  `snake_case`. Note the exact path under `/api/v1`, method, request/response
  DTO, and required permission.
- **Affected layers.** List every layer the slice touches, top to bottom, and
  confirm placement before writing.
- **Conflicts.** If `docs/`, `.claude/rules`, and existing code disagree, stop
  and state the conflict — do not silently pick one.
- **Legacy donor.** If `docs/PLATFORM-MERGE.md` maps a legacy module to this
  capability, read it as a behavioral reference — re-implement through the
  layering; never copy.

## Required layered elements (build top → bottom)

Walk each layer; for a slice that does not need one, say why.

- **`api/schemas/` DTO.** Pydantic v2, camelCase alias, strict types; request
  and response models distinct. No domain logic.
- **`api/routers/` router.** Thin: validate DTO → resolve auth dependency →
  call one use case → map result to DTO → return status code. Gate with
  `require(<permission>)` (+ `enforce_csrf` for mutations). The **router owns
  the commit** for mutating endpoints. No business rules, no SQL.
- **`application/` use case.** Orchestrates domain + ports. Depends on
  repository **Protocols**, never concrete infrastructure types.
- **`domain/`.** Pure entities/policies, no framework/HTTP/persistence imports.
  Re-validate invariants here even if the DTO already validated. Reuse existing
  policies (`triage_lifecycle`, `role_permission_policy`, `correlation/*`)
  rather than re-encoding rules.
- **`infrastructure/persistence/`.** SQLAlchemy 2.0 typed model on the shared
  `Base` + repository implementing the port. UUID PKs; enum values stored as
  the UI string constants. Upserts idempotent on the natural key
  (`(source, external_id)` for vulns, `finding_key` for findings) and
  preserving human-owned state (triage) on refresh. Repositories do not commit.
- **`alembic/versions/` migration.** One revision stacked on the latest;
  deterministic; working `downgrade`. Register new models in
  `infrastructure/persistence/models/__init__.py`. Append-only tables get a
  DB-level trigger (see `triage_history`).

## Required cross-cutting checks (every mutating slice)

- **Authorization.** `require(...)` deny-by-default; object-level scoping where
  the resource has an owner.
- **Justification.** Transitions the triage lifecycle flags as
  justification-required must enforce it server-side
  (`JustificationRequiredError` → 422).
- **Error mapping.** Deterministic `ProblemDetail`: 401/403/404/409/422/500 per
  `.claude/rules/backend-api.md`. No stack traces, SQL, secrets, or internal
  hosts.
- **Async & offload.** No blocking calls on the request path; heavy work
  (parsing, diffing, ingestion) goes to the worker (BE-3/BE-4 plan).
- **Logging hygiene.** IDs and metadata only — never session IDs, secrets, or
  raw SBOM/vulnerability payloads.

## Output format

1. **Slice summary** — VD-* requirement, phase, endpoint(s), DTOs, permission.
2. **Layer-by-layer plan or diff** — file path + responsibility per layer;
   created vs. modified.
3. **Cross-cutting checklist** — authz, justification, error mapping,
   async/offload, logging hygiene.
4. **Verification** — `uv run ruff check .`, `uv run mypy`, `uv run pytest`
   (from `backend/`), `uv run alembic upgrade head` (needs PostgreSQL); state
   which were run vs. must be run. Runtime-only paths stay 🟡.
5. **Traceability update** — the `docs/TRACEABILITY.md` /
   `.claude/runtime/plans/*` rows to update, with honest status marks.
6. **Proposed commit message** — Conventional Commit, scope usually `api`.
