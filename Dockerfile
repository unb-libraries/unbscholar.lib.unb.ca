# Front-End
FROM node:14-alpine
WORKDIR /app

ARG BUILD_CMD=yarn run build:prod
ARG DSPACE_REFSPEC=dspace-7.2

COPY build /build
RUN apk --no-cache add \
    git \
    postfix \
    rsync \
    util-linux && \
  mv /build/scripts /scripts && \
  cat /build/config/postfix/main.cf >> /etc/postfix/main.cf && \
  postfix start && \
  git clone --depth 1 --branch ${DSPACE_REFSPEC} https://github.com/DSpace/dspace-angular.git /tmpDSpace && \
  rsync -a /build/config/angular/ /app/config/ && \
  rsync -a /tmpDSpace/ /app/ && \
  /scripts/rsyncSrc.sh && \
  yarn install --network-timeout 300000

RUN $BUILD_CMD

EXPOSE 4000

CMD ["/scripts/run.sh"]

# Metadata
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
