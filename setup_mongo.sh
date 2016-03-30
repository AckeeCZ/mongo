#!/bin/bash

if [ ! -f /data/db/.mongodb_password_set ]; then
  mongod &
  
  USER=${MONGO_ROOT_USER:-"root"}
  PASS=${MONGO_ROOT_PASSWORD:-"toor"}
  
  RET=1
  while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
  done
  
  mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:['root']});"
  mongo admin --eval "db.createUser({user: 'myUserAdmin', pwd: '$PASS', roles:['userAdminAnyDatabase']});"
  
  touch /data/db/.mongodb_password_set
  
  mongo admin -u ${USER} -p ${PASS} --eval "db.shutdownServer()"

  RET=0
  while [[ RET -eq 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service shutdown"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
  done
 
fi

# create a wrapper to run the mongo daemon with security enabled
mv -f /usr/bin/mongod /usr/bin/mongod.orig


if [ -n "$KEY_FILE" -a -n "$REPL_SET" ]; then
# HA cluster
    echo "deploying cluster $REPL_SET"
    echo "$REPL_SET" > /mongodb-keyfile
    chmod 600 /mongodb-keyfile
echo -e "#!/bin/bash" > /usr/bin/mongod
echo -e "exec /usr/bin/mongod.orig --auth --keyFile /mongodb-keyfile --replSet \"$REPL_SET\"" >> /usr/bin/mongod
    chmod +x /usr/bin/mongod
else
# single instance
    cat >/usr/bin/mongod <<EOF
#!/bin/bash
exec /usr/bin/mongod.orig --auth
EOF
    chmod +x /usr/bin/mongod
fi
