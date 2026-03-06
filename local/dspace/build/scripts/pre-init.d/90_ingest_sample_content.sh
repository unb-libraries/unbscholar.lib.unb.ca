#!/usr/bin/env sh
if [ "$DEPLOY_ENV" = "local" ]; then
  rm -rf /dspace/upload
  /scripts/ingest_sample_content.sh
fi
