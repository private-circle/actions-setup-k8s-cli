# Actions Setup K8s CLI

This github action sets up an opinionated kubernetes cli environment. As part of this, it installs
- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [helmfile](https://github.com/roboll/helmfile)
- [helm-diff](https://github.com/databus23/helm-diff)
- [helm secrets]()https://github.com/jkroepke/helm-secrets
- [sops](https://github.com/mozilla/sops)

## Usage

`.github/workflows/ci.yml`

```yaml
name: CI
on: push
  branches: [ main ]
jobs:
  test:
    name: Tests during
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    
    - name: Setup K8s CLI
      uses: private-circle/actions-setup-k8s-cli
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
     
     - name: Get Pods
        run: |
          kubectl get pods -A
            
     - name: Helmfile Diff
        id: helmfile-diff
        run: | 
          helmfile diff
```

## Secrets

`KUBE_CONFIG_DATA` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```
