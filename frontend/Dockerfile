# Front-End
FROM node:12-alpine
WORKDIR /app

ARG DSPACE_REFSPEC=dspace-7.0-beta5
ENV DSPACE_HOST 0.0.0.0

ARG DSPACE_REST_HOST=unbscholar.dspace.lib.unb.ca
ARG DSPACE_REST_NAMESPACE=/server
ARG DSPACE_REST_PORT=80
ARG DSPACE_REST_SSL=true

RUN apk --no-cache add \
    git \
    rsync && \
  git clone --depth 1 --branch ${DSPACE_REFSPEC} https://github.com/DSpace/dspace-angular.git /tmpDSpace && \
  rsync -a /tmpDSpace/ /app/ && \
  yarn install --network-timeout 300000 && \
  yarn run build:prod

COPY ./scripts /scripts
EXPOSE 4000

CMD ["/scripts/run.sh"]
