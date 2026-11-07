"""Collector do provider __NAME__.

Recebe um job `evidence.collect` (contracts/jobs/evidence-collect.v1.schema.json),
lê a fonte do cliente em modo só-leitura e devolve evidência em bruto.
A conversão para Evidence canónica é feita pela parte Kotlin do plugin (adaptador).
"""
from typing import Any

PROVIDER_ID = "__ID__"


def collect(job: dict[str, Any]) -> dict[str, Any]:
    if job.get("provider") != PROVIDER_ID:
        raise ValueError(f"job para outro provider: {job.get('provider')}")
    # TODO: obter credenciais no OpenBao a partir de job["connectionRef"] e recolher.
    return {"jobId": job["jobId"], "provider": PROVIDER_ID, "items": []}
