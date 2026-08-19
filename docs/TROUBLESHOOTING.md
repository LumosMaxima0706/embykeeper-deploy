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
