---
paths:
  - "backend/**"
---

# Rule: backend conventions

## Settings & secrets
- Config via `pydantic-settings`, `VULNDASH_` env prefix, typed. **No secrets in
  code or defaults.** Secrets (OIDC client secret, feed API keys) come from the
  environment / secret manager at runtime.

## API surface
- All feature endpoints live under `/api/v1`. Health (`/health/live`,
  `/health/ready`) is unversioned for infra probes.
- Routers are thin: validate → use case → DTO. Construct repositories/use cases
  from the request-scoped `AsyncSession` (`Depends(get_db)`); the **router** owns
  the commit for mutating endpoints.
- Protected routes depend on `require(*permissions)` (deny by default) and
  `enforce_csrf` for cookie-based mutations.

## DTOs & errors
- Request/response DTOs are Pydantic v2 with `alias_generator=to_camel` +
  `populate_by_name=True` — the wire contract is **camelCase**.
- Every error response is a `ProblemDetail`
  (`status, title, detail, correlationId, requestId`, camelCase). Map domain
  errors deterministically; never leak stack traces, SQL, secrets, or internal
  hosts. Mapping: 401 `AuthenticationRequiredError`, 403 `PermissionDeniedError`,
  404 `NotFoundError`, 409 `ConflictError`, 422 `ValidationError`
  (and `JustificationRequiredError`), 500 otherwise.

## Persistence
- SQLAlchemy 2.0 typed models on the shared `Base` (deterministic naming
  convention for stable Alembic output). UUID PKs.
- One Alembic revision per slice, stacked on the latest; deterministic, with a
  working `downgrade`. Register new models in
  `infrastructure/persistence/models/__init__.py` so autogenerate sees them.
- Enum values are stored/serialized as the UI string constants
  (`severity="HIGH"`, `triageState="ACTIVE"`).
- Upserts are idempotent on a natural key (`(source, external_id)` for vulns,
  `finding_key` for findings) and **preserve human-owned state** (triage) on
  refresh.
- Audit/history tables are append-only and enforced by a DB trigger, not just
  app code (see `triage_history`).

## Async
- Async all the way (async SQLAlchemy, httpx). Offload heavy/long work
  (parsing, diffing, ingestion) off the request path (worker queue, BE-3/BE-4).

## Commits
- Conventional Commits. One slice per commit where practical.
