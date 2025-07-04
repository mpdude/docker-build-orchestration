FROM node:22 AS node_base

# Upgrade npm to the latest version
RUN npm install -g npm@latest

FROM node_base AS node_yarn

ENV HOME=/tmp
RUN yarn config set disable-self-update-check true

ENTRYPOINT ["/usr/local/bin/yarn"]
CMD ["help"]
