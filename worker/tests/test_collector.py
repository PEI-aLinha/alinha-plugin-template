from alinha___PKG__.collector import PROVIDER_ID, collect


def test_collect_returns_empty_result():
    result = collect({"jobId": "1", "provider": PROVIDER_ID})
    assert result["items"] == []
