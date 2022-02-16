# ================
# build stage 
# ================
FROM alpine:latest AS buildstage

ARG FOSSIL_VERSION=2.17
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
ENV REPO_PATH=/data/repos
ENV REPO_NAME=fossil.fossil
ENV REPO=${REPO_PATH}/${REPO_NAME}

# Fossil parameters - do not change
ENV HTTPS_PROXY_PARAM=--https
ENV MULTI_REPO_PARAM=--repolist

# Configurable parameter
ENV PORT=8181
ENV START_PAGE=
ENV HTTPS_PROXY=
ENV MULTI_REPO=
ENV SINGLE_REPO=1




COPY --from=buildstage /usr/local/bin/fossil ${FOSSIL}

RUN mkdir -p /data/repos \
        && /usr/local/bin/fossil init -A admin /data/repos/fossil.fossil \
        && /usr/local/bin/fossil sql "UPDATE user SET pw='admin123' WHERE login='admin';" -R /data/repos/fossil.fossil \
    && addgroup -Sg 400 fossil \
        && adduser -Su 400 -G fossil fossil \
        && chown -R fossil:fossil /data \
    && chown fossil:fossil ${FOSSIL} \
        && chmod a+x ${FOSSIL}

WORKDIR ${REPO_PATH}

EXPOSE ${PORT}

USER fossil

CMD ["sh", "-c", "${FOSSIL} server --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM} ${SINGLE_REPO:+$REPO} ${MULTI_REPO:+$MULTI_REPO_PARAM} ${MULTI_REPO:+$REPO_PATH} "]
