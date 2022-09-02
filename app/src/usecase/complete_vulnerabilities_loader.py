import time
import orjson

import boto3
import requests
from requests import HTTPError

from src.infrastructure.logger import logger
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

RESULTS_PER_PAGE = 2000
endpoint_url = 'http://localhost:8000'
dynamo_table = boto3 \
    .resource('dynamodb', endpoint_url=endpoint_url) \
    .Table('NistVulnerabilities')
RESULTS_PER_PAGE = 2000


def load():
    result = get_vulnerabilities(start_index=0)

    total_results = result['totalResults']
    logger.info(f'Total number of vulnerabilities: {total_results}')

    save_on_database(result)

    for index in range(RESULTS_PER_PAGE + 1, total_results, RESULTS_PER_PAGE):
        time.sleep(1)
        result = get_vulnerabilities(index)
        save_on_database(result)


@retry(
    retry=retry_if_exception_type(HTTPError),
    stop=stop_after_attempt(5),
    wait=wait_exponential(min=6, multiplier=1.5),
)
def get_vulnerabilities(start_index):
    logger.info(f'Requesting NIST with startIndex = {start_index}')
    response = requests.get(
            'https://services.nvd.nist.gov/rest/json/cves/1.0/',
            params={
                'resultsPerPage': RESULTS_PER_PAGE,
                'startIndex': start_index,
            },
        )
    logger.info(f'Request finished')

    if response.status_code > 400:
        raise response.raise_for_status()
    
    return response.json()


def save_on_database(result):
    logger.info('Saving on database')
    cve_items = result['result']['CVE_Items']
    chunks = [cve_items[line:line+15] for line in range(0, len(cve_items), 15)]

    for vulnerabilities in chunks:
        with dynamo_table.batch_writer() as batch:
            for vulnerability in vulnerabilities:
                batch.put_item(
                    Item={
                        'CveId': vulnerability['cve']['CVE_data_meta']['ID'],
                        'Severity': get_severity(vulnerability),
                        'Object': orjson.loads(orjson.dumps(vulnerability))
                    })
    logger.info('Saving finished')


def get_severity(vulnerability):
    impact = vulnerability['impact']
    metric_v3 = impact.get('baseMetricV3')
    if metric_v3 is not None:
        return metric_v3['cvssV3']['baseSeverity']
    else:
        return 'NONE'
