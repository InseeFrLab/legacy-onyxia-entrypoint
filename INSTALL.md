# Installation

This is the general documentation on how to install and configure Onyxia. If you prefer, there is a step-by-step tutorial on deploying Onyxia from scratch available [here](step-by-step/README.md)
## <a name="prerequisites"></a> Prerequisites

### A Kubernetes cluster

The main prerequisite for deploying `Onyxia` is a running Kubernetes cluster.  
We recommend using up-to-date cluster versions.  
Onyxia has been tested on both `cloud` and `on-premise`.

### Access rights (RBAC)

If deploying in `single namespace` mode (default), Onyxia requires `admin` permissions `scoped` to the installation namespace.  
Otherwise, Onyxia requires cluster-wide `cluster-admin` permissions.

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

Note that this installation is very basic and has the following limitations :  
- `NO AUTHENTICATION` : there is no restriction on who can access and use this installation. We **strongly recommend NOT using this mode in production**.  
- Onyxia runs in `single-namespace` mode. This means everything is deployed in the same namespace Onyxia has been deployed in.  
- Services created by Onyxia won't be accessible (by default services will be deployed under `fakedomain.kub.example.com`)
- File management (minio integration) and secret management (vault support) is disabled.  

Advanced configuration is [described below](#configuration).

## <a name="dependencies"></a> Optional dependencies

### Keycloak

### Minio

### Vault

## <a name="configuration"></a> Advanced configuration  

