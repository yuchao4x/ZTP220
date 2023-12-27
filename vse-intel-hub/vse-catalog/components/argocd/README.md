# ArgoCD patch required for ZTP deployments 

The following patch is required for ZTP worload clusters to be deployed from vse-carslab-hub repository

The current *overlays* available are for the following versions:
* [4.10](overlays/4.10)
* [4.11](overlays/4.11)
* [4.12](overlays/4.12)
* [4.13](overlays/4.13)


There is also a default included if you want to not have this ztp argocd patch included.
* [default](overlays/default)

## Usage
If you have cloned the repository, you can apply based on the overlay of your choice by running from the root vse-catalog directory

```
oc apply -k vse-catalog/components/argocd/overlays/<version>
```

Or, without cloning:

```
oc apply -k https://github.com/redhat-partner-solutions/vse-catalog/components/argocd/overlays/<version>
```

As part of a different overlay in your own GitOps repo:

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases:
  - github.com/redhat-partner-solutions/vse-catalog/components/argocd/overlays/<version>?ref=mai
```
