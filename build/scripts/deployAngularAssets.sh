#!/usr/bin/env sh
git clone --depth 1 --branch $DSPACE_REFSPEC https://github.com/DSpace/dspace-angular.git /tmpDSpace
rsync -a /tmpDSpace/ /app/
rsync -a /build/config/angular/ /app/config/
rsync -a /build/src/ /app/src/
