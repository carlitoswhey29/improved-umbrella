# VulnDash — Claude project memory

VulnDash is a self-hostable **vulnerability management dashboard**: ingest vuln
feeds (NVD/OSV/GitHub/custom), correlate them against uploaded SBOMs, and support
triage, alerting, and reporting. Monorepo: FastAPI **backend** (Clean/Hexagonal,
`backend/src/vulndash`) + Angular 21 **frontend** (`frontend/src/app`),
separated by an
explicit trust boundary.

## Repo layout

```
DEVELOPER.md            onboarding + commands + agent rules (read for setup/workflow)
backend/                FastAPI API (Clean/Hexagonal). See backend/README.md
frontend/               Angular 21 SPA (standalone, signals, zoneless) — UI-1…UI-8 implemented
docs/architecture/      ARCHITECTURE.md (system) + DIAGRAM/DATA_FLOW (planned)
docs/TRACEABILITY.md    requirement → status matrix (source of truth for status)
docs/BUILD-PLAN.md      original product build plan
docs/PLATFORM-MERGE.md  legacy-platform merge assessment (feature donor map)
legacy/vulndash-platform/  frozen prior prototype — reference only, never extend
.devcontainer/          dev container + Compose (Postgres/Redis) + dev.sh (backend + frontend) — dev only
.claude/                rules, agents, skills, commands, hooks, runtime plans
```

## The one property that matters most

**The backend re-checks every access decision and owns all heavy work.** Anything
the UI hides/disables is a usability affordance, not a security control. Parsing,
diffing, correlation, and ingestion are authoritative on the backend; the SPA
renders results.

## Golden rules (read before editing)

- @rules/architecture-boundaries.md
- @rules/backend-api.md
- @rules/security-compliance.md
- @rules/testing-quality.md

(If the imports above did not load, read those four files under
`.claude/rules/` before changing code.) Path-scoped rules — read before touching
the matching area: `rules/frontend-angular.md` (`frontend/**`),
`rules/devops-observability.md` (Docker/CI/devcontainer),
`rules/documentation-reporting.md` (`docs/**`, READMEs).

## Routing work (agents & skills)

Match the task to the specialist agent and its skill; for cross-cutting work use
the implementation agent first, then add the reviewer for the sensitive concern.
If docs, rules, and code conflict — stop and report the conflict before editing.

| Task | Agent | Skill / command |
| --- | --- | --- |
| Backend feature slice | `backend-api-engineer` | `backend-slice-implementation`, `/new-backend-slice` |
| Frontend feature | `frontend-angular-engineer` | `frontend-feature-implementation` |
| Architecture review | `architecture-reviewer` | `architecture-review` |
| Auth/security review | `security-compliance-reviewer` | `threat-model-review`, `requirement-traceability` |
| Tests & coverage | `test-quality-engineer` | `test-plan-generation` |
| Docs alignment | `documentation-maintainer` | `documentation-update`, `/update-docs` |
| Docker/CI/telemetry | `devops-observability-engineer` | `devops-observability-review` |

## Current status

`docs/TRACEABILITY.md` is the single source of truth for requirement/phase status
(✅ offline-verified · 🟡 implemented, runtime-pending · ⬜ not started · ⚠️ needs
security review). Per-phase task detail lives in `.claude/runtime/plans/`.

Read `docs/TRACEABILITY.md` for current per-phase status — it is the source of
truth and this summary intentionally stays high-level to avoid drift. In short:
BE-1…BE-8 and UI-1…UI-8 are implemented and offline-verified (domain/application
unit-tested; HTTP/PostgreSQL/Redis/OIDC runtime paths covered by
`backend/tests/integration/` + the Vitest/Playwright suites), tracked 🟡 pending
the first green run on a hosted CI runner. Items needing security review stay ⚠️.

## Verifying changes

Backend (from `backend/`): `uv run ruff check . && uv run mypy && uv run pytest`
and `uv run alembic upgrade head` (needs PostgreSQL). Run only what's relevant to
the changed files; if a command was not run, say so and list it for the
developer. See `/verify`.

## Conventions

- Conventional Commits (`feat(scope): …`). End completed work with
  `Proposed commit message: <type>(<scope>): <summary>` (see `/propose-commit`).
- Keep requirement IDs (VD-*) stable; update `docs/TRACEABILITY.md` and the
  relevant `.claude/runtime/plans/*` whenever a phase item lands.
- Do not assert any certification/ATO. Items marked ⚠️ require separate review.
- Cite only files/docs that exist; docs that are planned but unwritten
  (`DIAGRAM.md`, `DATA_FLOW.md`, `BACKEND.md`, `FRONTEND.md`) are referenced as
  "(planned)". If a referenced path is missing, say so rather than inventing
  content.
- Never print, commit, or log secrets, tokens, `.env` values, or feed API keys.
  Do not weaken auth, CSRF, audit, or validation controls to simplify a task —
  stop and flag instead.
