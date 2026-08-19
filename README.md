# embykeeper-deploy

Standalone, low-risk deployment materials for Embykeeper. This repository does
not vendor Embykeeper source and does not share EmbyProxy's database, Nginx,
edge-helper, publication-agent, DNS, or failover configuration.

The safe baseline:

- runs only the upstream Emby/Jellyfin keepalive module (`--emby`);
- keeps the example account disabled and uses reserved placeholder hosts;
- publishes no WebUI port and does not use host networking;
- stores real `config.toml`, `cache.json`, sessions, logs, and secrets only in
  an untracked server directory such as `/opt/embykeeper/`;
- produces only a sanitized `status.json` for the optional EmbyProxy weak link.

No container is started by this repository's tests. Review site rules and use
one operator-owned low-risk account before enabling any profile.

## Layout

The top-level Compose/config files are convenient examples. The `deploy/`
directory contains the same examples plus safe shell/systemd templates. The
`examples/status-exporter/` directory documents the five-field status contract.

## Quick static validation

```bash
bash -n deploy/scripts/*.sh
docker compose -f docker-compose.example.yml config
```

These commands validate syntax only. They do not log into Emby or Telegram and
do not start a container.

See `docs/DEPLOYMENT.md`, `docs/SECURITY.md`, and `docs/ROLLBACK.md` before any
isolated trial.
