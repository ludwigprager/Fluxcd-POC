#!/bin/bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./set-env.sh

set -eu

while true; do
  clear


  for cluster in $CLUSTERS; do

    echo $cluster:

    kubectl --context=k3d-${cluster} get po -nflux-system
#   CONTEXT=k3d-${cluster}
    ./flux get --cluster=k3d-$cluster sources git    || true
    ./flux get --cluster=k3d-$cluster kustomizations || true
    ./flux get --cluster=k3d-$cluster helmreleases   || true
    echo

  done


  sleep 10
done

