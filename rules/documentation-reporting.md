---
paths:
  - "docs/**"
  - "README.md"
  - "**/README.md"
---

# Rule: documentation & traceability

- `docs/TRACEABILITY.md` is the **single source of truth** for requirement/phase
  status. Update it (and the relevant `.claude/runtime/plans/*`) whenever a
  phase item lands; keep the `_Last reviewed_` date current.
- Status honesty: ✅ only when implemented **and** verified; 🟡 implemented but
  runtime-pending; ⬜ not started; ⚠️ needs security review. Never mark ✅
  because "it compiles".
- Keep requirement IDs (VD-*) stable — never renumber; mark superseded items
  rather than deleting them. New capabilities get a VD-* ID before
  implementation.
- Do not assert any certification, ATO, or air-gap suitability from
  implementation alone. Items marked ⚠️ require separate security review.
- Relative links must resolve. Docs that are planned but unwritten
  (`DIAGRAM.md`, `DATA_FLOW.md`, `BACKEND.md`, `FRONTEND.md`) are referenced as
  plain text marked "(planned)" — never as links.
- `legacy/vulndash-platform/` is documented as frozen/reference-only; its
  features are tracked via `docs/PLATFORM-MERGE.md`, not the traceability
  matrix.
- No sensitive internal URLs, credentials, or real org SBOM/vulnerability data
  in committed docs; fixture examples only.
- Mermaid diagrams: small, one concern each (data flow, trust boundary, or
  component responsibility) — prefer a table when prose enumerates better.
