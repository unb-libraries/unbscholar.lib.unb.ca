FROM node:20-alpine AS builder

ARG DSPACE_REFSPEC=dspace-9.2
ARG BUILD_CMD='npm run build:prod'

WORKDIR /app

# Layers below are ordered by invalidation frequency
RUN apk --no-cache add git patch rsync util-linux

RUN git clone --depth 1 --branch "$DSPACE_REFSPEC" \
      https://github.com/DSpace/dspace-angular.git /app

# Lockfile-deterministic install; @popperjs/core comes in via bootstrap peer dep.
RUN npm ci --no-audit --no-fund

COPY build /build
RUN mv /build/scripts /scripts \
 && /scripts/applyOverlays.sh \
 && /scripts/applyPatches.sh \
 && npm run merge-i18n -- -s src/themes/unbscholar/assets/i18n \
 && sh -c "$BUILD_CMD"

ENV NODE_OPTIONS="--max_old_space_size=4096"
EXPOSE 4000
ENTRYPOINT ["/scripts/run.sh"]
# This builder is also the local-dev image (via compose). Dev vs prod can drift
# because they serve content with different daemons; watch for prod-only bugs.


FROM node:20-alpine AS prod

WORKDIR /app

COPY --from=builder ./app/dist /app/dist
COPY --from=builder ./app/config/config.example.yml /app/config/config.yml
COPY ./build/config/angular/config.prod.yml /app/config/config.prod.yml
RUN touch /app/dist/browser/assets/config.json && chown node:node /app/dist/browser/assets/config.json
USER node

ENV NODE_OPTIONS="--max_old_space_size=4096"
# Optional SSR-only internal REST URL; read at runtime by dspace-angular.
ENV DSPACE_REST_SSRBASEURL=""

EXPOSE 4000
ENTRYPOINT ["/usr/local/bin/node"]
CMD ["dist/server/main"]

# Container metadata.
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL ca.unb.lib.generator="angular" \
  com.microscaling.docker.dockerfile="/Dockerfile" \
  com.microscaling.license="MIT" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.description="unbscholar.lib.unb.ca is an institutional repository initiative of UNB Libraries intended to collect, preserve, showcase, and promote the open access scholarly output of the UNB community." \
  org.label-schema.name="unbscholar.lib.unb.ca" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/unb-libraries/unbscholar.lib.unb.ca" \
  org.label-schema.vendor="University of New Brunswick Libraries" \
  org.label-schema.version=$VERSION \
  org.opencontainers.image.authors="libsupport@unb.ca" \
  org.opencontainers.image.source="https://github.com/unb-libraries/unbscholar.lib.unb.ca"
