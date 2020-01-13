#!/usr/bin/env bash
# Triage the build to determine how to deploy.

# Remove old file markers to eliminate false positives
rm -rf /tmp/DSPACE_DB_LIVE
rm -rf /tmp/DSPACE_FILES_LIVE

# Check if the database has tables named *node*. If so, this is likely a live DB.
RESULT=`PGPASSFILE=/root/.pgpass psql --host ${POSTGRES_DB_HOST} --port ${POSTGRES_DB_PORT} --username ${POSTGRES_DB_USER} --dbname ${POSTGRES_DB_NAME} -lqt | cut -d \| -f 1 | grep -qw ${POSTGRES_DB_NAME}`

if [[ ! -z "$RESULT" ]]; then
  echo $RESULT
  touch /tmp/DSPACE_DB_LIVE
  echo "Triage : Found Likely Dspace Database."
fi

ASSETDIRSUBDIRS=$(find "$DSPACE_ASSETSTORE" -maxdepth 1 -type d | wc -l)
if [[ ! $ASSETDIRSUBDIRS -eq 2 ]]; then
  touch /tmp/DSPACE_FILES_LIVE
  echo "Triage : Found Likely DSpace Assetstore Data"
fi
