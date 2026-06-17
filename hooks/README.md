# Claude Code Hooks

One hook is wired from `.claude/settings.json`:

| Script | Trigger | Purpose |
|---|---|---|
| `protect-sensitive-files.sh` | `PreToolUse` on `Edit\|Write` | Blocks edits/writes to secret and credential files (`.env`, key material, `*secret*`/`*credential*` artifacts). `*.example` templates are exempt. Matching is anchored so ordinary source files like `session-token.model.ts` are not blocked. |

Read-side protection is intentionally **not** a hook: the native permissions
deny list in `settings.json` blocks reads of `.env`, `secrets/`, and key files
without spawning a process per tool call (faster, same guarantee).

The script needs Bash and Python (3.x, `python3` or `python`) on PATH. Make it
executable once:

```bash
chmod +x .claude/hooks/*.sh
```

Keep deny patterns anchored to real secret artifacts — broad globs like
`**/*token*` break legitimate source and `node_modules` (see
`rules/devops-observability.md`, sandbox note).
