---
name: documentation-update
description: Update or review VulnDash documentation — README, ARCHITECTURE, TRACEABILITY, runtime plans, and diagrams — keeping status honest and links resolving.
allowed-tools: Read, Glob, Grep, Edit, Write
---

# Documentation Update Skill

Use this when documentation must be updated after design, implementation, or
review changes. Follow `.claude/rules/documentation-reporting.md`.

## Required checks

- Does `README.md` / `backend/README.md` reflect current setup and commands?
- Does `docs/architecture/ARCHITECTURE.md` reflect current structure,
  components, data stores, and security posture?
- Is `docs/TRACEABILITY.md` updated with honest status marks (✅ only when
  verified) and a current review date? VD-* IDs stable?
- Do all relative links resolve? Planned-but-unwritten docs referenced as
  plain text "(planned)", never links.
- Are examples sanitized (fixture SBOMs/vulns only)?
- Are certification/ATO/air-gap claims absent, with ⚠️ items still marked?
- Is `legacy/vulndash-platform/` described as frozen/reference-only?

## Output format

- Docs changed.
- Why changed.
- Remaining documentation gaps.
- Verification performed (e.g. link check).
- Proposed commit message.
