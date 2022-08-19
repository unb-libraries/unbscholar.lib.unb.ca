#!/usr/bin/env sh
rsync -a /build/src/themes/ /app/src/themes/
rsync -a /build/src/assets/fonts/ /app/src/assets/fonts/
rsync -a /build/src/assets/images/ /app/src/assets/images/
rsync -a /build/src/assets/i18n/ /app/src/assets/i18n/
