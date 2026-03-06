#!/usr/bin/env sh
set -e

# Check if postgres env vars exist.
if [ -z "$POSTGRES_DB_HOST" ]; then
 echo 'A postgres server address has not been set in $POSTGRES_DB_HOST.'
 exit 1
fi

if [ -z "$POSTGRES_DB_PORT" ]; then
 echo 'A postgres server port has not been set in $POSTGRES_DB_PORT.'
 exit 1
fi

# Check to see if postgres is accepting connections.
nc -zw5 ${POSTGRES_DB_HOST} ${POSTGRES_DB_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw5 ${POSTGRES_DB_HOST} ${POSTGRES_DB_PORT}
  RETVAL=$?
  echo -e "\t Waiting for postgres server on $POSTGRES_DB_HOST:$POSTGRES_DB_PORT..."
  sleep 5
done

# Check if solr env vars exist.
if [ -z "$SOLR_HOST" ]; then
 echo 'A solr server address has not been set in $SOLR_HOST.'
 exit 1
fi

if [ -z "$SOLR_PORT" ]; then
 echo 'A solr server port has not been set in $SOLR_PORT.'
 exit 1
fi

# Check to see if solr is accepting connections.
nc -zw5 ${SOLR_HOST} ${SOLR_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw5 ${SOLR_HOST} ${SOLR_PORT}
  RETVAL=$?
  echo -e "\t Waiting for solr server on $SOLR_HOST:$SOLR_PORT..."
  sleep 5
done
