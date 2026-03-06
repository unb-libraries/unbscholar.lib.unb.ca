#!/usr/bin/env sh
set -e
npm install @popperjs/core@^2.11.8
npm install
npm run merge-i18n -- -s src/themes/unbscholar/assets/i18n
$BUILD_CMD
