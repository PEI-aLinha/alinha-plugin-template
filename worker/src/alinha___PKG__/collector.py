"""Collector for the __NAME__ provider.

Receives an `evidence.collect` job (contracts/jobs/evidence-collect.v1.schema.json),
reads the client's source in read-only mode and returns raw evidence.
Conversion into canonical Evidence is done by the plugin's Kotlin part (adapter).
"""
from typing import Any

PROVIDER_ID = "__ID__"


def collect(job: dict[str, Any]) -> dict[str, Any]:
    if job.get("provider") != PROVIDER_ID:
        raise ValueError(f"job for another provider: {job.get('provider')}")
    # TODO: fetch credentials from OpenBao using job["connectionRef"] and collect.
    return {"jobId": job["jobId"], "provider": PROVIDER_ID, "items": []}
