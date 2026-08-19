#!/usr/bin/env bash
set -euo pipefail

image=${EMBYKEEPER_COMPAT_IMAGE:-local/embykeeper:v7.6.1-additionalparts-compat1}
docker build \
  --file deploy/docker/Dockerfile.v7.6.1-compat \
  --tag "$image" \
  .
docker run --rm "$image" --version
docker run --rm "$image" --help | grep -q -- '--emby'
printf 'compat image ready: %s\n' "$image"
