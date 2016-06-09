FROM mongo:latest

# Create fake chown so docker scripts won't fail on Bluemix (ugly hack ignored)
#RUN mv /bin/chown /bin/chown.disabled && echo '#!/bin/bash' > /bin/chown && echo '/bin/chown.disabled "$@"' >> /bin/chown && echo 'exit 0' >> /bin/chown && chmod +x /bin/chown

# overwrite origin entrypoint
COPY ackee-entrypoint.sh /ackee-entrypoint.sh
COPY setup_mongo.sh /opt/02-setup-mongo.sh
RUN mv /entrypoint.sh /opt/03-mongo-entrypoint.sh && mv /ackee-entrypoint.sh /entrypoint.sh
