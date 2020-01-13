FROM maven:3-jdk-8-alpine as maven

ENV DSPACE_VERSION 6.3
ENV MAVEN_OPTS "-Djava.awt.headless=true"

RUN apk --no-cache add git && \
  curl -OL https://github.com/DSpace/DSpace/releases/download/dspace-${DSPACE_VERSION}/dspace-${DSPACE_VERSION}-src-release.tar.gz && \
  tar xvzpf dspace-${DSPACE_VERSION}-src-release.tar.gz && \
  mv dspace-${DSPACE_VERSION}-src-release dspace-src && \
  cd dspace-src && \
  mvn $MAVEN_OPTS package


FROM tomcat:8-jre8 as ant

ARG TARGET_DIR=dspace-installer

COPY --from=maven /dspace-src/dspace/target/dspace-installer /dspace-src
WORKDIR /dspace-src

# Create the initial install deployment using ANT
ENV ANT_VERSION 1.10.7
ENV ANT_HOME /tmp/ant-$ANT_VERSION
ENV PATH $ANT_HOME/bin:$PATH

RUN mkdir $ANT_HOME && \
    wget -qO- "https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C $ANT_HOME

RUN ant init_installation update_configs update_code update_webapps update_solr_indexes


FROM tomcat:8-jre8

ENV DEPLOY_ENV prod
ENV DSPACE_ASSETSTORE /assetstore
ENV DSPACE_INSTALL /dspace
ENV DSPACE_ROOT_WEBAPP xmlui
ENV JAVA_OPTS -Xmx2000m
ENV SOLR_DATASTORE /solrdata

ENV DSPACE_BIN $DSPACE_INSTALL/bin/dspace
ENV DSPACE_LOCAL_CONF $DSPACE_INSTALL/config/local.cfg

COPY --from=ant /dspace $DSPACE_INSTALL
COPY ./scripts /scripts
COPY ./config /config

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y --no-install-recommends \
    cron \
    postgresql-client \
    netcat \
    gpg && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  cp /config/local.cfg $DSPACE_LOCAL_CONF && \
  cp -R $DSPACE_INSTALL/webapps/solr $CATALINA_HOME/webapps* && \
  sed -i "s|DSPACE_INSTALL|${DSPACE_INSTALL}|g" /scripts/dspace.cron && cp /scripts/dspace.cron /etc/cron.d/dspace

EXPOSE 8080 8009

VOLUME $DSPACE_ASSETSTORE
VOLUME $SOLR_DATASTORE

ENTRYPOINT ["/scripts/run.sh"]
