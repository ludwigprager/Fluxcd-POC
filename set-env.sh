#!/usr/bin/env bash

export GITEA=$(hostname)
export KUBECONFIG=${BASEDIR:-$(pwd)}/kubeconfig

export GITEA_LP_USER=lp
export GITEA_LP_PASSWORD=geheim

export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${BASEDIR:-$(pwd)}/key" 

export CLUSTERS=""
export CLUSTER_PREFIX=""
CLUSTERS="${CLUSTERS} ${CLUSTER_PREFIX}core-app"
CLUSTERS="${CLUSTERS} ${CLUSTER_PREFIX}core-infra"
CLUSTERS="${CLUSTERS} ${CLUSTER_PREFIX}dmz-app"
CLUSTERS="${CLUSTERS} ${CLUSTER_PREFIX}dmz-infra"


# hier den POC-type auswählen (der letzte gewinnt)
POC=multi-tenancy
POC=multi-cluster
