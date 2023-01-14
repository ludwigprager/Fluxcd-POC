#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

#find example.multicluster/fleet/ -type f |xargs -L 1 sed -i 's/core-app/core-app/g'
#find example.multicluster/fleet/ -type f |xargs -L 1 sed -i 's/core-infra/core-infra/g'
#find example.multicluster/fleet/ -type f |xargs -L 1 sed -i 's/dmz-app/dmz-app/g'
#find example.multicluster/fleet/ -type f |xargs -L 1 sed -i 's/dmz-infra/dmz-infra/g'

./20-start-gitea.sh
./30-create-environment-repositories.sh
./40-start-a-k8s-cluster.sh
./50-install-flux-k8s.sh
