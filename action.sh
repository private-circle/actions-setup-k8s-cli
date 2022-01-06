#!/bin/sh

set -e

# Setup kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl 
mkdir -p ~/.kube
echo "$KUBE_CONFIG_DATA" | base64 --decode > ~/.kube/config
sudo chmod 600 ~/.kube/config

curl -LO https://github.com/roboll/helmfile/releases/download/v0.140.0/helmfile_linux_amd64
sudo install -o root -g root -m 0755 helmfile_linux_amd64 /usr/local/bin/helmfile

# Setup helm plugin `helm-diff`
HELM_DIFF_VERSION="3.1.3"
helm plugin install https://github.com/databus23/helm-diff --version "$HELM_DIFF_VERSION"

# Setup helm plugin `helm-secrets`
HELM_SECERTS_VERSION="3.11.0"
helm plugin install https://github.com/jkroepke/helm-secrets --version v"$HELM_SECERTS_VERSION"

# Install sops
SOPS_VERSION="v3.7.1"
SOPS_OS="linux"
SOPS_DL_URL="https://github.com/mozilla/sops/releases/download/$SOPS_VERSION/sops-$SOPS_VERSION.$SOPS_OS"
echo "installing sops from $SOPS_DL_URL"
wget -O sops "$SOPS_DL_URL"
chmod +x sops
sudo install -o root -g root -m 0755 sops /usr/local/bin/sops
