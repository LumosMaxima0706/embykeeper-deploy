#!/usr/bin/env python3
"""Emit only the five-field sanitized EmbyProxy status contract."""
import json
import os
import re

error = os.environ.get("STATUS_LAST_ERROR", "")
if not re.fullmatch(r"[A-Z0-9_.:-]*", error):
    raise SystemExit("invalid error code")
value = {
    "last_success": os.environ.get("STATUS_LAST_SUCCESS", ""),
    "next_run": os.environ.get("STATUS_NEXT_RUN", ""),
    "last_error": error,
    "enabled_profiles_count": int(os.environ.get("STATUS_ENABLED_PROFILES_COUNT", "0")),
    "failed_profiles_count": int(os.environ.get("STATUS_FAILED_PROFILES_COUNT", "0")),
}
if value["enabled_profiles_count"] < 0 or value["failed_profiles_count"] < 0:
    raise SystemExit("profile counts must be non-negative")
if value["failed_profiles_count"] > value["enabled_profiles_count"]:
    raise SystemExit("failed count exceeds enabled count")
print(json.dumps(value, separators=(",", ":")))
