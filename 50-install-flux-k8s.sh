#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh

# install flux from https://github.com/fluxcd/flux2/releases
if [[ ! -f flux ]] ; then
  curl -Ls https://github.com/fluxcd/flux2/releases/download/v0.37.0/flux_0.37.0_linux_amd64.tar.gz | tar xz
fi


PRIVATE_KEY=$(realpath key)
PRIMARY_IP=$(get-primary-ip)

# install flux in clusters
for cluster in $CLUSTERS; do

  ./flux bootstrap git \
    --url=ssh://git@${PRIMARY_IP}:8022/lp/FluxCD-CORE.git \
    --private-key-file=${PRIVATE_KEY} \
    --branch=main \
    --silent \
    --context=k3d-${cluster} \
    --path=clusters/${cluster}/  

done


( cd ${BASEDIR}/FluxCD-CORE; git pull)


echo "kubectl -n nginx port-forward svc/nginx-ingress-controller 8080:80 &"
echo "curl -H "Host: podinfo" http://localhost:8080"

#for cluster in $CLUSTERS; do
# kubectl --context=k3d-${cluster} -npodinfo port-forward svc/podinfo 9898:9898 &

# wait for podinfo pod
#kubectl wait pod -npodinfo -l app.kubernetes.io/name=podinfo --for condition=Ready
kubectl --context=k3d-core-app delete ingress podinfo -npodinfo

kubectl --context=k3d-core-app apply -f manifest/ingress.yaml || true
#curl http://localhost:8081
sensible-browser http://localhost:8081 &
#killall kubectl || true
#
#kubectl --context=k3d-core-app -npodinfo port-forward svc/podinfo 9898:9898 &
#sensible-browser http://localhost:9898 &
#done

