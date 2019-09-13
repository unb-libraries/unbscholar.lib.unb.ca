#!/usr/bin/env bash
# Check if MySQL vars are set and then test the connection.

# Check if MySQL env vars exist.
if [ -z "$POSTGRES_DB_HOST" ]; then
 echo 'A postgres server IP address has not been set in $POSTGRES_DB_HOST'
 exit 1
fi

if [ -z "$POSTGRES_DB_PORT" ]; then
 echo 'A postgres server port has not been set in $POSTGRES_DB_PORT'
 exit 1
fi

# Check to see if MySQL is accepting connections
nc -zw10 ${POSTGRES_DB_HOST} ${POSTGRES_DB_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw10 ${POSTGRES_DB_HOST} ${POSTGRES_DB_PORT}
  RETVAL=$?
  echo "Waiting for postgres server on $POSTGRES_DB_HOST:$POSTGRES_DB_PORT..."
  sleep 10
done
