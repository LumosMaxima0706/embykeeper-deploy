# Troubleshooting

## Login or 2FA

Stop the profile and review site policy. Never paste credentials, one-time
codes, sessions, or cache content into logs or tickets.

## Cache or data errors

Check ownership and mode of the dedicated data directory. `cache.json` is
sensitive and must not be copied into EmbyProxy or Git.

## Network errors

Check outbound DNS/TLS from the ordinary container network and the standalone
config. Do not switch to host networking as a first fix.

## Web console unavailable

Expected in the safe baseline: no WebUI password, no published port, and no
direct Internet exposure. Configure an independently secured console only after
owner review.

## Status unavailable

Check that the configured EmbyProxy path is an absolute regular `status.json`
file, below the size limit, atomically written, and contains exactly the five
allowed fields. Missing/malformed status must remain unavailable, not become a
500 or disclose raw content.

## Login succeeds but playback fails on AdditionalParts

Some Emby-compatible servers return 404 for the optional
`/Videos/{id}/AdditionalParts` endpoint. Embykeeper v7.6.1 treats that unused
probe as fatal and its one-shot cleanup path can then reference an uninitialized
`streams` variable. Confirm this exact failure with sanitized logs before using
the compatibility image; do not apply it to a different upstream version.

Build the fail-closed derived image from the pinned official digest:

```bash
bash deploy/scripts/build-compat-image.example.sh
```

Set `EMBYKEEPER_IMAGE=local/embykeeper:v7.6.1-additionalparts-compat1` only in
the server-side runtime environment, render Compose, and rerun one account with
`--emby --instant --once`. The patch removes only the unused optional probe,
initializes the cleanup variable, and replaces URL-bearing request errors with
`[URL_REDACTED]`. It does not alter login credentials, media selection,
playback duration, or EmbyProxy.
