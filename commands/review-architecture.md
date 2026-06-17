---
description: Run a focused architecture review for the supplied path or topic.
allowed-tools: Read, Glob, Grep
---

Use the `architecture-review` skill to review: $ARGUMENTS

Check Clean/Hexagonal layering (dependencies point inward; third-party libs
confined to infrastructure), naming, placement, alignment with
`docs/architecture/ARCHITECTURE.md`, and that `legacy/vulndash-platform/`
stays frozen. Return findings by severity and end with a proposed commit
message.
