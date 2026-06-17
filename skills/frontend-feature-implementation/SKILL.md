---
name: frontend-feature-implementation
description: Plan and implement a VulnDash Angular 21 feature slice (framework-free domain model, core API service, signal state, standalone component, advisory RBAC gating, a11y, loading/error/empty states) matching the backend camelCase contract. Note frontend/ is not started yet.
allowed-tools: Read, Glob, Grep, Edit, Write
---

# Frontend Feature Implementation Skill

Use this when adding or changing an Angular feature so the change lands as a
correct, layered slice with cross-cutting concerns (auth UX, a11y, error states)
handled rather than bolted on. Layering and conventions live in
`.claude/rules/frontend-angular.md` and `docs/architecture/ARCHITECTURE.md` §3.2.

**`frontend/` does not exist yet.** If it is absent, confirm whether this task
scaffolds it (per `.claude/runtime/plans/UI-DEVELOPMENT-PLAN.md` and
`DELIVERY-PLAN.md`) before inventing any file.

## Before editing — confirm the slice

- **Contract source.** Identify the backend endpoint(s) and DTO shapes in
  `backend/src/vulndash/api/schemas/` (the wire format is **camelCase** in both
  directions). The typed `domain/` model mirrors those field names exactly.
- **Layer placement.** Cross-cutting → `core/`; framework-free typed models →
  `domain/`; presentation → `features/<area>/`; shell/nav → `layout/`; reusable
  widgets → `shared/`. No vague `utils`/`helpers`/`misc` buckets.
- **Permission(s).** Identify the permission gating the route/actions —
  `requirePermission(...)` guards mirror backend RBAC but are **advisory**.
- **Conflicts.** If the backend contract, plans, and rules disagree, stop and
  state the conflict — do not guess.

## Required layered elements

- **`domain/` model.** Framework-free TypeScript interfaces/enums; no Angular,
  HTTP, or UI imports; camelCase fields matching the backend DTO.
- **`core/` API service.** Typed service using `HttpClient` through the shared
  interceptor. **Never** attach an `Authorization` header — auth is a
  cookie-based BFF session; echo the CSRF token in `X-CSRF-Token` on mutations;
  stamp `X-Correlation-ID` / `X-Request-ID` via the interceptor.
- **State (signals).** Feature state in signals/computed; orchestration in the
  service/facade, not the component. Zoneless change detection — callbacks
  update signals directly.
- **`features/` component.** Standalone, lazy `loadComponent`, presentation
  focused. Large tables (findings, inventory) use CDK virtual scroll over
  **server-driven** pagination/filtering.
- **Routing.** Lazy route with `requirePermission(...)`; public routes outside
  the authenticated shell.

## Required cross-cutting checks

- **Authorization is advisory only.** The backend re-checks everything; gate
  the fetch as well as the view.
- **Error → UX mapping.** `ProblemDetail`: 401 → session-expired, 403 → denied
  state, 409/422 handled in form UX with the correlation ID surfaced.
- **A11y.** Labels, keyboard navigation, focus management.
- **Loading / error / empty states** for every data surface.
- **No sensitive data in the browser.** No tokens in any browser storage;
  persist only non-sensitive UI preferences (e.g. theme).
- **No untrusted HTML**; self-hosted SVG icons only (air-gap friendly).

## Output format

1. **Slice summary** — feature area, route(s) + permission, endpoints, DTOs.
2. **Layer-by-layer plan or diff** — file path + responsibility per layer.
3. **Cross-cutting checklist** — advisory gating, error/UX mapping, a11y,
   loading/error/empty, storage hygiene, HTML safety.
4. **Contract conformance** — `domain/` field names match the backend DTO.
5. **Verification** — `npm run lint`, `npm run test:ci` (Vitest),
   `npm run build:prod`, Playwright E2E where relevant; state run vs. not run.
6. **Proposed commit message** — scope usually `ui`.
