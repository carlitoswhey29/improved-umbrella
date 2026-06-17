---
description: Run the VulnDash verification suite and report status honestly
---

Run the checks below and summarize pass/fail. Do **not** mark anything ✅ that
only compiled — distinguish offline-verified from runtime-pending per
`.claude/rules/testing.md`.

Backend (from `backend/`):
- `uv run ruff check .`
- `uv run mypy`
- `uv run pytest`
- `uv run alembic upgrade head` (requires PostgreSQL; skip + note if unavailable)

Frontend (from `frontend/`, if present):
- `npm run lint`
- `npm run test:ci`
- `npm run build:prod`

If the environment has no network/DB (e.g. the build sandbox), run the
framework-free unit tests, then explicitly list which runtime paths
(endpoints, migrations, Postgres upserts/triggers, Redis, OIDC) were **not**
exercised. Finish by noting whether `docs/TRACEABILITY.md` needs a status update.
