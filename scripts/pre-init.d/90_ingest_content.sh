#!/usr/bin/env sh
if [ "$DEPLOY_ENV" == "local" ]; then
  AIPZIP='https://github.com/DSpace-Labs/AIP-Files/raw/main/dogAndReport.zip'
  AIPDIR='/tmp/aip-dir'

  rm -rf ${AIPDIR}
  mkdir ${AIPDIR} /dspace/upload
  cd ${AIPDIR}
  pwd
  curl ${AIPZIP} -L -s --output aip.zip
  unzip aip.zip
  cd ${AIPDIR}
  /dspace/bin/dspace packager -r -a -t AIP -e "${DSPACE_ADMIN_EMAIL}" -f -u SITE*.zip
  /dspace/bin/dspace database update-sequences
  touch /dspace/solr/search/conf/reindex.flag
  /dspace/bin/dspace oai import
  /dspace/bin/dspace oai clean-cache
fi
