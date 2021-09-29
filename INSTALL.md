# Installation

## Prerequisites

### A Kubernetes cluster

The main prerequisite for deploying `Onyxia` is a running Kubernetes cluster.  
We recommend using up-to-date cluster versions.

### Access rights (RBAC)

If deploying in `single namespace` mode (default), Onyxia requires `admin` permissions `scoped` to the installation namespace.  
Otherwise, Onyxia requires `cluster-wide` `cluster-admin` permissions.

Those permissions should be granted to the `onyxia-api` pod (done automatically when installing using helm). Other pods currently need no specific permissions.

### Reverse proxy (Ingress controller)

Onyxia is currently primarily a web-based application so reverse-proxyfying it is usually needed.  
Onyxia has been primarily tested on [`nginx-ingress`](https://kubernetes.github.io/ingress-nginx/) but any ingress controller should work fine.

Optional dependencies are [listed below](#dependencies).

## Installation

We recommend using [Helm](https://helm.sh/) (v3+) to deploy `Onyxia`.  
The official chart is hosted on [https://github.com/InseeFrLab/helm-charts](https://github.com/InseeFrLab/helm-charts).

```
helm repo add inseefrlab https://inseefrlab.github.io/helm-charts
helm install onyxia inseefrlab/onyxia --set ingress.enabled=true --set ingress.hosts[0].host=datalab.yourdomain.com
```  

This will install Onyxia in `single namespace` mode, with `admin` permissions on the target namespace, accessible on `datalab.yourdomain.com`, `no authentication`, no file management, no secret management and the default services catalog.  

Advanced configuration is [described below](#configuration).

## <a name="dependencies"></a> Optional dependencies

### Keycloak

### Minio

### Vault

## <a name="configuration"></a> Advanced configuration  

