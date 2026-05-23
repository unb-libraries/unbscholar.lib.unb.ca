#!/usr/bin/env sh
# Builder/dev entrypoint; prod does not run in the build container.
# See Dockerfile for prod entrypoint
set -e

for i in /scripts/pre-init.d/*sh
do
  if [ -e "${i}" ]; then
    SCRIPT_NAME=$(basename $i)
    START_TIME=$(date +%s)
    echo "[i] pre-init.d - $SCRIPT_NAME..."
    "${i}"
    FINISH_TIME=$(date +%s)
    STARTUP_TIME=$((FINISH_TIME - START_TIME))
    echo "${SCRIPT_NAME}|${STARTUP_TIME}" >> /tmp/deploy_step_times
  fi
done

if [ "$DEPLOY_ENV" = "local" ]; then
  npm run start:dev
else
  npm run serve:ssr
fi
