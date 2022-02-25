# ================
# build stage 
# ================
FROM alpine:latest AS buildstage

ARG FOSSIL_VERSION=2.18
ARG FOSSIL_URL=https://fossil-scm.org/home/tarball/version-${FOSSIL_VERSION}/fossil-${FOSSIL_VERSION}.tar.gz
WORKDIR /build

RUN apk add --update --no-cache alpine-sdk build-base tcl-dev tk openssl-dev && \ 
wget ${FOSSIL_URL} && \ 
tar zxvf fossil-${FOSSIL_VERSION}.tar.gz && \ 
cd /build/fossil-${FOSSIL_VERSION} && \ 
./configure --with-th1-docs --with-th1-hooks --json && \ 
make && \ 
strip fossil && \ 
make install

# ================
# production stage 
# ================

FROM alpine:latest AS production

# Dockerfile parameters
ENV FOSSIL=/usr/local/bin/fossil
ENV RUNSERVER=/usr/local/bin/runserver.sh
ENV REPO_PATH=/data/repos
ENV BACKUP_PATH=/data/backup
ENV SCRIPT_PATH=/data/script

#ENV REPO_NAME=fossil.fossil
#ENV REPO=${REPO_PATH}/${REPO_NAME}

ENV PORT=8181

# Fossil parameters - do not change
ENV HTTPS_PROXY_PARAM=--https
ENV MULTI_REPO_PARAM=--repolist

# Configurable parameter
ENV START_PAGE=
ENV HTTPS_PROXY=
ENV MULTI_REPO=
ENV SINGLE_REPO=1

COPY --from=buildstage /usr/local/bin/fossil ${FOSSIL}

COPY runserver.sh ${RUNSERVER}

RUN mkdir -p ${REPO_PATH} \
    && mkdir -p ${BACKUP_PATH} \
    && mkdir -p ${SCRIPT_PATH} \
    && addgroup -Sg 400 fossil \
    && adduser -Su 400 -G fossil fossil \
    && chown -R fossil:fossil /data \
    && chown fossil:fossil ${FOSSIL} \
    && chmod a+x ${FOSSIL} \
    && chown fossil:fossil ${RUNSERVER} \
    && chmod a+x ${RUNSERVER}

WORKDIR ${REPO_PATH}

EXPOSE ${PORT}

USER fossil
CMD ["/usr/local/bin/runserver.sh"]
