# Deployment

## Isolated host layout

Use a dedicated account and directory:

```text
/opt/embykeeper/
  docker-compose.yml       # untracked local copy
  config.toml              # mode 0600, untracked
  secrets/                 # mode 0700
  data/                    # cache.json stays here
  status/                  # sanitized status.json only
```

Copy `docker-compose.example.yml` to the runtime directory only after review.
Copy `config.example.toml` to the untracked secrets/config location and keep
the profile disabled. Review the upstream image tag and digest. Validate with:

```bash
docker compose -f docker-compose.example.yml config
```

The baseline uses `--emby`, no host network, no published port, and no Docker
socket. Starting a container is an owner-approved isolated trial, not part of
repository tests.

## systemd alternative

Use `deploy/systemd/embykeeper.service.example` with a dedicated unprivileged
user and `/var/lib/embykeeper`. Install a pinned upstream package into a
dedicated virtualenv. Run `systemd-analyze verify` before any enable/start.

## EmbyProxy weak integration

Only configure EmbyProxy with an HTTPS external URL and an absolute sanitized
`status.json` path. EmbyProxy never reads the standalone config, cache, logs, or
session. New EmbyProxy servers are not automatically enrolled.
