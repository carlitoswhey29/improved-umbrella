---
description: Generate a test plan for the supplied change, path, feature, or bug.
allowed-tools: Read, Glob, Grep
---

Use the `test-plan-generation` skill for: $ARGUMENTS

Separate offline unit coverage (domain/use cases with fakes) from
runtime-verification coverage (endpoints, migrations, Postgres, Redis, OIDC),
and include security negatives (401/403/CSRF/422/409). End with a proposed
commit message.
