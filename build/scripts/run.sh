#!/usr/bin/env sh
for i in /scripts/pre-init.d/*sh
do
  if [ -e "${i}" ]; then
    SCRIPT_NAME=$(basename $i)
    START_TIME=$(date +%s)
    echo "[i] pre-init.d - $SCRIPT_NAME..."
    "${i}"
    FINISH_TIME=$(date +%s)
    STARTUP_TIME=$(expr $FINISH_TIME - $START_TIME)
    echo "${SCRIPT_NAME}|${STARTUP_TIME}" >> /tmp/deploy_step_times
  fi
done

if [ "$DEPLOY_ENV" = "local" ]; then
  yarn start:dev
else
  yarn run serve:ssr
fi
