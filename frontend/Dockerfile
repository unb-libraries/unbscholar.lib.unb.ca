# Front-End
FROM node:12-alpine
WORKDIR /app

ARG DSPACE_REFSPEC=dspace-7.0-beta5

ENV DSPACE_HOST 0.0.0.0

COPY ./build/patches /patches

RUN apk --no-cache add \
    git \
    rsync && \
  git clone --depth 1 --branch ${DSPACE_REFSPEC} https://github.com/DSpace/dspace-angular.git /tmpDSpace && \
  cd /tmpDSpace && \
  git apply /patches/add-disablehostcheck.patch && \
  rsync -a /tmpDSpace/ /app/

EXPOSE 4000

# We run yarn install with an increased network timeout (5min) to avoid "ESOCKETTIMEDOUT" errors from hub.docker.com
# See, for example https://github.com/yarnpkg/yarn/issues/5540
RUN yarn install --network-timeout 300000
CMD yarn run start:dev
