# Test Matrix

| Area | Command | Expected | Actual | Status |
|---|---|---|---|---|
| Shell | `bash -n deploy/scripts/*.sh examples/status-exporter/*.sh` | Exit 0 | Exit 0 on BWG `/tmp` clone | Pass |
| Compose | `docker compose -f docker-compose.example.yml config --quiet` and deploy copy | Exit 0, no start | Both exit 0; no `up` executed | Pass |
| Image CLI | `docker run --rm embykeeper/embykeeper:v7.6.1 --help` and rendered command review | Every configured flag accepted by pinned image | Initial `--no-top` failed; removed from both templates; `--help` confirms `--emby` and `--disable-color` | Pass |
| Python | `python3 -m py_compile` for exporter | Exit 0 | Exit 0 | Pass |
| JSON | Parse `examples/status.example.json` | Valid object | Parsed with Python standard library | Pass |
| Schema | Load schema; enforce required/additional/type/minimum/pattern rules | Five exact fields | Pass; third-party `jsonschema` unavailable, equivalent standard-library assertions used | Pass |
| Exporters | Run shell/Python examples with placeholder env | Valid five-field JSON | Both valid; invalid error code and failed-count overflow rejected | Pass |
| Health | Healthcheck against status example | Sanitized status accepted | `embykeeper_status_ok` | Pass |
| Secret scan | Tracked names plus private-key/token/UUID/real-URL shapes | Zero findings | 25 files; every category 0 | Pass |
| Source boundary | Search file inventory and upstream import/package markers | None | No upstream source or EmbyProxy runtime files | Pass |
| Production boundary | Review commands and paths | No production action | Only local paths and BWG `/tmp`; no service command | Pass |
