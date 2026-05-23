#!/usr/bin/env sh
# Overlay local config + src onto cloned upstream /app.
set -e

rsync -a /build/config/angular/ /app/config/
rsync -a --exclude='themes/custom' /build/src/ /app/src/
