ARG NODE_VERSION=12.22

FROM node:$NODE_VERSION

RUN mkdir -p /opt/app/node

ENV TERM=xterm APP=/opt/app NODE=/opt/app/node

# add more arguments from CI to the image so that `$ env` should reveal more info
ARG CI_BUILD_ID
ARG CI_BUILD_REF
ARG CI_REGISTRY_IMAGE
ARG CI_BUILD_TIME
ARG NODE_ENV=production

ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
    CI_BUILD_TIME=$CI_BUILD_TIME \
    npm_config_tmp=/tmp NODE_PATH=$NODE/src NODE_ENV=$NODE_ENV

WORKDIR $NODE

ADD package.json $NODE/

RUN yarn install && yarn cache clean && npm cache clean --force

ADD . $NODE

CMD ["yarn", "run", "app"]