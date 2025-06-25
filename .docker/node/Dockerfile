FROM node:22 AS node_base

FROM node_base AS node_yarn

#ENV YARN_CACHE_FOLDER=/yarn-cache
#RUN mkdir -m 777 -p $YARN_CACHE_FOLDER

ENTRYPOINT ["/usr/local/bin/yarn"]
CMD ["help"]
