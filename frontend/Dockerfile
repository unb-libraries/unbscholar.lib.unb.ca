# Front-End
FROM node:12-alpine
WORKDIR /app

ARG DSPACE_REFSPEC=dspace-7.0-beta5
ENV DSPACE_HOST 0.0.0.0

RUN apk --no-cache add \
    git \
    rsync && \
  git clone --depth 1 --branch ${DSPACE_REFSPEC} https://github.com/DSpace/dspace-angular.git /tmpDSpace && \
  rsync -a /tmpDSpace/ /app/ && \
  yarn install --network-timeout 300000 && \
  yarn run build:prod

EXPOSE 4000

CMD yarn run serve:ssr
