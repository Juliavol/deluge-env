#!/usr/bin/env bash
set -x
kubectl create -f ~/rbac_config.yaml
echo create rbac_config.yaml

sudo snap install helm --classic
echo helm installed
helm init --service-account tiller --history-max 200
echo helm init

git clone https://github.com/hashicorp/consul-helm.git
echo git cloned
cd consul-helm
echo cd-helm
git checkout v0.1.0
echo git-checkout
cd

helm install -f /tmp/values.yaml ./consul-helm
echo helm install -f /tmp/values.yaml ./consul-helm