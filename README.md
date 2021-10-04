# The Onyxia Datalab

Welcome to the Onyxia Datalab !

## Quickstart

The simplest way to install Onyxia is to use [`Helm`](https://helm.sh).

```
helm repo add inseefrlab https://inseefrlab.github.io/helm-charts
helm install onyxia inseefrlab/onyxia --set ingress.enabled=true --set ingress.hosts[0].host=datalab.yourdomain.com
```

Browse to `http://datalab.yourdomain.com` and enjoy :)

Note that this is only a bare installation of Onyxia with some major limitations (no authentication, deployed services won't be accessible ...). Read below for more configuration options.

## Installation & configuration

See [Installation](INSTALL.md)

## Modules

Onyxia is split into several modules :

| Module                                                 | Purpose                            | Status                 |
| ------------------------------------------------------ | ---------------------------------- | ---------------------- |
| [Onyxia WEB](https://github.com/inseefrlab/onyxia-web) | Web UI (`React`)                   | :white_check_mark:     |
| [Onyxia API](https://github.com/inseefrlab/onyxia-api) | Server part (`Java / Spring-boot`) | :white_check_mark:     |
| [Onyxia CLI](https://github.com/inseefrlab/onyxia-cli) | Command line application (`Go`)    | :large_orange_diamond: |

## Related repositories

### Services catalogs

Onyxia relies on catalogs to provide users with a selection of services they can install in one click.  
You can either create your own repositories or use the default ones :

| Repository                                                                       | Purpose                                                    | Status             |
| -------------------------------------------------------------------------------- | ---------------------------------------------------------- | ------------------ |
| [Helm charts datascience](https://github.com/inseefrlab/helm-charts-datascience) | Datascience catalog using `Helm` (for `Kubernetes`) format | :white_check_mark: |

### Docker images for services

`InseeFRLab` maintains various `Docker` images that extends standard images so that they work nicely inside the datalab.  
You can browse them here : [Repositories using `docker-image` tag on `InseeFRLab`](https://github.com/search?q=topic%3Adocker-image+org%3AInseeFrLab+fork%3Atrue)

### Cloudshell

Onyxia integrates a `cloudshell` that is based on a `WebSSH` docker image.  
The docker image used is codenamed `Shelly` and is available here : [Shelly](https://github.com/inseefrlab/shelly)

### Miscellaneous

| Repository                                                                     | Purpose                                                                          | Status             |
| ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------- | ------------------ |
| [Helm charts](https://github.com/inseefrlab/helm-charts)                       | Collection of Helm charts including Onyxia's Helm chart                          | :white_check_mark: |
| [Simple default backend](https://github.com/InseeFrLab/simple-default-backend) | A simple loading webpage that gets displayed for services that are not yet ready | :white_check_mark: |

### Infrastructure scripts

The `cloud-scripts` repository is a collection of scripts we used at some point at `Insee`. They are provided as is with minimal to no documentation and support. They are, currently at least, used as memo and not production grade code.  
The repository is available here : [cloud-scripts](https://github.com/inseefrlab/cloud-scripts)
