---
description: Scaffold a backend feature slice following VulnDash conventions
argument-hint: <feature name and what it does>
---

Implement a backend vertical slice for: $ARGUMENTS

Follow `.claude/rules/architecture-layering.md` and
`.claude/rules/backend-conventions.md`. Build top→down and keep the core
offline-testable (`.claude/rules/testing.md`):

1. **DTOs** — `api/schemas/<feature>.py`, Pydantic v2 camelCase.
2. **Thin router** — `api/routers/<feature>.py`: validate → use case → DTO;
   gate with `require(<permission>)` (+ `enforce_csrf` for mutations); the router
   owns the commit.
3. **Use case + port** — `application/<feature>.py`: orchestration depending on a
   repository **Protocol** (no infrastructure import).
4. **Domain** — entities/policies in `domain/<feature>/` (framework-free) if the
   slice has real invariants.
5. **Repository/adapter** — `infrastructure/persistence/<feature>_repository.py`
   implementing the port; confine SQLAlchemy here; do not commit.
6. **Migration** — one Alembic revision stacked on the latest; register new
   models in `infrastructure/persistence/models/__init__.py`.
7. **Tests** — unit-test the domain + use case with fakes (no DB/network);
   note which runtime paths need a live PostgreSQL.

Map errors to the `ProblemDetail` contract. Then update the relevant
`.claude/runtime/plans/*` and `docs/TRACEABILITY.md` (keep IDs stable, set the
honest status mark, bump the review date). Propose a Conventional Commit message.

Before relaxing any security control to simplify the task, stop and flag it
(`.claude/rules/security-compliance.md`).
