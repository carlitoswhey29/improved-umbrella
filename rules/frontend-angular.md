---
paths:
  - "frontend/**"
---

# Rule: frontend conventions (Angular 21)

The SPA is presentation + **advisory** authorization only. It holds no secrets
and is never the source of truth for access decisions.

## Structure & style
- Standalone components (no NgModules), functional providers, **signals** for
  state, **zoneless** change detection (the v21 default). Lazy `loadComponent`
  routing with `PreloadAllModules`.
- Folders by responsibility: `core/` (auth, authorization, http interceptor,
  config, logging, telemetry, errors, live-alert SSE client, theme, icons),
  `domain/` (framework-free typed models — no transport/UI imports), `features/`
  (lazy-loaded surfaces), `layout/`, `shared/`. No `utils`/`helpers`/`misc`.

## Contracts with the backend
- The wire contract is camelCase; mirror backend DTOs in `domain/`.
- Map `ProblemDetail` status → UX: 401 → session-expired, 403 → denied state.
- Stamp `X-Correlation-ID` / `X-Request-ID` on every request via the interceptor.
- Auth is cookie-based (BFF): **no tokens in browser storage.** Echo the CSRF
  token (read from the non-httpOnly CSRF cookie) in `X-CSRF-Token` on mutations.
- `requirePermission(...)` route guards mirror backend RBAC for instant UX — but
  are advisory; the backend re-checks.

## Performance & a11y
- Large tables (findings, inventory) use CDK virtual scroll over **server-driven**
  pagination/filtering — never hold the full dataset in memory.
- Icons are self-hosted SVGs (`fill="currentColor"`), registered at bootstrap —
  no icon webfont/CDN runtime dependency (air-gap friendly).
- Theme is a class swap on `<html>` bridged to the `--vd-*` token contract;
  persist only a non-sensitive UI preference.

## Testing
- Vitest (the v21 default) for units; Playwright for E2E of the
  upload→correlate→triage flow.
