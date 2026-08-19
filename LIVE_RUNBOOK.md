# Embykeeper Deploy Live Runbook

## Boundaries

- Local repository and isolated `/opt/embykeeper` trial only.
- No production EmbyProxy, Nginx, helper, publication-agent, DNS, or failover access.
- No real Emby or Telegram login, credentials, sessions, or cache files.
- No Embykeeper source vendoring.

## Execution log

### 2026-08-19 - Repository split

- Goal: create an independent deployment repository without EmbyProxy history.
- Actions: copied only deployment templates and sanitized process documents into this local repository; added scripts, status exporter examples, and deployment/rollback/security documentation.
- Result: no runtime secrets, source code, database, Nginx, helper, or failover files copied.
- Next: run shell, Compose, JSON/schema, and secret checks; do not start a container.
- External help: none.

### 2026-08-19 - Static validation

- Goal: validate reproducible examples without account access.
- Actions: `bash -n deploy/scripts/*.sh`, Compose `config`, JSON/schema parsing, and changed-file secret scan.
- Result: record actual results in `TEST_MATRIX.md`; any unavailable tool must have a documented static substitute.
- Next: owner review, then decide whether to create a private remote.
- External help: only required for a future authenticated push.
