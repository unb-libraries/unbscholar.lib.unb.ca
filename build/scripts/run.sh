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

sed -i "s|ng serve --configuration|ng serve --host $DSPACE_UI_HOST --port $DSPACE_UI_PORT --configuration|g" ./package.json
yarn start:dev
