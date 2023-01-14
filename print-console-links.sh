#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

echo
echo "podinfo:          http://localhost:8081/"
echo "fleet repo:       http://$GITEA:3000/explore/repos/"
echo "swagger:          http://${GITEA}:3000/api/swagger#"
echo "Vorlage:          https://github.com/fluxcd/flux2-kustomize-helm-example"
echo

