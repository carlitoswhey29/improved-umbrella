---
name: test-plan-generation
description: Generate or review test plans for VulnDash changes, keeping the offline-unit vs. runtime-verification split honest.
allowed-tools: Read, Glob, Grep
---

# Test Plan Generation Skill

Use this before or after implementation to define verification coverage.
Follow `.claude/rules/testing-quality.md`.

## Required coverage types

- **Domain behavior** (pure, offline): version comparators (semver/PEP 440/
  generic), PURL/CPE parsing, correlation matcher, retry/backoff math, RBAC
  matrix, triage lifecycle.
- **Use-case orchestration** with fake repositories (ingest→scan, correlate,
  triage, sync) — no DB/network; the offline suite must not import
  fastapi/redis/httpx/sqlalchemy.
- **Runtime paths** (need live services; tracked 🟡 until exercised): HTTP
  endpoints via `TestClient`, Alembic migrations, Postgres upserts/triggers,
  Redis sessions, OIDC.
- **Security negatives:** missing/insufficient permission (401/403), CSRF
  missing on mutation, validation failures (422), illegal transition (409).
- **Fixtures:** small representative CycloneDX/SPDX files, a synthetic vuln
  feed; deterministic clocks/IDs.
- **Frontend** (once `frontend/` exists): Vitest units, Playwright
  upload→correlate→triage E2E.

## Output format

1. Test scope.
2. Test matrix (offline vs. runtime clearly separated).
3. Fixtures needed.
4. Commands to run (`uv run pytest` from `backend/`).
5. Coverage gaps.
6. Proposed commit message.
