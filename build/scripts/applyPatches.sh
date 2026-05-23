#!/usr/bin/env sh
set -e

# Source overlay patches (JS/TS). --fuzz=0 makes upstream drift fail loud.
patch -p1 --fuzz=0 -d /app < /build/patches/server-response-headers-sent.patch
patch -p1 --fuzz=0 -d /app < /build/patches/dspace-rest-response-self-link-warn.patch

# angular.json edits live in patchAngularJson.js (with structural asserts).
node /scripts/patchAngularJson.js

# iOS Safari fetches both names; provide -precomposed as a duplicate.
cp /app/src/assets/unbscholar/images/favicons/apple-touch-icon.png \
   /app/src/assets/unbscholar/images/favicons/apple-touch-icon-precomposed.png

# robots.txt.ejs: append Crawl-delay under the default User-agent: * group.
sed -i '/^User-agent: \*$/a Crawl-delay: 10' /app/src/robots.txt.ejs
grep -q '^Crawl-delay: 10$' /app/src/robots.txt.ejs
