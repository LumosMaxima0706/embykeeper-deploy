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
the profile disabled. The Compose UID is `1000:1000`; ensure the mounted data
directory and config file are readable by that UID (the install example applies
the ownership when present). Review the upstream image tag and digest. Validate with:

```bash
docker compose -f docker-compose.example.yml config
```

The baseline uses `--emby`, `--disable-color`, and `--noexit`, no host network,
no published port, and no Docker socket. `--noexit` keeps a disabled/no-account
instance available for health checks instead of exiting successfully after its
empty task queue completes. The command intentionally avoids flags that are
not present in every pinned upstream image release. Starting a container is an
owner-approved isolated trial, not part of repository tests.

## Runtime commands

From `/opt/embykeeper`:

```bash
docker compose up -d
docker compose ps
docker compose logs --tail=100 embykeeper
docker compose restart embykeeper
docker compose stop embykeeper
```

Validate before and after a change:

```bash
docker compose config --quiet
bash /path/to/healthcheck.example.sh /opt/embykeeper/status/status.json
```

The Compose service uses `restart: unless-stopped`, so Docker starts it after
host boot when the Docker daemon is enabled. This is not a systemd unit; do
not install both supervisors for the same instance.

## systemd alternative

Use `deploy/systemd/embykeeper.service.example` with a dedicated unprivileged
user and `/var/lib/embykeeper`. Install a pinned upstream package into a
dedicated virtualenv. Run `systemd-analyze verify` before any enable/start.

## EmbyProxy weak integration

Only configure EmbyProxy with an HTTPS external URL and an absolute sanitized
`status.json` path. EmbyProxy never reads the standalone config, cache, logs, or
session. New EmbyProxy servers are not automatically enrolled.

When weak integration is intentionally enabled, expose only the `status/`
directory to the EmbyProxy process and set `EMBYKEEPER_STATUS_FILE` to the
absolute `status.json` path. Do not mount `secrets/` or `data/` into EmbyProxy.
