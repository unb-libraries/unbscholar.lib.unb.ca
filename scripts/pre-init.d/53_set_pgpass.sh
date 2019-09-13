#!/usr/bin/env bash
echo "${POSTGRES_DB_HOST}:${POSTGRES_DB_PORT}:${POSTGRES_DB_NAME}:${POSTGRES_DB_USER}:${POSTGRES_DB_PASS}" > ~/.pgpass
chmod 0600 ~/.pgpass
