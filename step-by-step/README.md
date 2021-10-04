# Step by step installation of Onyxia

This tutorial will guide you, step by step, from scratch to a fully configured Onyxia deployment.  
See https://github.com/InseeFrLab/onyxia/blob/master/INSTALL.md for general instructions on how to install and configure Onyxia.

## Starting point

Before installing Onyxia, we need a Kubernetes cluster with an active Ingress controller.  
There are many ways to achieve this. If needed, we provide 2 basic tutorials on how to set this up using cloud providers :

- [https://github.com/InseeFrLab/cloud-scripts/tree/master/eks](https://github.com/InseeFrLab/cloud-scripts/tree/master/eks) for `EKS` (`AWS`)
- [https://github.com/InseeFrLab/cloud-scripts/tree/master/gke](https://github.com/InseeFrLab/cloud-scripts/tree/master/gke) for `GKE` (`GCP`)

We will now assume that you have a working Kubernetes cluster, with Ingress support and a wildcard domain configured (we will use `*.demo.insee.io`).
You can read more about Onyxia's prerequisites and optional dependencies [here](https://github.com/InseeFrLab/onyxia/blob/master/INSTALL.md#prerequisites)

## Install Onyxia

```
helm repo add inseefrlab https://inseefrlab.github.io/helm-charts
```

[1-basic.yaml](values/1-basic.yaml)

```
helm install onyxia inseefrlab/onyxia -f values/1-basic.yaml
```

Congratulations, you now have a basic `Onyxia` datalab running on your brand new cluster :)  
Browse to `https://onyxia.demo.insee.io` and deploy your first on-demand service !

This installation is very basic and has a lot of limitations (see [https://github.com/InseeFrLab/onyxia/blob/master/INSTALL.md#installation-1](https://github.com/InseeFrLab/onyxia/blob/master/INSTALL.md#installation-1))
We will now configure it to remove thoses limitations.

## Set up authentication (openidconnect)

We strongly recommend you don't use Onyxia without any authentication configured.  
Onyxia supports `openidconnect`.

### Set up keycloak

If you already have a Keycloak instance running or an existing `openidconnect` provider, you can skip this step.

An example of Keycloak deployment can be found [here](keycloak). If you use it, make sure to change credentials beforehand.

Create a realm (in this tutorial we choose `onyxia-demo`) and a client (we choose `onyxia-client`).  
Here are some client settings :

- ROOT url : https://onyxia.demo.insee.io
- Valid redirect URIs : http://onyxia.demo.insee.io, https://onyxia.demo.insee.io
- Web-origins : http://onyxia.demo.insee.io, https://onyxia.demo.insee.io

Also create at least one user with a password set.

### Activate openidconnect in Onyxia

[2-oidc.yaml](values/2-oidc.yaml)

```
helm upgrade onyxia inseefrlab/onyxia -f values/2-oidc.yaml
```  

Authentication is now enabled on Onyxia, users will be prompted to log-in before being able to access advanced features such as deploying on-demand services (note that the catalog is browsable without authentication).

## Activate multi namespace mode and regions configuration

Now that users are authenticated, we can switch to multi namespaces (so that each user deploy services into it's own namespace).  
Note that this requires `cluster-admin` role (`serviceAccount.clusterAdmin=true` in helm values).  
We also set the domain name used by created services as `"expose": { "domain": "demo.insee.io" }` so that each created service will be accessible at `pseudorandom-generated-value.demo.insee.io`.

[3-regions.yaml](values/3-regions.yaml)

```
helm upgrade onyxia inseefrlab/onyxia -f values/3-regions.yaml
```
