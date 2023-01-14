#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

if [[ "$POC" = "multi-tenancy" ]]; then
  echo "sorry, das habe ich nur in 'multi-cluster' eingebaut"
  exit 1
fi


sed -i 's@version: "6.2.2"@version: "6.2.3"@g' FluxCD-CORE/apps/core-app/podinfo-values.yaml

pushd FluxCD-CORE/

git add .

git commit -m "Upgrade to 6.2.3" || true

git push
popd

kubectl config use-context k3d-core-app
while true; do
  clear
  kubectl get events --sort-by='.metadata.creationTimestamp' -A
  ./flux get all
  kubectl get po -npodinfo  -l     app.kubernetes.io/name=podinfo -o=json | jq -r '.items[0].spec.containers[0].image'
  sleep 5
done
