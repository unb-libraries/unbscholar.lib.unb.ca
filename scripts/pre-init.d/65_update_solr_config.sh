#!/usr/bin/env sh
sed -i "s|<dataDir>.*</dataDir>|<dataDir>${SOLR_DATASTORE}/oai</dataDir>|g" /dspace/solr/oai/conf/solrconfig.xml
sed -i "s|<dataDir>.*</dataDir>|<dataDir>${SOLR_DATASTORE}/search</dataDir>|g" /dspace/solr/search/conf/solrconfig.xml
sed -i "s|<dataDir>.*</dataDir>|<dataDir>${SOLR_DATASTORE}/statistics</dataDir>|g" /dspace/solr/statistics/conf/solrconfig.xml
