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
- Valid redirect URIs : [http://onyxia.demo.insee.io/\*](http://onyxia.demo.insee.io/*), [https://onyxia.demo.insee.io/\*](https://onyxia.demo.insee.io/*)
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

## Set up object management

Onyxia provides a S3 compatible integration. The main feature is injecting user's credentials into their on-demand services so that they can seamlessly interact with the object storage directly from the created services.

### Deploy minIO

If you already have a running minIO instance or compatible object storage, you can skip this step.

An example of MinIO deployment can be found [here](minio). If you use it, make sure to change credentials beforehand. Also note that persistence has been disabled so any pod restart will wipe any data and policy.

### Configuring Keycloak for minIO

We will need to make some changes to Keycloak to support minIO :

- Create a new client (e.g `minio`) with `https://minio-console.demo.insee.io` as root URL, `https://minio-console.demo.insee.io/*` as valid redirect URIs, `https://minio-console.demo.insee.io` as web origins. For this client, add a mapper of type `Hardcoded claim` with claim name `policy` and claim value `stsonly`. Make sure `Add to id Token` is enabled.
- In Onyxia's client configuration, add two mappers : `audience-minio` of type `Audience` with `Included client audience: minio` and `policy` of type `Hardcoded claim` with claim name `policy` and claim value `stsonly`.
- You probably want to extend token's duration as the `5 minutes` default value is not enough for users to use the token inside their services. This can be done either `realm wide` (realm settings => tokens) or `per client` (settings => advanced settings).
- If you intend to use groups or want to workaround this bug : https://github.com/InseeFrLab/onyxia-web/issues/263, you may want to add a `groups` client scope with a `Group membership` mapper.

### Configure minIO

MinIO is now capable of authenticating users (thanks to `MINIO_IDENTITY_OPENID_CLIENT_ID`, `MINIO_IDENTITY_OPENID_CONFIG_URL` and other variables) but we still have to specify the permissions. This is done using a `policy`.  
Onyxia currently uses a basic `userid` <> `bucketid` permissions system. Basically each user has access to the bucket with the id equals to it's `userid`.

We provide a sample policy : [stsonly.json](minio/stsonly.json).  
To apply this policy, you can use the minio client :  
Download the client from https://min.io/download#/linux then

```
mc alias set demo https://minio.demo.insee.io admin changeme
mc admin policy add demo stsonly ./minio/stsonly.json
```

If successful, you should be able to login to the minio console and create the bucket that has the same name as your user id.

### Link minIO to Onyxia

In Onyxia's UI configuration, we only need to set `MINIO_URL: https://minio.demo.insee.io` :

[4-minio.yaml](values/4-minio.yaml)

```
helm upgrade onyxia inseefrlab/onyxia -f values/4-minio.yaml
```

## Set up secret management

### Deploy vault

TODO
