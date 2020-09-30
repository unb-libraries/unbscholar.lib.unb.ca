#!/bin/bash
set -e

for CORE in authority oai search statistics
do
  echo "Creating Core $CORE..."
  /opt/docker-solr/scripts/precreate-core $CORE "/data/cores/$CORE/conf"
done

docker-entrypoint.sh solr-foreground
