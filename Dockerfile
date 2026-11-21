FROM ghcr.io/unb-libraries/node:24.x AS builder

ARG DSPACE_REFSPEC=dspace-10.1
ARG BUILD_CMD='npm run build:prod'

WORKDIR /app

# Base image pre-creates /app/log, so clone elsewhere and merge in.
RUN git clone --depth 1 --branch "$DSPACE_REFSPEC" \
      https://github.com/DSpace/dspace-angular.git /tmp/dspace-angular \
 && cp -a /tmp/dspace-angular/. /app/ \
 && rm -rf /tmp/dspace-angular

# Use the npm upstream pins (packageManager); Alpine npm 11 rejects its peer deps.
# Lockfile-deterministic install; @popperjs/core comes in via bootstrap peer dep.
# Separate RUNs: sh hashes /usr/bin/npm, so a chained npm ci would still use 11.
RUN npm install -g --no-audit --no-fund \
      "$(node -p "require('./package.json').packageManager")"
RUN npm ci --no-audit --no-fund

COPY build /build
# Merge into the base image /scripts (run.sh, pre-init.d) rather than replace it.
RUN cp -a /build/scripts/. /scripts/ \
 && /scripts/applyOverlays.sh \
 && /scripts/applyPatches.sh \
 && npm run merge-i18n -- -s src/themes/unbscholar/assets/i18n \
 && sh -c "$BUILD_CMD"

ENV NODE_OPTIONS="--max_old_space_size=4096"
# Run by the base image /scripts/run.sh after pre-init.d; local overrides in env/angular.env.
ENV APP_STARTUP_CMD="npm run serve:ssr"
EXPOSE 4000
# This builder is also the local-dev image (via compose). Dev vs prod can drift
# because they serve content with different daemons; watch for prod-only bugs.


FROM ghcr.io/unb-libraries/node:24.x AS prod

# Alpine nodejs package ships no unprivileged user; match the official image uid/gid.
RUN addgroup -g 1000 node \
 && adduser -u 1000 -G node -s /bin/sh -D node

WORKDIR /app

COPY --from=builder --chown=node:node ./app/dist /app/dist
COPY --from=builder --chown=node:node ./app/config/config.example.yml /app/config/config.yml
COPY --chown=node:node ./build/config/angular/config.prod.yml /app/config/config.prod.yml
USER node
RUN touch /app/dist/browser/assets/config.json

ENV NODE_OPTIONS="--max_old_space_size=4096"
# Optional SSR-only internal REST URL; read at runtime by dspace-angular.
ENV DSPACE_REST_SSRBASEURL=""

EXPOSE 4000
ENTRYPOINT ["/usr/bin/node"]
CMD ["dist/server/main"]

# Container metadata.
ARG BUILD_DATE=unknown
ARG VCS_REF=unknown
ARG VERSION=unknown
LABEL ca.unb.lib.generator="angular" \
  org.opencontainers.image.title="unbscholar.lib.unb.ca" \
  org.opencontainers.image.description="unbscholar.lib.unb.ca is an institutional repository initiative of UNB Libraries intended to collect, preserve, showcase, and promote the open access scholarly output of the UNB community." \
  org.opencontainers.image.vendor="University of New Brunswick Libraries" \
  org.opencontainers.image.authors="UNB Libraries <libsupport@unb.ca>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.url="https://unbscholar.lib.unb.ca" \
  org.opencontainers.image.source="https://github.com/unb-libraries/unbscholar.lib.unb.ca" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$VCS_REF" \
  org.opencontainers.image.created="$BUILD_DATE"
