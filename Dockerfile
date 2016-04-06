FROM debian:wheezy

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		numactl \
	&& rm -rf /var/lib/apt/lists/*

ENV GPG_KEYS \
	DFFA3DCF326E302C4787673A01C4E7FAAAB2461C \
	42F3E95A2C4F08279C4960ADD68FA50FEA312927
RUN set -ex \
	&& for key in $GPG_KEYS; do \
		apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

ENV MONGO_MAJOR 3.2
ENV MONGO_VERSION 3.2.4

RUN echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/$MONGO_MAJOR main" > /etc/apt/sources.list.d/mongodb-org.list

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
		mongodb-org=$MONGO_VERSION \
		mongodb-org-shell=$MONGO_VERSION \
		mongodb-org-tools=$MONGO_VERSION \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mongodb \
	&& mv /etc/mongod.conf /etc/mongod.conf.orig

# entrypoint
COPY entrypoint.sh /entrypoint.sh

# backups
# install s3cmd and cron
RUN apt-get update && apt-get install -y s3cmd && apt-get install -y cron && rm -rf /var/lib/apt/lists/*
COPY s3cfg /root/.s3cfg

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron", "-f"]