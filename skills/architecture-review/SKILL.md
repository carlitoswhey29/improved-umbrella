---
name: architecture-review
description: Review VulnDash architecture — repository structure, Clean/Hexagonal layering, boundaries, naming, and ARCHITECTURE.md alignment.
allowed-tools: Read, Glob, Grep
---

# Architecture Review Skill

Review the requested files or repository area for architectural fitness.

## Required focus

- Directory and file placement (`backend/src/vulndash/{api,application,domain,infrastructure,config}`).
- Layering: dependencies point inward; `domain` imports no framework/ORM/transport;
  third-party runtime libs confined to single `infrastructure` modules.
- Naming clarity and explicit responsibilities; no `utils`/`helpers`/`misc`/
  vague `service` buckets.
- Ports (Protocols) at the application boundary; routers thin.
- Alignment with `docs/architecture/ARCHITECTURE.md` and
  `.claude/rules/architecture-boundaries.md`.
- `legacy/vulndash-platform/` stays frozen — flag any new code there.

Base findings only on files actually read; if a referenced doc is missing,
report that as a finding rather than assuming its content.

## Output format

1. Scope reviewed.
2. Findings by severity.
3. Recommended changes with file paths.
4. Verification steps.
5. Proposed commit message.
