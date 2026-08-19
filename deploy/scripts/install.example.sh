#!/usr/bin/env bash
set -euo pipefail

# Example only. It never downloads Embykeeper or writes credentials.
# Review this script and set an explicit target before using it on an isolated host.
root=${EMBYKEEPER_ROOT:-/opt/embykeeper}
if [[ "$root" != /opt/embykeeper && "$root" != /srv/embykeeper ]]; then
  printf 'refusing unexpected EMBYKEEPER_ROOT: %s\n' "$root" >&2
  exit 2
fi
if [[ "${EMBYKEEPER_INSTALL_APPLY:-0}" != 1 ]]; then
  printf 'dry-run: would prepare %s/secrets, %s/data, and %s/status\n' "$root" "$root" "$root"
  printf 'dry-run: copy config.example.toml manually, keep it disabled, then review the image digest\n'
  exit 0
fi
install -d -m 0700 "$root/secrets" "$root/data" "$root/status"
printf 'prepared %s; no credentials were created or copied\n' "$root"
