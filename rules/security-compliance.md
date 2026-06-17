# Rule: security & compliance posture

> This describes what is implemented and what is planned. It does **not** assert
> any certification or authorization to operate. Items below marked ⚠️ require
> separate security review and are not met by implementation alone.

## Authoritative backend
- The backend re-checks **every** access decision. UI gating is an affordance.
- **Deny by default.** Protected routes depend on `require(*permissions)`;
  `ensure_permissions` grants only what a role's permission set includes. Object-
  level scoping is added per resource as resources gain owners.
- RBAC is six roles (`domain/users/role_permission_policy.py`):
  `read_only ⊆ security_analyst ⊆ security_admin ⊆ system_admin`, plus
  `asset_owner` (reads + remediation triage) and `executive` (reports only) —
  a lattice, not a chain. Project-scoped routes additionally re-check the
  caller's **membership role** for that project
  (`domain/projects/membership_policy.py`, VD-AUTH-010 🟡⚠️): non-members
  read 404, members without the verb read 403, only `system_admin` bypasses.
  Effective grant = global ∩ membership role (`ProjectContext.allows` for
  per-category routes like search). `asset_owner` members are further
  narrowed (VD-AUTH-011): triage only between remediation states and only on
  findings backed by an asset they own (fail-closed). Instance-level
  permissions are non-issuable API-key scopes, and key management + project
  create/delete refuse machine principals (`require_session_principal`).
  Projects are **hierarchical** (`parent_project_id`, VD-PROJ-009): root
  creation stays `system_admin`-only (`project:create`); child creation is
  object-gated `project:create_child` (a `security_admin` **member** of the
  parent, or `system_admin`) and is also a non-issuable key scope. Access
  **inherits down** the tree — the effective membership role is the one on the
  nearest ancestor where the caller is a direct member
  (`resolve_effective_member_role`, nearest-ancestor-wins). Machine keys do
  **not** inherit (exact-project binding, fail-closed). Deleting a project with
  children is refused (409; DB FK is `RESTRICT`).
  Staleness controls: membership-role changes bind on the next request;
  cached *global* roles last until session TTL **unless revoked** —
  `DELETE /auth/sessions/{email}` (`user:manage`, session-only, audited)
  destroys all of a user's sessions immediately, and `POST /auth/refresh`
  re-maps the caller's own roles from the IdP without re-login.

## Sessions, CSRF, transport
- BFF auth: httpOnly session cookie (Redis-backed, TTL), `Secure` outside local,
  `SameSite=Lax`. CSRF double-submit on all cookie-based mutations
  (`enforce_csrf`). The CSRF cookie is readable; the session cookie is not.
- Security headers + credentialed CORS allowlist (a wildcard origin is invalid
  with credentials). CORS is a browser protection, not an authz control.

## Secrets & credentials
- Secrets never appear in code, logs, or responses. Feed API keys are encrypted
  at rest (Fernet; key from `VULNDASH_CREDENTIAL_KEY` — the secret manager, not
  the DB), decrypted in-memory only at fetch time; secret fields are write-only
  and never serialized to the client. Implemented (BE-8); 🟡 ⚠️ — credential
  custody not yet exercised end-to-end / security-reviewed (see TRACEABILITY
  `VD-CRED-*`).

## Audit
- Sensitive state changes are recorded append-only. `triage_history` is enforced
  append-only by a DB trigger (tamper-evident). Retention enforcement is ⚠️.

## Known review items (⚠️ — do not mark "met" by code alone)
- OIDC: `id_token` validation is implemented (JWKS + rotation, asymmetric-alg
  allowlist, `iss`/`aud`/`azp`/`exp`/nonce, userinfo `sub` match, fail-closed
  without issuer/jwks_uri) plus refresh handling (`/auth/refresh` re-maps
  roles; refresh token never leaves the server-side session). ⚠️ remaining:
  not yet exercised against a real IdP.
- Credential custody (BE-8): encryption-at-rest is **implemented** (Fernet,
  env-supplied key); the remaining ⚠️ is the security review of key management /
  custody, not the feature. Audit/history retention enforcement is also ⚠️.
- Upload byte-size limits: enforced at the endpoint
  (`BodySizeLimitMiddleware`, 413); the reverse proxy must mirror the cap in
  production.

## Child of the architecture
- Local-first feed ingestion (sync into the DB; correlate against the local
  dataset) supports air-gapped operation — but air-gap suitability is **not**
  asserted by implementation alone.

If you find yourself relaxing any of the above to make a task easier, stop and
flag it rather than weakening the control.
