#!/usr/bin/env bash
set -euo pipefail

root=${EMBYKEEPER_ROOT:-/opt/embykeeper}
if [[ "$root" != /opt/embykeeper && "$root" != /srv/embykeeper ]]; then
  printf 'refusing unexpected EMBYKEEPER_ROOT: %s\n' "$root" >&2
  exit 2
fi
test -f examples/status.example.json
test -f config.example.toml
test -f deploy/docker-compose.example.yml
printf 'repository examples present; no runtime files inspected\n'
