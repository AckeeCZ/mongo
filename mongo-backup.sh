#!/bin/bash
set -eo pipefail

if [ -z "$S3_ACCESS_KEY" -a -z "$S3_SECRET_KEY" -a -z "$S3_BUCKET_DIR" ]; then
	echo >&2 'Backup inforamtion is not complete. You need to specify S3_ACCESS_KEY, S3_SECRET_KEY, S3_BUCKET_DIR. No backups, no fun.'
	exit 1
fi

sed -i "s/%%S3_ACCESS_KEY%%/$S3_ACCESS_KEY/g" /root/.s3cfg
sed -i "s/%%S3_SECRET_KEY%%/$S3_SECRET_KEY/g" /root/.s3cfg

# export ENV variables for crontab
echo "S3_ACCESS_KEY=$S3_ACCESS_KEY" >> /etc/crontab
echo "S3_SECRET_KEY=$S3_SECRET_KEY" >> /etc/crontab
echo "S3_BUCKET_DIR=$S3_BUCKET_DIR" >> /etc/crontab
echo "MONGO_ROOT_PASSWORD=$MONGO_ROOT_PASSWORD" >> /etc/crontab

# add cron job
#echo -e '0 2 * * * root rm -rf /tmp/dump && mongodump -u root -p $MONGO_ROOT_PASSWORD --gzip -o /tmp/dump && s3cmd sync /tmp/dump s3://ackee-backups/$S3_BUCKET_DIR/ && rm -rf /tmp/dump' >> /etc/crontab
crontab /etc/crontab

#start cron
cron -f &
