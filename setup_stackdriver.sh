#!/bin/bash

curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
sudo bash install-monitoring-agent.sh

#/opt/stackdriver/stack-config --write-gcm
cd /opt/stackdriver/collectd/etc/collectd.d/ 
curl -O https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/collectd.d/mongodb.conf
pass=$(pwgen 10 1)
sed -i 's/#User "STATS_USER"/User "stackdriver"/g' mongodb.conf
sed -i 's/#Password "STATS_PASS"/Password "'$pass'"/g' mongodb.conf

cat << EOF > /tmp/createuser
db.createUser(
   {
     user: "stackdriver",
     pwd: "$pass",
     roles: [ { role: "clusterMonitor", db: "admin" } ]
   }
)
EOF
mongo admin -u root -p $MONGO_ROOT_PASSWORD < /tmp/createuser
rm /tmp/createuser
service stackdriver-agent restart