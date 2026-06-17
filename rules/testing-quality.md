# Rule: testing

## Keep the core offline-testable
- Domain and application logic must be unit-testable **without** a network, DB,
  or web framework. Achieve this by depending on ports and confining
  `sqlalchemy`/`httpx`/`redis`/`fastapi` to single infrastructure modules
  (see the layering rule). Tests use fakes for the ports.
- A guard worth keeping: the offline unit suite must not import
  fastapi/redis/httpx/sqlalchemy. If it does, a dependency leaked out of
  infrastructure.

## What to test where
- **Highest priority** (most logic-dense, most likely to be subtly wrong): the
  version comparators (semver / PEP 440 / generic), PURL/CPE parsing, the
  correlation matcher, the retry/backoff math, the RBAC matrix, and the triage
  lifecycle. These are pure — test them thoroughly.
- **Use cases** (ingest→scan, correlate, triage, sync) — test orchestration with
  fake repositories.
- **Runtime paths** (HTTP endpoints, migrations, Postgres upserts/triggers,
  Redis sessions, OIDC) — these need live services. Cover them with FastAPI
  `TestClient` + a disposable PostgreSQL/Redis in CI. Until then they are tracked
  🟡 "runtime verification pending", not ✅.

## Status honesty
- `docs/TRACEABILITY.md` legend: ✅ = implemented **and** verified offline;
  🟡 = implemented + compiles but needs a live runtime; ⬜ = not started;
  ⚠️ = needs security review. Do not mark something ✅ on the basis of "it
  compiles". Keep the review date current when status changes.

## Fixtures
- Keep small representative CycloneDX/SPDX files and a synthetic vuln feed for
  deterministic correlation tests; seed 100k+ findings to validate virtual
  scroll + server pagination under load.
