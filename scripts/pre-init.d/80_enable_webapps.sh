#!/usr/bin/env bash

# Enable (xmlui) webapp.
rm -rf $CATALINA_HOME/webapps/ROOT
ln -s $DSPACE_INSTALL/webapps/${DSPACE_ROOT_WEBAPP} $CATALINA_HOME/webapps/ROOT
