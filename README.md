# Actions Setup K8s CLI

This GitHub Action sets up an opinionated Kubernetes CLI environment. It installs:

- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [helmfile](https://github.com/helmfile/helmfile)
- [helm-diff](https://github.com/databus23/helm-diff)
- [helm-secrets](https://github.com/jkroepke/helm-secrets)
- [sops](https://github.com/mozilla/sops)

## Version Defaults

All version inputs are optional. If you omit them, the action uses these defaults:

| Input | Default | Notes |
| --- | --- | --- |
| `kubectl-version` | `v1.35.0` | Provide the full Kubernetes release tag. |
| `helm-diff-version` | `3.6.0` | Provide plain semver. |
| `helm-secrets-version` | `4.6.5` | Provide plain semver without a leading `v`. The action fails fast if you include it. |
| `helmfile-version` | `0.148.1` | Provide plain semver. |
| `sops-version` | `v3.7.1` | Provide the full `sops` release tag. |

## Usage

`.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches:
      - main

jobs:
  test:
    name: Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup K8s CLI
        uses: private-circle/actions-setup-k8s-cli@main
        with:
          kubectl-version: v1.35.0
          helm-diff-version: 3.6.0
          helm-secrets-version: 4.6.5
          helmfile-version: 0.148.1
          sops-version: v3.7.1
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}

      - name: Get Pods
        run: kubectl get pods -A

      - name: Helmfile Diff
        run: helmfile diff
```

All version inputs are optional. Omit any of them to use the defaults listed above.

## Environment

- `KUBE_CONFIG_DATA`: Required unless you are using the EKS flow. This should be a base64-encoded kubeconfig file with credentials for Kubernetes cluster access.
- `CLUSTER_IS_EKS`: Set this to any non-empty value to use `aws eks update-kubeconfig` instead of `KUBE_CONFIG_DATA`.
- `CLUSTER_NAME`: Required when `CLUSTER_IS_EKS` is set.
- `CLUSTER_REGION`: Optional when `CLUSTER_IS_EKS` is set. Defaults to `ap-south-1`.
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`: Required when `CLUSTER_IS_EKS` is set.
- `helm` must already be available on the runner because this action only installs the `helm-diff` and `helm-secrets` plugins.

You can base64-encode an existing kubeconfig with:

```bash
base64 < "$HOME/.kube/config" | tr -d '\n'
```
