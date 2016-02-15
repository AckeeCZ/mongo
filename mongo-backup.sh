#!/bin/bash
set -eo pipefail

if [ -z "$S3_ACCESS_KEY" -a -z "$S3_SECRET_KEY" -a -z "$S3_BUCKET_DIR" ]; then
	echo >&2 'Backup inforamtion is not complete. You need to specify S3_ACCESS_KEY, S3_SECRET_KEY, S3_BUCKET_DIR. No backups, no fun.'
	exit 1
fi

sed -i "s/%%S3_ACCESS_KEY%%/$S3_ACCESS_KEY/g" /root/.s3cfg
sed -i "s/%%S3_SECRET_KEY%%/$S3_SECRET_KEY/g" /root/.s3cfg

# add cron job
echo '0 2 * * * root rm -rf /tmp/dump && mongodump -u root -p $MONGO_ROOT_PASSWORD --gzip -o /tmp/dump && s3cmd sync /tmp/dump s3://ackee-backups/$S3_BUCKET_DIR/' >> /etc/crontab
