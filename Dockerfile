FROM mongo:latest

# Create fake chown so docker scripts won't fail (ugly)
RUN mv /bin/chown /bin/chown.disabled && echo '#!/bin/bash' > /bin/chown && echo '/bin/chown.disabled "$@"' >> /bin/chown && echo 'exit 0' >> /bin/chown && chmod +x /bin/chown

# multiple entrypoints
COPY ackee-entrypoint.sh /ackee-entrypoint.sh
COPY setup_mongo.sh /opt/02-setup-mongo.sh
RUN mv /entrypoint.sh /opt/03-docker-entrypoint.sh && mv /ackee-entrypoint.sh /entrypoint.sh

# switch mongodb user to root
RUN sed -i '8,12s/^/#/' /opt/03-docker-entrypoint.sh

# backups
# install s3cmd
RUN apt-get update && apt-get install -y s3cmd && rm -rf /var/lib/apt/lists/*
COPY s3cfg /root/.s3cfg
COPY mongo-backup.sh /opt/01-mongo-backup.sh
COPY s3-login-validation.sh /opt/04-s3-login-validation.sh
