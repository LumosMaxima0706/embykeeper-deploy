#!/usr/bin/env bash
set -euo pipefail

# Example only. It prints a rollback plan and never removes data by default.
root=${EMBYKEEPER_ROOT:-/opt/embykeeper}
if [[ "$root" != /opt/embykeeper && "$root" != /srv/embykeeper ]]; then
  printf 'refusing unexpected EMBYKEEPER_ROOT: %s\n' "$root" >&2
  exit 2
fi
printf 'rollback plan for %s:\n' "$root"
printf '1. disable EMBYKEEPER_INTEGRATION_ENABLED in EmbyProxy\n'
printf '2. stop only the standalone Embykeeper unit/container\n'
printf '3. restore the previously recorded image/config backup\n'
printf '4. do not touch EmbyProxy SQLite, Nginx, helper, publication, DNS, or failover files\n'
if [[ "${EMBYKEEPER_ROLLBACK_APPLY:-0}" != 1 ]]; then
  printf 'dry-run only; set EMBYKEEPER_ROLLBACK_APPLY=1 only after owner review\n'
  exit 0
fi
printf 'apply mode intentionally requires a site-specific operator procedure\n' >&2
exit 3
