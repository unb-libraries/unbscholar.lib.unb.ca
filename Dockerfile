# Front-End
FROM node:14-alpine as builder
WORKDIR /app

ARG BUILD_CMD='yarn run build:prod'
ARG DSPACE_REFSPEC=dspace-7.2

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

CMD ["/scripts/run.sh"]


FROM ghcr.io/unb-libraries/nginx:2.x as prod
MAINTAINER UNB Libraries <libsupport@unb.ca>

# Add built content.
ENV APP_WEBROOT /app/html/server
COPY --from=builder ./app/dist /app/html

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
