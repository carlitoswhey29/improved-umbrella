---
name: devops-observability-review
description: Review Docker, Compose, CI/CD, OpenTelemetry, logging, health checks, secrets handling, and runtime operational readiness for VulnDash without overstating production posture.
allowed-tools: Read, Glob, Grep
---

# DevOps and Observability Review Skill

Use this when reviewing Dockerfiles, Compose files, CI/CD workflows, telemetry
config, scripts, or deployment assets. This is a **read-only review** skill; it
reports findings, it does not edit. Ground every finding in
`.claude/rules/devops-observability.md` and `docs/architecture/ARCHITECTURE.md`
§2 (runtime topology).

## Required focus

- **Local vs. production separation.** Local Compose/devcontainer is
  development only and must never be described as a hardened production
  deployment. Flag any doc, comment, or config that blurs this.
- **Secret hygiene.** No secrets in images, Compose files, CI variables,
  scripts, logs, or examples. Configuration comes from typed `VULNDASH_*`
  settings; secrets from the environment/secret manager.
- **Health checks.** `/health/live` touches no dependencies; `/health/ready`
  reflects real PostgreSQL + Redis checks. Placeholder readiness is a finding.
- **Telemetry.** OTel is opt-in (`VULNDASH_OTEL_ENABLED`, no-op when off).
  Structured logs carry correlation/request IDs and metadata only — flag
  anything logging tokens, session IDs, or raw SBOM/vulnerability payloads.
- **Resilience.** Outbound feed calls go through the retry/backoff layer; one
  failing feed must not abort the others.
- **CI gates.** `uv run ruff check . && uv run mypy && uv run pytest`
  (backend); `npm run lint && npm run test:ci` (frontend, once present);
  DB-dependent tests need a disposable PostgreSQL. Note missing gates.
- **Scripts.** Explicit, idempotent where practical, safe to re-run.

## Rules

- Do not claim production-hardening, certification, or air-gap suitability from
  configuration alone; ⚠️ items stay ⚠️.
- Separate implemented / assumed / needs-review.
- Treat encryption-at-rest, secret management, and network segmentation as
  out-of-band concerns; note dependencies on them rather than asserting them.

## Output format

1. **Scope reviewed** — files/areas and runtime tier (local vs. target prod).
2. **Findings by severity** — exact file/line or config key.
3. **Recommended changes** — concrete, with file paths.
4. **Observability gaps** — missing health distinctions, telemetry, CI gates.
5. **Verification steps** — e.g. `docker compose config`, health probes.
6. **Proposed commit message** — scope usually `infra`.
