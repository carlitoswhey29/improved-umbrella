# Rule: architecture layering & boundaries (Clean / Hexagonal)

The backend is layered; dependencies point inward only.

```
api/  →  application/  →  domain/   ←  infrastructure/
```

- **`domain/`** — entities, value objects, policies. **No framework, transport,
  ORM, or third-party imports.** Pure and unit-testable in isolation (e.g.
  `domain/correlation`, `domain/users`, `domain/sbom`, `domain/triage*`).
- **`application/`** — use cases / orchestration. Defines **ports** (Protocols)
  it depends on (`FeedAdapter`, `VulnerabilityRepository`, `CorrelationRepository`,
  `FindingsRepository`, `SbomRepository`, auth `SessionStore`/`IdentityProvider`).
  Depends on `domain`, never on `infrastructure`.
- **`infrastructure/`** — adapters implementing the ports: persistence
  (SQLAlchemy), feed clients (httpx), identity (Redis/OIDC), telemetry. This is
  the **only** layer allowed to import third-party runtime libs.
- **`api/`** — transport: app factory, middleware, error contract, thin routers,
  request-scoped dependencies. Routers: **validate input → call a use case →
  return a DTO.** No business logic in routers.

## Hard constraints

- A third-party runtime dependency (`sqlalchemy`, `httpx`, `redis`, `fastapi`)
  must be importable from **one** infrastructure module only; the rest of the
  code depends on the port. This keeps domain/application unit-testable with
  fakes and no network/DB (see testing rule).
- `domain` modules must not import from `application`, `infrastructure`, or `api`.
- Cross-feature reuse goes through `domain`/`application`, never `api`→`api`.
- No vague `utils`/`helpers`/`misc`/`common`/`manager` buckets — name modules by
  responsibility (e.g. `role_permission_policy`, `triage_lifecycle`,
  `correlation/versions`).

When adding a feature, build the slice top→down: DTO → thin router → use case →
port → adapter/repository → migration. See `/new-backend-slice`.

Architecture decisions affecting the trust boundary, auth model, audit trail, or
external integrations belong in `docs/architecture/ARCHITECTURE.md` (or an ADR),
not only in code. `legacy/vulndash-platform/` is frozen and exempt — never
extend it; port via `docs/PLATFORM-MERGE.md`.
