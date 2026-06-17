---
description: Run a focused DevOps and observability review for the supplied path or topic.
allowed-tools: Read, Glob, Grep
---

Use the `devops-observability-review` skill to review: $ARGUMENTS

Focus on local-vs-production separation, secret-free Docker/Compose/CI/scripts
(`VULNDASH_*` settings only), liveness/readiness distinction, opt-in OTel, log
hygiene (IDs and metadata only), feed retry/isolation, and CI gates. Do not
describe local infrastructure as hardened production. Return findings by
severity and end with a proposed commit message.
