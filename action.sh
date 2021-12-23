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
helm plugin install https://github.com/databus23/helm-diff

# Setup helm plugin `helm-secrets`
helm plugin install https://github.com/jkroepke/helm-secrets --version v3.11.0
# Install sops
SOPS_VERSION="v3.7.1"
SOPS_OS="linux"
curl -L "https://github.com/mozilla/sops/releases/download/$SOPS_VERSION/$SOPS_OS" -O sops
chmod +x sops
sudo install -o root -g root -m 0755 sops /usr/local/bin/sops
