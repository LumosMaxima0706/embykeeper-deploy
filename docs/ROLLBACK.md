# Rollback

## Repository rollback

This repository is independent. Revert its local deployment commit or remove
the unpushed local clone. Do not revert or modify EmbyProxy history.

## Runtime rollback

1. Set EmbyProxy integration disabled.
2. Stop only the Embykeeper container or systemd unit.
3. Restore the previous standalone image digest and protected config/data backup.
4. Revalidate the standalone config and status file.

Do not touch EmbyProxy SQLite, Nginx fragments, edge helper, publication-agent,
DNS, or failover state. `deploy/scripts/rollback.example.sh` prints this plan
and is dry-run by default.
