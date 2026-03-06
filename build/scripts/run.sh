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
  ## Add the  -- --disable-host-check flag to the start:dev command in package.json
  ## to allow the Angular dev server to run without host checking.
  ## This is necessary for local development environments where the host may not be recognized.
  sed -i 's/\(npm run serve\)"/\1 -- --disable-host-check"/' package.json
  npm run start:dev
else
  npm run serve:ssr
fi
