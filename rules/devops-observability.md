---
paths:
  - "**/Dockerfile"
  - "**/docker-compose*.yml"
  - "**/docker-compose*.yaml"
  - ".devcontainer/**"
  - ".github/workflows/**"
  - "backend/scripts/**"
---

# Rule: devops & observability

## Topology
- Local dev (dev container / Compose: Node 24 + uv/Python 3.12 + PostgreSQL +
  Redis + a worker) is **development only and is not a hardened production
  deployment.** Don't conflate the two in code, docs, or claims.
- Production (conceptual): a TLS terminator fronts the SPA artifact + API and
  sets `X-Forwarded-Proto` (which gates HSTS). Workers scale independently. For
  air-gap, feeds are mirrored out of band and external dispatch is disabled by
  config.

## Observability
- One request is traceable end to end: the SPA stamps `X-Correlation-ID` /
  `X-Request-ID`; the backend reads-or-generates them, binds them to logging +
  OTel, and echoes them back.
- OpenTelemetry is opt-in (`VULNDASH_OTEL_ENABLED`); no-op when disabled so dev
  and tests carry no telemetry dependency.
- **Logs carry IDs and metadata only** — never secrets, session identifiers, or
  raw SBOM / vulnerability payloads.

## Health
- `/health/live` (liveness) touches no dependencies — failure ⇒ restart.
- `/health/ready` (readiness) checks PostgreSQL + Redis — failure ⇒ pull from
  rotation without restarting.

## Resilience
- Outbound feed calls go through the retry/backoff layer (Retry-After honored;
  capped exponential backoff + jitter); only retryable errors are retried.
- A failing feed is isolated by the ingestion orchestrator — one bad feed does
  not abort the others.

## CI expectations
- Lint + type-check + unit tests must pass: backend `uv run ruff check . && uv
  run mypy && uv run pytest`; frontend `npm run lint && npm run test:ci`.
- DB-dependent tests run against a disposable PostgreSQL (the migrations and the
  Postgres-specific upsert/trigger paths cannot be verified without one).
- Implemented in `.github/workflows/ci.yml`: lint/type/offline suite, then
  `backend/tests/integration/` (gated on `VULNDASH_TEST_DATABASE_URL`) against
  PostgreSQL 16 + Redis 7 service containers. Keep the gate: the offline suite
  must stay runnable with no services.

## Sandbox note (frontend builds)
- Broad secret-protection read-deny globs (`**/*token*`, `**/*key*`,
  `**/*secret*`) also match third-party source under `node_modules` and break
  Node tooling with `ERR_MODULE_NOT_FOUND`. Keep deny globs anchored to real
  secret artifacts and keep dependency trees readable.
