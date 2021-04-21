# Step 1 - Run Maven Build
FROM dspace/dspace-dependencies:dspace-7_x as build
ARG DSPACE_REFSPEC=dspace-7.0-beta5
ARG TARGET_DIR=dspace-installer
WORKDIR /app

# The dspace-install directory will be written to /install
RUN mkdir /install \
    && chown -Rv dspace: /install \
    && chown -Rv dspace: /app

# Copy the DSpace source code into the workdir (excluding .dockerignore contents)
RUN apt-get update && \
  apt-get install \
    git \
    rsync

RUN git clone --depth 1 --branch ${DSPACE_REFSPEC} https://github.com/DSpace/DSpace.git /tmpDSpace

USER dspace
RUN rsync -a /tmpDSpace/ /app/
COPY --chown=dspace ./config/local.cfg /app/local.cfg

# Build DSpace (note: this build doesn't include the optional, deprecated "dspace-rest" webapp)
# Copy the dspace-install directory to /install.  Clean up the build to keep the docker image small
RUN mvn package && \
  mv /app/dspace/target/${TARGET_DIR}/* /install && \
  mvn clean


# Step 2 - Run Ant Deploy
FROM tomcat:8-jdk11
ARG TARGET_DIR=dspace-installer
COPY --from=build /install /dspace-src
WORKDIR /dspace-src

# Create the initial install deployment using ANT
ENV ANT_VERSION 1.10.7
ENV ANT_HOME /tmp/ant-$ANT_VERSION
ENV PATH $ANT_HOME/bin:$PATH

RUN mkdir $ANT_HOME && \
    wget -qO- "https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C $ANT_HOME


ENV DSPACE_INSTALL=/dspace

COPY ./config/local.cfg $DSPACE_INSTALL/config/local.cfg
COPY ./scripts /scripts

RUN apt-get update && apt-get --yes install netcat && \
  # ln -s $DSPACE_INSTALL/webapps/server   /usr/local/tomcat/webapps/server
  ln -s $DSPACE_INSTALL/webapps/server /usr/local/tomcat/webapps/ROOT

EXPOSE 8080 8009
ENV JAVA_OPTS=-Xmx4096m

ENTRYPOINT ["/scripts/run.sh"]
