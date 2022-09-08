#!/usr/bin/env sh
yarn install --network-timeout 300000
yarn merge-i18n -s src/themes/custom/assets/i18n
$BUILD_CMD
