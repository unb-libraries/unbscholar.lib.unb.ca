FROM solr:8.4
MAINTAINER UNB Libraries <libsupport@unb.ca>

LABEL ca.unb.lib.generator="solr" \
  com.microscaling.docker.dockerfile="/Dockerfile" \
  com.microscaling.license="MIT" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.description="unbscholar.solr.lib.unb.ca is the solr application serving drupal instances at UNB Libraries." \
  org.label-schema.name="unbscholar.solr.lib.unb.ca" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/unb-libraries/unbscholar.solr.lib.unb.ca" \
  org.label-schema.vendor="University of New Brunswick Libraries" \
  org.label-schema.version=$VERSION \
  org.opencontainers.image.source="https://github.com/unb-libraries/unbscholar.solr.lib.unb.ca"

ENV TZ America/Moncton
COPY ./scripts /scripts

ENTRYPOINT ["/scripts/run.sh"]
