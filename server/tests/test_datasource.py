import src.datasource.datasource_handler as datasource
import json


def test_ingest_file_happy_path():
    json_body = json.dumps(
        {"path": "./data/test.txt", "data": "This is a test document."}
    )
    res = datasource.DataSourceHandler.ingest_file(json_body)
    assert res.success == True
    assert res.message == "Success"


def test_ingest_file_happy_path():
    url = "https://llamahub.ai/l/web-readability_web"
    path = "./"
    res = datasource.DataSourceHandler.ingest_url(
        url,
        path,
    )
    assert res.success == True
    assert res.message == "Success"
