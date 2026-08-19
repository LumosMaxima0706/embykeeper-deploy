# Operations

## Daily operation

Inspect only the standalone service logs and sanitized status file. Treat a
running container as process health, not proof that a profile succeeded.

For the isolated Compose deployment, use `docker compose ps` and
`docker compose logs --tail=100 embykeeper`. A healthy no-account baseline
reports that no Emby keepalive task is enabled; it must not be reported as a
successful account login.

## Updates

Review upstream release notes and digest, back up only standalone config/data,
validate the candidate in isolation, then retain the previous image/digest for
rollback. Do not use unattended image update tooling in the baseline.

## Status contract

Write `status.json` atomically with:

- `last_success`
- `next_run`
- `last_error`
- `enabled_profiles_count`
- `failed_profiles_count`

Counts are non-negative; failed cannot exceed enabled. Unknown fields and raw
error text are invalid.

The example exporter prints JSON by default. To atomically replace a status
file, pass an absolute output path:

```bash
STATUS_LAST_ERROR=NO_ENABLED_PROFILES \
STATUS_ENABLED_PROFILES_COUNT=0 \
STATUS_FAILED_PROFILES_COUNT=0 \
bash examples/status-exporter/status-exporter.example.sh \
  /opt/embykeeper/status/status.json
```

The destination directory must already exist. The exporter never reads
`config.toml`, `cache.json`, sessions, or raw logs.

## Removal

Disable the EmbyProxy link, stop/remove only the standalone unit/container, then
archive or securely remove the exact `/opt/embykeeper` directory after review.
