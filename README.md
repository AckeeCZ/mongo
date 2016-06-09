# Mongo container with persistent volume fixes for IBM Bluemix 

The main goal is to inherit from the official [Mongo](https://github.com/docker-library/mongo) image.

This image can act as a standalone mongo server or as a node of mongo HA cluster, depending on ENV variables. Authentication is enabled during the setup and default `root` and `myUserAdmin` accounts are created.

Following ENV variables must be specified:
 - `MONGO_ROOT_PASSWORD` password of user `root` who has access to all dbs
 - `WT_CACHE` size of WiredTiger cache. Set to 60% of allocated RAM of the constainer - 1 GB. This is needed to specify, as containers don't know their RAM size.

Following ENV variables are optional, if set (both) the image acts as a node of a cluster:
 - `REPL_SET_NAME` specifies replica set (name of the cluster)
 - `CLUSTER_KEY` is a shared key that use single nodes of the cluster to authenticate to each other (keep it long)
