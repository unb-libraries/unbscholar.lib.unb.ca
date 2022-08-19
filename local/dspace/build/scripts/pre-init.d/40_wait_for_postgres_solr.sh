#!/usr/bin/env sh
POSTGRES_DB_HOST='unbscholar-postgres-lib-unb-ca'
POSTGRES_DB_PORT='5432'

# Check to see if postgres is accepting connections...
nc -zw5 ${POSTGRES_DB_HOST} ${POSTGRES_DB_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw5 ${POSTGRES_DB_HOST} ${POSTGRES_DB_PORT}
  RETVAL=$?
  echo -e "\t Waiting for postgres server on $POSTGRES_DB_HOST:$POSTGRES_DB_PORT..."
  sleep 5
done


SOLR_DB_HOST='unbscholar-solr-lib-unb-ca'
SOLR_DB_PORT='8983'

# Check to see if solr is accepting connections...
nc -zw5 ${SOLR_DB_HOST} ${SOLR_DB_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw5 ${SOLR_DB_HOST} ${SOLR_DB_PORT}
  RETVAL=$?
  echo -e "\t Waiting for solr server on $SOLR_DB_HOST:$SOLR_DB_PORT..."
  sleep 5
done
