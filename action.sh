#!/bin/sh

set -e

# Setup kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl 
mkdir -p ~/.kube
if [ -n "$CLUSTER_IS_EKS" ]; then
    if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "Please ensure that the AWS environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, etc) are set" && exit 1
    fi
    if [ -z "$CLUSTER_NAME" ]; then
        echo "For EKS, please ensure that the cluster's name is set via the environment variable CLUSTER_NAME" && exit 1
    fi
    aws \
        eks \
        update-kubeconfig \
        --region "${CLUSTER_REGION:-ap-south-1}" \
        --name "$CLUSTER_NAME" \
        --kubeconfig ~/.kube/config
else
    echo "$KUBE_CONFIG_DATA" | base64 --decode > ~/.kube/config
fi
sudo chmod 600 ~/.kube/config

echo "Kube-config obtained. Contexts available:"
kubectl config get-contexts


HELMFILE_VERSION="0.148.1"
curl -Lo helmfile.tar.gz https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz
sudo tar -xf helmfile.tar.gz -C /usr/local/bin/
sudo chmod 0755 /usr/local/bin/helmfile

# Setup helm plugin `helm-diff`
HELM_DIFF_VERSION="3.6.0"
helm plugin install https://github.com/databus23/helm-diff --version "$HELM_DIFF_VERSION"

# Setup helm plugin `helm-secrets`
HELM_SECRETS_VERSION="4.1.1"
helm plugin install https://github.com/jkroepke/helm-secrets --version v"$HELM_SECRETS_VERSION"

# Install sops
SOPS_VERSION="v3.7.1"
SOPS_OS="linux"
SOPS_DL_URL="https://github.com/mozilla/sops/releases/download/$SOPS_VERSION/sops-$SOPS_VERSION.$SOPS_OS"
echo "installing sops from $SOPS_DL_URL"
wget -O sops "$SOPS_DL_URL"
chmod +x sops
sudo install -o root -g root -m 0755 sops /usr/local/bin/sops
