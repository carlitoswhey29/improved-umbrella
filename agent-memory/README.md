# Agent Memory Policy

Persistent subagent memory is not enabled by default for this project.

If enabled later:

1. Define which subagent may use memory and its scope (`project`, `user`, or
   `local`).
2. Never store: secrets, tokens, feed API keys, real org SBOM contents,
   internal hostnames, or session identifiers. Public CVE/advisory data and
   repo facts are fine.
3. Review generated memory files before committing any project-scoped memory.
