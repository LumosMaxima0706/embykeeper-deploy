#!/usr/bin/env bash
set -euo pipefail

# Example exporter: callers provide already-sanitized values. It never reads
# config.toml, cache.json, Telegram sessions, or raw logs.
last_success=${STATUS_LAST_SUCCESS:-}
next_run=${STATUS_NEXT_RUN:-}
last_error=${STATUS_LAST_ERROR:-}
enabled=${STATUS_ENABLED_PROFILES_COUNT:-0}
failed=${STATUS_FAILED_PROFILES_COUNT:-0}
if ! printf '%s' "$last_error" | grep -Eq '^[A-Z0-9_.:-]*$'; then
  printf 'invalid error code\n' >&2
  exit 2
fi
case "$enabled:$failed" in
  *[!0-9:]*|:*|*:|'') printf 'invalid profile counters\n' >&2; exit 2 ;;
esac
if (( failed > enabled )); then
  printf 'failed count exceeds enabled count\n' >&2
  exit 2
fi
printf '{"last_success":"%s","next_run":"%s","last_error":"%s","enabled_profiles_count":%s,"failed_profiles_count":%s}\n' \
  "$last_success" "$next_run" "$last_error" "$enabled" "$failed"
