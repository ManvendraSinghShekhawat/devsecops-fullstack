#!/usr/bin/env python3
"""
mysqldump -> gzip -> S3 upload

Requirements:
 - mysqldump available on host
 - AWS credentials via instance role or environment
"""

import os
import subprocess
import datetime
import boto3
from botocore.exceptions import ClientError

DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '3306')
DB_USER = os.getenv('DB_USER', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD', '')
DB_NAME = os.getenv('DB_NAME', 'appdb')
S3_BUCKET = os.getenv('S3_BUCKET', '<S3_BUCKET_NAME>')
REGION = os.getenv('AWS_REGION', 'eu-west-1')

def run_dump():
    ts = datetime.datetime.utcnow().strftime('%Y%m%dT%H%M%SZ')
    filename = f"{DB_NAME}-{ts}.sql"
    gzipfile = filename + ".gz"
    # Basic mysqldump call - for production use use safer credential handling
    dump_cmd = f"mysqldump -h {DB_HOST} -P {DB_PORT} -u {DB_USER} --password='{DB_PASSWORD}' {DB_NAME} > {filename}"
    ret = subprocess.call(dump_cmd, shell=True)
    if ret != 0:
        raise SystemExit("mysqldump failed")
    subprocess.check_call(f"gzip -f {filename}", shell=True)
    return gzipfile

def upload_s3(gzipfile):
    s3 = boto3.client('s3', region_name=REGION)
    try:
        s3.upload_file(gzipfile, S3_BUCKET, gzipfile, ExtraArgs={'ServerSideEncryption':'AES256'})
        print(f"Uploaded {gzipfile} to s3://{S3_BUCKET}")
    except ClientError as e:
        print("Upload failed:", e)
        raise
    finally:
        os.remove(gzipfile)

def main():
    gzipfile = run_dump()
    upload_s3(gzipfile)

if __name__ == "__main__":
    main()

