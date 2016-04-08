#!/bin/bash
set -eo pipefail

#verify variables
if [ -z "$S3_ACCESS_KEY" -o -z "$S3_SECRET_KEY" -o -z "$S3_URL" -o -z "$MONGO_URL" ]; then
	echo >&2 'Backup information is not complete. You need to specify S3_ACCESS_KEY, S3_SECRET_KEY, S3_URL and MONGO_URL.'
	exit 1
fi

#set S3 config
sed -i "s#%%S3_ACCESS_KEY%%#$S3_ACCESS_KEY#g" /root/.s3cfg
sed -i "s#%%S3_SECRET_KEY%%#$S3_SECRET_KEY#g" /root/.s3cfg

#verify S3 config
s3cmd ls "s3://$S3_URL" > /dev/null

# add a cron job
echo "2 * * * * root rm -rf /tmp/dump && mongodump -h $MONGO_URL -u root -p $MONGO_ROOT_PASSWORD --gzip -o /tmp/dump && s3cmd sync /tmp/dump s3://$S3_URL/ && rm -rf /tmp/dump" >> /etc/crontab
crontab /etc/crontab

exec "$@"
