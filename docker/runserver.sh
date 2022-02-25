#!/bin/sh


# Fossil parameters
HTTPS_PROXY_PARAM=--https
MULTI_REPO_PARAM=--repolist
PROJECT_NAME_PARAM=--project-name
PROJECT_DESC_PARAM=--project-desc

# Configurable parameter
ENV START_PAGE=
ENV HTTPS_PROXY=
ENV MULTI_REPO=
ENV SINGLE_REPO=1

# Set default values
if [ -z ${REPOS} ] ; then
    REPOS="fossil.fossil"
fi

if [ -z ${USERNAME} ] ; then
    USERNAME="admin"
fi

if [ -z ${PASSWORD} ] ; then
    PASSWORD="admin1234"
fi

# Setup new repository
if [ ! -e ${REPO_PATH}/${REPOS} ] ; then
    NEW_REPOS="true"
    echo "${FOSSIL} init -A ${USERNAME} ${REPO_PATH}/${REPOS}"
    ${FOSSIL} init -A ${USERNAME} ${REPO_PATH}/${REPOS}
fi

# Change password (first time)
if [ ! -z ${NEW_REPOS} ] &&  [ ! -z ${PASSWORD} ] ; then
    echo "${FOSSIL} user password ${USERNAME} ${PASSWORD} -R ${REPO_PATH}/${REPOS}"
    ${FOSSIL} user password ${USERNAME} ${PASSWORD} -R ${REPO_PATH}/${REPOS}
fi

unset $USERNAME
unset $PASSWORD

# Start up fossil
if [ -e ${REPO_PATH}/${REPOS} ] ; then
    if [ ! -z ${MULTI_REPO} ] ; then
        echo "${FOSSIL} server ${REPO_PATH}/${REPOS} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}"
        ${FOSSIL} server ${REPO_PATH}/${REPOS} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}
    else
        echo "${FOSSIL} server ${MULTI_REPO_PARAM} ${REPO_PATH} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}"
        ${FOSSIL} server ${MULTI_REPO_PARAM} ${REPO_PATH} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}
    fi
fi

