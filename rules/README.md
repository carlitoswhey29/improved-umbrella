# Claude Project Rules

Rules keep the main `CLAUDE.md` concise. Whole-project rules are @-imported by
the root `CLAUDE.md`; path-scoped rules (with `paths` frontmatter) apply when
working on matching files — read them before editing those areas.

## Rule files

| Rule | Scope |
|---|---|
| `architecture-boundaries.md` | Whole project (imported by CLAUDE.md) |
| `security-compliance.md` | Whole project (imported by CLAUDE.md) |
| `testing-quality.md` | Whole project (imported by CLAUDE.md) |
| `backend-api.md` | `backend/**` (imported by CLAUDE.md while frontend is unstarted) |
| `frontend-angular.md` | `frontend/**` |
| `documentation-reporting.md` | `docs/**`, READMEs |
| `devops-observability.md` | Docker/Compose, devcontainer, CI, scripts |
