#!/usr/bin/env python3
"""Emit only the five-field sanitized EmbyProxy status contract."""
import json
import os
import re

error = os.environ.get("STATUS_LAST_ERROR", "")
if not re.fullmatch(r"[A-Z0-9_.:-]*", error):
    raise SystemExit("invalid error code")
timestamps = [
    os.environ.get("STATUS_LAST_SUCCESS", ""),
    os.environ.get("STATUS_NEXT_RUN", ""),
]
timestamp_pattern = re.compile(
    r"(?:[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}"
    r"(?:\.[0-9]+)?(?:Z|[+-][0-9]{2}:[0-9]{2}))?"
)
if any(not timestamp_pattern.fullmatch(timestamp) for timestamp in timestamps):
    raise SystemExit("invalid timestamp")
value = {
    "last_success": timestamps[0],
    "next_run": timestamps[1],
    "last_error": error,
    "enabled_profiles_count": int(os.environ.get("STATUS_ENABLED_PROFILES_COUNT", "0")),
    "failed_profiles_count": int(os.environ.get("STATUS_FAILED_PROFILES_COUNT", "0")),
}
if value["enabled_profiles_count"] < 0 or value["failed_profiles_count"] < 0:
    raise SystemExit("profile counts must be non-negative")
if value["failed_profiles_count"] > value["enabled_profiles_count"]:
    raise SystemExit("failed count exceeds enabled count")
print(json.dumps(value, separators=(",", ":")))
