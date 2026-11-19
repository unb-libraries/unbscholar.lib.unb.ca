#!/usr/bin/env sh
# Overrides the parent image script of the same name to also wait for solr.
# Block until postgres and solr accept TCP connections.
set -e

wait_for() {
  name=$1 host=$2 port=$3
  if [ -z "$host" ] || [ -z "$port" ]; then
    echo "A $name host/port has not been set." >&2
    exit 1
  fi
  until nc -zw5 "$host" "$port"; do
    printf '\t Waiting for %s on %s:%s...\n' "$name" "$host" "$port"
    sleep 5
  done
}

wait_for postgres "$POSTGRES_DB_HOST" "$POSTGRES_DB_PORT"
wait_for solr "$SOLR_HOST" "$SOLR_PORT"
