# Plan

## Objective

Maintain a standalone, non-vendored Embykeeper deployment repository with
placeholder configuration, safe scripts, a sanitized status contract, and
reproducible rollback documentation.

## Phases

1. Repository boundary and license notice.
2. Compose/config/systemd examples.
3. Safe install, validate, rollback, and status-exporter examples.
4. Deployment, security, operations, troubleshooting, and rollback docs.
5. Static validation and secret scan.
6. Local commit only; no push until owner chooses a private remote.

## Acceptance

- No Embykeeper source, EmbyProxy source, database, Nginx, helper, failover, or production files.
- All values are placeholders; runtime secrets are ignored.
- Scripts pass shell syntax checks.
- Compose config renders without starting a container.
- Status schema and exporters expose only five allowlisted fields.
- Rollback is scoped to standalone files and services.

## Rollback

Delete only this unpushed local repository or revert its local commit. A future
runtime rollback stops/restores only `/opt/embykeeper`; it never rolls back
EmbyProxy data-plane state.
