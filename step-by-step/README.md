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

Also create at least one user (make user to only use `a-z0-9` characters for username, no special characters) with a password set.

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

If you already have a running Vault instance, you can skip this step.

An example of Vault deployment can be found [here](vault). If you use it, make sure to change credentials beforehand. Also note that persistence has been disabled so any pod restart will wipe any data. Also note that [dev mode](https://www.vaultproject.io/docs/concepts/dev-server) is also enabled to facilitate install for demonstration purpose. **This mode is not suitable for production**.

### Configure Vault  

We will now configure vault to enable `JWT` support, set policies for users permissions and initialize the secret engine.  
You will need the vault `CLI`. You can either download it [here](https://www.vaultproject.io/downloads) and configure `VAULT_ADDR=https://vault.demo.insee.io` and `VAULT_TOKEN=root` or exec into the vault pod `kubectl exec -it vault-0 -n vault -- /bin/sh` which will have vault `CLI` installed and preconfigured.  

```
vault auth enable jwt
```  

```
vault write auth/jwt/config \
    oidc_discovery_url="https://keycloak.demo.insee.io/auth/realms/onyxia-demo" \
    default_role="onyxia-user"
```  

```
vault write auth/jwt/role/onyxia-user \
    role_type="jwt" \
    bound_audiences="onyxia" \
    user_claim="preferred_username" \
    policies="default"
```

We now need to set the policy for permissions.  
Locally create a `onyxia-kv-policy.hcl` file with the following content, replacing `auth_jwt_fd8af65a` with the generated id from the previous step. You can get it using `vault auth list | grep jwt | awk '{print $3}'`.  
```
path "onyxia-kv/{{identity.entity.aliases.auth_jwt_fd8af65a.name}}/*" {
  capabilities = ["create","update","read","delete","list"]
}

path "onyxia-kv/data/{{identity.entity.aliases.auth_jwt_fd8af65a.name}}/*" {
  capabilities = ["create","update","read"]
}

path "onyxia-kv/metadata/{{identity.entity.aliases.auth_jwt_fd8af65a.name}}/*" {
  capabilities = ["delete", "list", "read"]
}
```  

Then apply the policy :  

```
vault policy write onyxia-kv onyxia-kv-policy.hcl
```

And finally, enable the secret engine :  

```
vault secrets enable -path=onyxia-kv kv-v2
```

### Link Vault to Onyxia

In Onyxia's UI configuration, we only need to set `VAULT_URL: https://vault.demo.insee.io` :

[5-vault.yaml](values/5-vault.yaml)

```
helm upgrade onyxia inseefrlab/onyxia -f values/5-vault.yaml
```

If you used other values for the engine or role than the default one, also specify the corresponding env variable : `VAULT_KV_ENGINE=onyxia-kv` and `VAULT_ROLE=onyxia-user`.
