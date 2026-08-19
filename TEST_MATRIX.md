# Test Matrix

| Area | Command | Expected | Actual | Status |
|---|---|---|---|---|
| Shell | `bash -n deploy/scripts/*.sh` | Exit 0 | Pending | Pending |
| Compose | `docker compose -f docker-compose.example.yml config` | Exit 0, no start | Pending | Pending |
| JSON | Parse `examples/status.example.json` | Valid object | Pending | Pending |
| Schema | Validate status example against `status.schema.json` | Five fields only | Pending | Pending |
| Exporters | Run shell/Python examples with placeholder env | Valid five-field JSON | Pending | Pending |
| Secret scan | Names and content | Zero findings | Pending | Pending |
| Source boundary | Search for Embykeeper source/EmbyProxy runtime files | None | Pending | Pending |
| Production boundary | Execution log | No production action | Pending | Pending |
