#!/usr/bin/env bash
set -euo pipefail

status_file=${1:-/var/lib/embykeeper-status/status.json}
max_age_seconds=${EMBYKEEPER_STATUS_MAX_AGE_SECONDS:-172800}

python3 - "$status_file" "$max_age_seconds" <<'PY'
import json
import os
import re
import stat
import sys
import time
from datetime import datetime

path = sys.argv[1]
max_age = int(sys.argv[2])
info = os.lstat(path)
if stat.S_ISLNK(info.st_mode) or not stat.S_ISREG(info.st_mode):
    raise SystemExit("unsafe status file")
if info.st_size > 65536:
    raise SystemExit("status file exceeds 64 KiB")
if time.time() - info.st_mtime > max_age:
    raise SystemExit("status file is stale")
with open(path, "r", encoding="utf-8") as handle:
    value = json.load(handle)
expected = {
    "last_success", "next_run", "last_error",
    "enabled_profiles_count", "failed_profiles_count",
}
if set(value) != expected:
    raise SystemExit("unexpected status schema")
if any(not isinstance(value[field], str) for field in ("last_success", "next_run", "last_error")):
    raise SystemExit("invalid status strings")
if not re.fullmatch(r"[A-Z0-9_.:-]*", value["last_error"]):
    raise SystemExit("invalid error code")
for field in ("last_success", "next_run"):
    if value[field]:
        try:
            datetime.fromisoformat(value[field].replace("Z", "+00:00"))
        except ValueError as error:
            raise SystemExit("invalid timestamp") from error
if (not isinstance(value["enabled_profiles_count"], int)
        or isinstance(value["enabled_profiles_count"], bool)
        or not isinstance(value["failed_profiles_count"], int)
        or isinstance(value["failed_profiles_count"], bool)):
    raise SystemExit("invalid profile counters")
if value["enabled_profiles_count"] < 0 or value["failed_profiles_count"] < 0:
    raise SystemExit("negative profile counters")
if value["failed_profiles_count"] > value["enabled_profiles_count"]:
    raise SystemExit("failed count exceeds enabled count")
print("embykeeper_status_ok")
PY
