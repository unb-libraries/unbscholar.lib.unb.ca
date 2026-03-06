#!/usr/bin/env sh
set -e
rsync -a --exclude='custom' /build/src/themes/ /app/src/themes/
rsync -a /build/src/assets/unbscholar/ /app/src/assets/unbscholar/
