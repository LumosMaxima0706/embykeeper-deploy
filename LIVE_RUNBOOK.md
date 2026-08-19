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
- Follow-up: after permissions were corrected, v7.6.1 exited 0 because the disabled queue was empty. Added supported `--noexit` so the service remains available for health checks without enabling any profile.
- Result: corrected deployment is ready to re-run; no account login, Telegram session, DNS, failover, Nginx, helper, or existing service action occurred.
- Next: commit/push the template fix, refresh the isolated BWG checkout, then start the corrected stack and publish a sanitized status file.
- External help: none; real credentials remain intentionally unavailable.

### 2026-08-19 - BWG corrected runtime and status contract

- Goal: keep the disabled standalone service running and expose only a sanitized status artifact.
- Actions: pushed deployment fixes through `embykeeper-deploy` `main` commit `40359e2`; refreshed the BWG `/tmp` checkout; started `/opt/embykeeper` Compose; generated `/opt/embykeeper/status/status.json` with the atomic exporter; ran the repository healthcheck.
- Result: `embykeeper/embykeeper:v7.6.1` is `running` with restart count 0, no published ports, no host networking, and no enabled account. Status JSON has exactly five fields and reports `NO_ENABLED_PROFILES` with zero enabled/failed profiles.
- Debug: the first status command used a shell quoting form that was rejected locally; the corrected command ran successfully. The status file is a regular 0644 file and contains no URL or credential data.
- Safety: only the new `/opt/embykeeper` Compose stack was started/stopped/restarted during debugging. Existing EmbyProxy, Nginx, sidecar, publication-agent, DNS, and failover state were not changed.
- Next: validate EmbyProxy Admin/config behavior against missing, malformed, and valid status files in the isolated Linux clone; do not mount the status directory into the production EmbyProxy container without a separate rollout decision.
- External help: real Emby credentials remain required for an actual account keepalive result; no credentials are requested or stored by this delivery.

### 2026-08-19 - Real credential verification and compatibility image

- Goal: run one low-risk real Emby keepalive without Telegram or production EmbyProxy changes.
- Precheck: `/opt/embykeeper/secrets/config.toml` mode 0600, owned by UID/GID 1000; one enabled profile; required fields present; no placeholder values; Telegram not required. Values were never printed.
- Official image result: login succeeded and 192 home items were read, but the server returned HTTP 404 for the optional `Videos/{id}/AdditionalParts` probe. v7.6.1 then hit its uninitialized `streams` cleanup variable. Status was recorded as `PLAYBACK_ENDPOINT_HTTP_404`.
- Fix: built a derived image from the pinned official v7.6.1 digest. The fail-closed patch removes only the unused `AdditionalParts` probe, initializes `streams`, and redacts URL-bearing request errors. Exact source markers are checked during build; mismatched upstream source fails the build.
- Verification: compat2 one-shot `--emby --disable-color --instant --once` exited 0. Login succeeded, one video completed approximately 150 seconds, and Embykeeper reported keepalive success. Raw log scan found zero password/token matches; URL errors contained `[URL_REDACTED]` only.
- Runtime: `/opt/embykeeper/docker-compose.yml` now selects `local/embykeeper:v7.6.1-additionalparts-compat2`; container is running with restart count 0. `/opt/embykeeper/status/status.json` reports one enabled profile, zero failures, and a real `last_success` timestamp.
- Cleanup: all temporary validation raw logs, including the earlier token-bearing official-image log, were deleted. No config, cache, or account data was removed.
- Safety: only the standalone Embykeeper container was restarted. Existing EmbyProxy, Nginx, sidecar, publication-agent, DNS, and failover state were not changed.
- External help: none for the completed verification; future account changes remain operator-controlled.
