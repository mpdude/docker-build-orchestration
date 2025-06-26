FROM node:22 AS node_base

# Upgrade npm to the latest version
RUN npm install -g npm@latest

FROM node_base AS node_yarn

ENV HOME=/tmp
RUN yarn config set disable-self-update-check true

ENV YARN_CACHE_FOLDER=/yarn-cache
RUN mkdir -m 777 -p $YARN_CACHE_FOLDER

ENTRYPOINT ["/usr/local/bin/yarn"]
CMD ["help"]
