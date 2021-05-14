#!/usr/bin/env sh
sed -i "s|api7.dspace.com|${DSPACE_REST_HOST}|g" "/app/dist/server/main.js"
