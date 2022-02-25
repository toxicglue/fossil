#!/bin/sh


# Fossil parameters
HTTPS_PROXY_PARAM=--https
MULTI_REPO_PARAM=--repolist
PROJECT_NAME_PARAM=--project-name
PROJECT_DESC_PARAM=--project-desc

# //////////////////////////////////////////////////////////
# Configurable parameters
# REPOS        - Repository (default: fossil.fossil)
# PASSWORD     - password (default: admin1234)
# USERNAME     - username (admin: default)
# PROJECT_NAME - project name for a new repos
# PROJECT_DESC - project description for a new repos
# START_PAGE   - startpage for a new repos
# HTTPS_PROXY  - enable https proxy
# MULTI_REPO   - support for multiple repos
# //////////////////////////////////////////////////////////


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

if [ ! -z ${PROJECT_NAME} ] ; then
    PROJECT_NAME_PARAM="${PROJECT_NAME_PARAM} ${PROJECT_NAME}"
fi

if [ ! -z ${PROJECT_DESC} ] ; then
    PROJECT_DESC_PARAM="${PROJECT_DESC_PARAM} ${PROJECT_DESC}"
fi

# Setup new repository
if [ ! -e ${REPO_PATH}/${REPOS} ] ; then
    NEW_REPOS="true"
    ${FOSSIL} init -A ${USERNAME} ${PROJECT_NAME:+$PROJECT_NAME_PARAM} ${PROJECT_DESC:+$PROJECT_DESC_PARAM} ${REPO_PATH}/${REPOS}
fi

# Change password (first time)
if [ ! -z ${NEW_REPOS} ] &&  [ ! -z ${PASSWORD} ] ; then
    ${FOSSIL} user password ${USERNAME} ${PASSWORD} -R ${REPO_PATH}/${REPOS}
fi

unset $USERNAME
unset $PASSWORD

# Start up fossil
if [ -e ${REPO_PATH}/${REPOS} ] ; then
    if [ -z ${MULTI_REPO} ] ; then
        ${FOSSIL} server ${REPO_PATH}/${REPOS} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}
    else
        ${FOSSIL} server ${MULTI_REPO_PARAM} ${REPO_PATH} --port ${PORT} ${HTTPS_PROXY:+$HTTPS_PROXY_PARAM}
    fi
fi

