#build stage for creating fossil executable
FROM alpine:latest AS buildstage

ARG FOSSIL_VERSION=2.17
ARG FOSSIL_URL=https://www2.fossil-scm.org/home/tarball/f48180f2ff3169651a725396d4f7d667c99a92873b9c3df7eee2f144be7a0721/fossil-src-2.17.tar.gz
WORKDIR /build

RUN apk add --update --no-cache alpine-sdk build-base tcl-dev tk openssl-dev && \ 
wget ${FOSSIL_URL} && \ 
tar zxvf fossil-src-${FOSSIL_VERSION}.tar.gz && \ 
cd /build/fossil-src-${FOSSIL_VERSION} && \ 
./configure --with-th1-docs --with-th1-hooks --json && \ 
make && \ 
strip fossil && \ 
make install

#production stage just has the build fossil executable, and serves the repos
#note, this presumes the repos have been bind-mounted in ${FOSSIL_REPO_LOC}
FROM alpine:latest AS production

ENV FOSSIL_PORT=8181
ENV FOSSIL_REPO=/data/repos
ENV USERNAME=admin

COPY --from=buildstage /usr/local/bin/fossil /usr/local/bin/fossil

RUN mkdir -p ${FOSSIL_REPO}
RUN /usr/local/bin/fossil init -A ${USERNAME} ${FOSSIL_REPO}/fossil.fossil
RUN /usr/local/bin/fossil sql "UPDATE user SET pw='admin123' WHERE login='admin';" -R ${FOSSIL_REPO}/fossil.fossil

RUN /usr/local/bin/fossil init -A ${USERNAME} ${FOSSIL_REPO}/python.fossil
RUN /usr/local/bin/fossil sql "UPDATE user SET pw='admin123' WHERE login='admin';" -R ${FOSSIL_REPO}/python.fossil

RUN /usr/local/bin/fossil init -A ${USERNAME} ${FOSSIL_REPO}/index.fossil
RUN /usr/local/bin/fossil sql "UPDATE user SET pw='admin123' WHERE login='admin';" -R ${FOSSIL_REPO}/index.fossil

#ENTRYPOINT fossil server --port ${FOSSIL_PORT} --repolist ${FOSSIL_REPO_LOC}

RUN addgroup -Sg 400 fossil \
        && adduser -Su 400 -G fossil fossil \
        && chown -R fossil:fossil /data \
    && chown fossil:fossil /usr/local/bin/fossil \
        && chmod a+x /usr/local/bin/fossil \
    && echo "Finished !"

WORKDIR "/data/repos"

EXPOSE ${FOSSIL_PORT}

USER fossil

CMD ["/usr/local/bin/fossil", "server", "--port", "8181", "--https", "--repolist", "/data/repos"]