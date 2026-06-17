---
name: commit-message-proposal
description: Propose a Conventional Commit message after completing a task or reviewing a set of changes.
disable-model-invocation: true
allowed-tools: Bash(git status:*), Bash(git diff:*)
---

# Commit Message Proposal Skill

Review the current change scope and propose exactly one Conventional Commit message.

## Format

```text
Proposed commit message: <type>(<scope>): <summary>
```

## Allowed types

- `feat`
- `fix`
- `docs`
- `refactor`
- `test`
- `chore`
- `build`
- `ci`
- `security`

## Common scopes

- `claude`
- `docs`
- `api`
- `ui`
- `security`
- `infra`
- `tests`
- `architecture`

Use imperative mood and keep the summary concise.
