#!/usr/bin/env bash
set -euo pipefail

# Example exporter: callers provide already-sanitized values. It never reads
# config.toml, cache.json, Telegram sessions, or raw logs.
last_success=${STATUS_LAST_SUCCESS:-}
next_run=${STATUS_NEXT_RUN:-}
last_error=${STATUS_LAST_ERROR:-}
enabled=${STATUS_ENABLED_PROFILES_COUNT:-0}
failed=${STATUS_FAILED_PROFILES_COUNT:-0}
if [[ -n "$last_error" ]] && ! printf '%s\n' "$last_error" | grep -Eq '^[A-Z0-9_.:-]+$'; then
  printf 'invalid error code\n' >&2
  exit 2
fi
for timestamp in "$last_success" "$next_run"; do
  if [[ -n "$timestamp" ]] && ! printf '%s\n' "$timestamp" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$'; then
    printf 'invalid timestamp\n' >&2
    exit 2
  fi
done
if ! printf '%s' "$enabled:$failed" | grep -Eq '^[0-9]+:[0-9]+$'; then
  printf 'invalid profile counters\n' >&2
  exit 2
fi
if (( failed > enabled )); then
  printf 'failed count exceeds enabled count\n' >&2
  exit 2
fi
payload=$(printf '{"last_success":"%s","next_run":"%s","last_error":"%s","enabled_profiles_count":%s,"failed_profiles_count":%s}\n' \
  "$last_success" "$next_run" "$last_error" "$enabled" "$failed")
if (( $# == 0 )); then
  printf '%s' "$payload"
  exit 0
fi
if (( $# != 1 )); then
  printf 'usage: %s [absolute-status-path]\n' "$0" >&2
  exit 2
fi
output=$1
case "$output" in
  /*) ;;
  *) printf 'status path must be absolute\n' >&2; exit 2 ;;
esac
output_dir=${output%/*}
if [[ ! -d "$output_dir" ]]; then
  printf 'status directory does not exist\n' >&2
  exit 2
fi
tmp=$(mktemp "$output_dir/.status.json.XXXXXX")
trap 'rm -f "$tmp"' EXIT
printf '%s' "$payload" > "$tmp"
chmod 0644 "$tmp"
mv -f "$tmp" "$output"
trap - EXIT
