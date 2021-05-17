#!/usr/bin/env sh
# Check if dspace vars are set and then test the connection.
if [[ -z "$DSPACE_REST_HOST" ]]; then
 echo 'A dspace server address has not been set in $DSPACE_REST_HOST'
 exit 1
fi

if [[ -z "$DSPACE_REST_PORT" ]]; then
 echo 'A dspace server port has not been set in $DSPACE_REST_PORT'
 exit 1
fi

# Check to see if dspace is accepting connections
nc -zw5 ${DSPACE_REST_HOST} ${DSPACE_REST_PORT}
RETVAL=$?
while [ $RETVAL -ne 0 ]
do
  nc -zw5 ${DSPACE_REST_HOST} ${DSPACE_REST_PORT}
  RETVAL=$?
  echo -e "\t Waiting for dspace server on $DSPACE_REST_HOST:$DSPACE_REST_PORT..."
  sleep 5
done
