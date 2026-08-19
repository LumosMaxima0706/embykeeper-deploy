# Risk Register

| Risk | Control | Stop condition |
|---|---|---|
| GPL-3.0 boundary | No upstream source is copied or redistributed | Any source integration requires owner/license review |
| Credential leak | Ignore config, cache, session, DB, logs, `.env`; placeholders only | Stop if a test needs a real secret |
| Account suspension/TOS | Disabled profiles, one operator-owned low-risk account, manual review | Stop on policy ambiguity or challenge |
| Telegram session exposure | Telegram disabled; no session generation | Stop if real Telegram login is requested |
| Host/network overreach | No host network, no Docker socket, no published WebUI port | Stop before adding privileged networking |
| Runtime misconfiguration | Dedicated `/opt/embykeeper`, separate user and files | Never mount EmbyProxy data or Nginx paths |
| Status disclosure | Five fields, strict schema, no raw log export | Reject unknown fields or free-form errors |
| Rollback damage | Scripts are dry-run by default and path allowlisted | Never run global cleanup |
