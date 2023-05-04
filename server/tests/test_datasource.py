import src.datasource as datasource
import json

def test_ingest_file_happy_path():
    json_body = json.dumps({
        "path": "./data/test.txt",
        "data": "This is a test document."
    })
    res = datasource.DataSourceHandler.ingest_file(json_body)
    assert res.success == True
    assert res.message == "Success"