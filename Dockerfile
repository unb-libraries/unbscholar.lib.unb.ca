FROM node:14-alpine as builder
MAINTAINER UNB Libraries <libsupport@unb.ca>

ARG BUILD_CMD='yarn run build:prod'
ARG DSPACE_REFSPEC=dspace-7.4

WORKDIR /app

COPY build /build
RUN apk --no-cache add \
    git \
    postfix \
    rsync \
    util-linux && \
  mv /build/scripts /scripts && \
  /scripts/startPostfix.sh && \
  /scripts/deployAngularAssets.sh && \
  /scripts/buildAngularApp.sh

EXPOSE 4000
ENTRYPOINT ["/scripts/run.sh"]


FROM node:14-alpine as prod
MAINTAINER UNB Libraries <libsupport@unb.ca>

WORKDIR /app

# Assemble application and config.
COPY --from=builder ./app/dist /app/dist
COPY --from=builder ./app/config/config.example.yml /app/config/config.yml
COPY ./build/config/angular/config.prod.yml /app/config/config.prod.yml
RUN touch /app/dist/browser/assets/config.json && chown node:node /app/dist/browser/assets/config.json
USER node

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
  org.opencontainers.image.source="https://github.com/unb-libraries/unbscholar.lib.unb.ca"
