from datetime import datetime
import os

import boto3


localstack_endpoint = 'http://localhost:4566'
ssm = boto3.client('ssm', endpoint_url=localstack_endpoint)


def save_run_time():
    ssm.put_parameter(
        Name='/securityManager/vulnerabilities/loader/lastRunTime',
        Value=get_current_time_formatted(),
        Overwrite=True,
    )


def get_last_run_time():
    response = ssm.get_parameter(
        Name='/securityManager/vulnerabilities/loader/lastRunTime',
    )
    return response['Parameter']['Value']


def get_current_time_formatted():
    now = datetime.utcnow()
    return now.strftime('%Y-%m-%dT%H:%M:%S:000 UTC')
