---
description: Review and update project documentation for the supplied implementation or design change.
allowed-tools: Read, Glob, Grep, Edit, Write
---

Use the `documentation-update` skill for: $ARGUMENTS

Check `README.md`, `backend/README.md`, `docs/architecture/ARCHITECTURE.md`,
`docs/TRACEABILITY.md` (honest status marks, current review date), and the
relevant `.claude/runtime/plans/*`. Verify relative links resolve and planned
docs are marked "(planned)" rather than linked. Keep examples sanitized. End
with a proposed commit message.
