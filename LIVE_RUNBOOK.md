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
- Actions: created a Git bundle, cloned it under BWG `/tmp/embykeeper-deploy-verify-20260819-02`, then ran Bash syntax checks, both Compose `config --quiet` checks, Python compilation, JSON/schema checks, exporter positive/negative tests, healthcheck, and secret scan. No container was started.
- Result: all available checks passed. The host lacked the third-party Python `jsonschema` package, so an equivalent standard-library validator loaded the tracked schema and enforced exact fields, patterns, types, and minimums.
- Debug: the first shell exporter test rejected a legal empty `last_error` because `grep` receives no line for empty input. The exporter now handles empty values explicitly and validates timestamps and counters before emitting JSON; all regression checks then passed.
- EmbyProxy cross-check: the split feature bundle was cloned under BWG `/tmp/embyproxy-embykeeper-split-verify-20260819-02`. Full `go test ./...`, `go vet ./...`, and focused Admin/config Embykeeper tests passed using the existing temporary Linux Go SDK. Windows vet was not treated as authoritative because existing Linux-only syscall uses cannot compile on Windows.
- Security: scans covered forbidden tracked paths, private-key headers, common high-entropy credential shapes, complete UUIDs, and non-placeholder Emby URLs. Both repositories reported zero findings.
- Next: owner review, then decide whether to create a private remote.
- External help: only required to select and authorize a future private remote; push remains prohibited.

### 2026-08-19 - BWG isolated runtime bring-up

- Goal: start the standalone Embykeeper process without real account or Telegram credentials.
- Baseline: `/opt/embykeeper` was absent; no Embykeeper container or systemd unit existed. Existing EmbyProxy, Nginx, sidecar, and publication-agent services were left untouched.
- Actions: pulled `embykeeper/embykeeper:v7.6.1` (digest recorded only in the host audit), rendered the Compose file, and started the dedicated stack with the disabled placeholder profile.
- Failure: the pinned image exited because the template used obsolete `--no-top`; the container restarted seven times before detection.
- Debug/fix: compared the image's `--help` output, stopped only `/opt/embykeeper` Compose, removed `--no-top` from both tracked Compose examples, and added a CLI-flag regression row to `TEST_MATRIX.md`.
- Result: corrected deployment is ready to re-run; no account login, Telegram session, DNS, failover, Nginx, helper, or existing service action occurred.
- Next: commit/push the template fix, refresh the isolated BWG checkout, then start the corrected stack and publish a sanitized status file.
- External help: none; real credentials remain intentionally unavailable.
