#!/bin/bash
set -eo pipefail

if [ -z "$S3_ACCESS_KEY" -a -z "$S3_SECRET_KEY" -a -z "$S3_BUCKET_DIR" ]; then
        echo >&2 'Login information is not complete. You need to specify S3_ACCESS_KEY, S3_SECRET_KEY, S3_BUCKET_DIR.'
        exit 1
fi

s3cmd ls "s3://ackee-backups/$S3_BUCKET_DIR" > /dev/null
