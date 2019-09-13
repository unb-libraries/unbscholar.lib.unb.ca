#!/usr/bin/env bash
# Check if this is a new deployment. If so, install.
if [[ ! -f /tmp/DSPACE_DB_LIVE ]];
then
  echo "Deploying example databse config file..."
  cp ${DSPACE_INSTALL}/config/local.cfg.EXAMPLE  ${DSPACE_INSTALL}/config/local.cfg
fi
