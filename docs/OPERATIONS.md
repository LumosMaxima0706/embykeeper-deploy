# Operations

## Daily operation

Inspect only the standalone service logs and sanitized status file. Treat a
running container as process health, not proof that a profile succeeded.

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

## Removal

Disable the EmbyProxy link, stop/remove only the standalone unit/container, then
archive or securely remove the exact `/opt/embykeeper` directory after review.
