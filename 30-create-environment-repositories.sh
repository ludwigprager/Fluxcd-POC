#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh


# create remote repos in gitea
token=$(get-a-token)
create-repo $token FluxCD-CORE


# staging

function multi-tenancy() {

  create-repo $token FluxCD-tenant01

  if [ ! -d ${BASEDIR}/FluxCD-CORE ]; then

    cd ${BASEDIR}
    git clone --origin poc ssh://git@${GITEA}:8022/lp/FluxCD-CORE.git
    cd FluxCD-CORE
    cp -a ${BASEDIR}/example.multitenancy/platform-admin-repository/* ${BASEDIR}/FluxCD-CORE/
    git add .
    git commit -m "Initial commit"
    git push --set-upstream poc main

  fi

  if [ ! -d ${BASEDIR}/FluxCD-tenant01 ]; then

    cd ${BASEDIR}
    git clone --origin poc ssh://git@${GITEA}:8022/lp/FluxCD-tenant01.git
    cd FluxCD-tenant01
    cp -a ${BASEDIR}/example.multitenancy/tenant-repository/* ${BASEDIR}/FluxCD-tenant01/
    git add .
    git commit -m "Initial commit"
    git push --set-upstream poc main

  fi
}


function multi-cluster() {

  # multi-cluster

  if [ ! -d ${BASEDIR}/FluxCD-CORE ]; then

    cd ${BASEDIR}
    git clone --origin poc ssh://git@${GITEA}:8022/lp/FluxCD-CORE.git
    cd FluxCD-CORE
    cp -a ${BASEDIR}/example.multicluster/* ${BASEDIR}/FluxCD-CORE/
    git add .
    git commit -m "Initial commit"
    git push --set-upstream poc main

  fi
}



case "$POC" in
  "multi-tenancy")
     multi-tenancy
     ;;
  "multi-cluster")
     multi-cluster
     ;;
  *)
     echo "falsche POC Auswahl"
     exit 1
     ;;
esac
