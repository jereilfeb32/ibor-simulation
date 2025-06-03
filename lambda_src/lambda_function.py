import json
import logging
import os
import boto3
import random
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

S3_BUCKET = os.environ.get('S3_BUCKET')
API_ENDPOINT = os.environ.get('API_ENDPOINT')
HEADERS = json.loads(os.environ.get('API_HEADERS', '{}'))

s3_client = boto3.client('s3')

CURRENCIES = ["USD", "EUR", "CHF"]

def generate_large_payload():
    record_count = random.randint(100_000, 200_000)
    logger.info(f"Generating {record_count} records.")

    data = []

    for i in range(1, record_count + 1):
        price = round(random.uniform(100, 300_000), 2)
        currency = random.choice(CURRENCIES)
        record = {
            "ID": f"ABBN-{i:05d}",
            "Name": f"ABB {i:05d}",
            "ISIN": "CH0012221716",
            "Start Date": None,
            "End Date": None,
            "Price": price,
            "Currency": currency,
            "Amount Type ID": "Piece",
            "Value Method ID": "UnitPrice",
            "Accrual Type ID": "None",
            "Unbundle Method ID": "None",
            "Genericity ID": "None",
            "Position Currency Method ID": "Any",
            "Position Cycle ID": "Implicit",
            "Price Store ID": "Fi",
            "Accrual Store ID": "None",
            "Delta Store ID": "None",
            "Symbol": f"ABBN-{i:05d}"
        }
        data.append(record)

    return {
        "timestamp": datetime.utcnow().isoformat(),
        "records": data
    }

def lambda_handler(event, context):
    logger.info("Lambda triggered with event: %s", json.dumps(event))

    payload = generate_large_payload()
    logger.info("Payload generated with %d records", len(payload["records"]))

    filename = f"pricing_update_{datetime.utcnow().strftime('%Y%m%dT%H%M%S')}.json"

    if not S3_BUCKET:
        logger.warning("S3_BUCKET environment variable not set. Skipping S3 upload.")
    else:
        try:
            logger.info("Uploading to S3 bucket: %s, key: %s", S3_BUCKET, filename)
            s3_client.put_object(
                Bucket=S3_BUCKET,
                Key=filename,
                Body=json.dumps(payload),
                ContentType='application/json'
            )
            logger.info("Upload successful: %s", filename)
        except Exception as e:
            logger.error("S3 upload failed: %s", str(e))
            raise

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Pricing data generated and stored.',
            'record_count': len(payload["records"]),
            's3_key': filename
        })
    }
