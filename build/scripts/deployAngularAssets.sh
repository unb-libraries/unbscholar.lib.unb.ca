#!/usr/bin/env sh
set -e
git clone --depth 1 --branch $DSPACE_REFSPEC https://github.com/DSpace/dspace-angular.git /tmpDSpace
rsync -a /tmpDSpace/ /app/
rsync -a /build/config/angular/ /app/config/
rsync -a --exclude='themes/custom' /build/src/ /app/src/

# Patch angular.json to add unbscholar theme stylesheet bundle
sed -i 's|"bundleName": "custom-theme"|"bundleName": "custom-theme" }, { "input": "src/themes/unbscholar/styles/theme.scss", "inject": false, "bundleName": "unbscholar-theme"|' /app/angular.json

# Patch angular.json to serve src/favicon.ico at URL root /favicon.ico (Chrome auto-fetches this regardless of <link rel=icon>)
sed -i 's|"src/assets",|{ "glob": "favicon.ico", "input": "src/", "output": "/" }, "src/assets",|' /app/angular.json

# Patch angular.json to serve apple-touch-icon{,-precomposed}.png at URL root (iOS/Safari auto-fetch these regardless of <link rel=apple-touch-icon>)
cp /app/src/assets/unbscholar/images/favicons/apple-touch-icon.png /app/src/assets/unbscholar/images/favicons/apple-touch-icon-precomposed.png
sed -i 's|"src/assets",|{ "glob": "apple-touch-icon*.png", "input": "src/assets/unbscholar/images/favicons/", "output": "/" }, "src/assets",|' /app/angular.json

# Patch robots.txt.ejs to add Crawl-delay to the default User-agent: * group
sed -i "/^User-agent: \*$/a Crawl-delay: ${CRAWL_DELAY}" /app/src/robots.txt.ejs
