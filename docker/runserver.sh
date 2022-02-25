#!/bin/sh

if [ -z ${REPOS} ] ; then
    REPOS="fossil.fossil"
fi

if [ ! -e ${REPO_PATH}/${REPOS} ] ; then
    echo "${FOSSIL} init -A ${USERNAME} ${REPO_PATH}/${REPOS}"
    ${FOSSIL} init -A ${USERNAME} ${REPO_PATH}/${REPOS}
fi

if [ ! -z ${PASSWORD} ] ; then
    echo "${FOSSIL} user password ${USERNAME} ${PASSWORD} -R ${REPO_PATH}/${REPOS}"
    ${FOSSIL} user password ${USERNAME} ${PASSWORD} -R ${REPO_PATH}/${REPOS}
fi

unset $USERNAME
unset $PASSWORD

if [ -e ${REPO_PATH}/${REPOS} ] ; then
    echo "starting..."
    if [ ! -z ${MULTI_REPO} ] ; then
        echo "${FOSSIL} server ${REPO_PATH}/${REPOS} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}"
        ${FOSSIL} server ${REPO_PATH}/${REPOS} --port ${PORT}
    else
        echo "${FOSSIL} server --repolist ${REPO_PATH} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}"
        ${FOSSIL} server --repolist ${REPO_PATH} --port ${PORT}
    fi
fi

