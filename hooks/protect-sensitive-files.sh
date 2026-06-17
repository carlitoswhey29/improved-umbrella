#!/usr/bin/env bash
# Blocks Claude from editing/writing secret and credential files. Wired from
# .claude/settings.json PreToolUse (matcher: Edit|Write). Read-side protection
# is handled by the native permissions deny list in settings.json.
#
# Matching is deliberately split:
#   - "always" patterns are unambiguous and match anywhere in the path.
#   - "name token" patterns (secret/token/credential) match only when they look
#     like a real secret artifact (dotfile, *.secret/.secrets, or a *secret*
#     env/key-style file), NOT when they are ordinary source identifiers such
#     as `session-token.model.ts` or `csrf_token_service.py`.
#   - `*.example` files (e.g. .env.example) are never blocked.
set -euo pipefail

PY="$(command -v python3 || command -v python || true)"
if [[ -z "$PY" ]]; then exit 0; fi

INPUT="$(cat)"
FILE_PATH="$("$PY" -c 'import json,sys; d=json.load(sys.stdin); ti=d.get("tool_input",{}); print(ti.get("file_path") or ti.get("path") or "")' <<< "$INPUT" 2>/dev/null || true)"

if [[ -z "${FILE_PATH}" ]]; then
  exit 0
fi

lower_path="$(printf '%s' "$FILE_PATH" | tr '[:upper:]' '[:lower:]' | tr '\\' '/')"
base="${lower_path##*/}"

# Sample/template files are safe by definition.
case "$base" in
  *.example|*.sample|*.template) exit 0 ;;
esac

block() {
  echo "Blocked: '$FILE_PATH' $1 Do not edit secrets, credentials, or key material." >&2
  exit 2
}

# 1) Unambiguous, always-blocked path substrings.
always_patterns=(
  "/.secrets/"
  "/secrets/"
  "private-key"
  "id_rsa"
  "id_ed25519"
)
for pattern in "${always_patterns[@]}"; do
  if [[ "$lower_path" == *"$pattern"* ]]; then
    block "matches protected pattern '$pattern'."
  fi
done

# 2) Secret-bearing filenames/extensions (anchored to the basename).
case "$base" in
  .env|.env.*) block "is an environment secrets file." ;;
  *.pem|*.key|*.p12|*.pfx) block "is key material." ;;
  .*secret*|.*token*|.*credential*) block "looks like a sensitive dotfile." ;;
  *.secret|*.secrets|*.cred|*.creds|*.credential|*.credentials|*.token) block "has a secret-bearing extension." ;;
  *secret*.env|*secret*.json|*secret*.yaml|*secret*.yml|*secret*.txt|*secret*.cfg|*secret*.ini) block "looks like a secrets config file." ;;
  *credential*.env|*credential*.json|*credential*.yaml|*credential*.yml|*credential*.txt|*credential*.cfg|*credential*.ini) block "looks like a credentials config file." ;;
esac

exit 0
