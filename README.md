<p align="center">
    <img src="https://user-images.githubusercontent.com/6702424/137828729-173cfe2b-54dc-4e7e-aa60-4e3fe3a4fb39.png">
</p>
<p align="center">
    <i>🔬 A data science oriented container launcher 🔬</i>
    <br>
    <br>
    <img src="https://img.shields.io/npm/l/onyxia-ui">
</p>

<p align="center">
  <a href="https://datalab.sspcloud.fr" title="Instance of Onyxia hosted in INSEE's data center">Our instance of Onyxia @ INSEE</a>
</p>

Onyxia is a web app that aims at being the glue between multiple open source backend technologies to
provide a state of art working environnement for data scientists.  
Onyxia is developed by the French National institute of statistic and economic studies ([INSEE](https://insee.fr)).  

<p align="center">
<img src="https://user-images.githubusercontent.com/6702424/136545513-f623d8c7-260d-4d93-a01e-2dc5af6ad473.gif" />
</p>

**Core feature set**:

- [An interface for launching docker images](https://datalab.sspcloud.fr/catalog/inseefrlab-helm-charts-datascience) 
  (e.g: [Jupyter](https://jupyter.org), [RStudio](https://www.rstudio.com)) on demand on a [Kubernetes](https://kubernetes.io) cluster.  
  The catalog of available images is not part of the app, you can create your own. 
  ([here](https://github.com/inseefrlab/helm-charts-datascience) the catalog we build for the institute's needs.)
- Define [the amount of RAM, CPU and **GPU** they would like to allocate](https://user-images.githubusercontent.com/6702424/137818454-3fdb3efb-1fbd-4e4d-85b1-64b00d8af03e.png) 
  to their containers.
- Specify [a custom init script](https://user-images.githubusercontent.com/6702424/137819445-a9dfd053-a5f1-48da-a294-f20717512ef5.png) to be executed at launch.
- [Define environnement variables](https://user-images.githubusercontent.com/6702424/137819689-71e59823-a553-4c3c-8558-2576316e4709.png) to be made available in the containers.
- [Save and restore your service service configurations](https://user-images.githubusercontent.com/6702424/137819972-b9974760-4647-43ff-b985-f3facfce99de.png)
- Deep integration with S3 for working with data (S3 as the open standard, not the AWS service) and with [Vault](https://www.vaultproject.io) 
  ( for [secret management](https://user-images.githubusercontent.com/6702424/137820741-bed9ee77-124a-46f6-b686-8b8dff1615bd.png) )
- [Keycloak integration](https://user-images.githubusercontent.com/6702424/137821446-ed908862-69e3-464c-b347-bd8776a425cc.png).

# Table of content

- [Table of content](#table-of-content)
	- [Screenshots](#screenshots)
	- [Deploy onyxia on your infrastructure today 🚀](#deploy-onyxia-on-your-infrastructure-today-)
	- [Installation & configuration](#installation--configuration)
	- [Modules](#modules)
		- [Services catalogs](#services-catalogs)
		- [Docker images for services](#docker-images-for-services)
		- [Cloudshell](#cloudshell)
		- [Miscellaneous](#miscellaneous)
		- [Infrastructure scripts](#infrastructure-scripts)
	- [Roadmap 🛣](#roadmap-)
		- [Recently released 🎁](#recently-released-)
		- [Coming soon ☄️](#coming-soon-️)
		- [WIP 🏗](#wip-)
		- [Ideas 💡](#ideas-)
	- [Media](#media)

## Screenshots

![image](https://user-images.githubusercontent.com/6702424/122631126-8c8d3380-d0c9-11eb-968f-af3e605b0e07.png)
![scree_myservices](https://user-images.githubusercontent.com/6702424/121828699-a8a36600-ccc0-11eb-903c-1cd4b6cbb0ff.png)
![screen_launcher](https://user-images.githubusercontent.com/6702424/121828696-a80acf80-ccc0-11eb-86fb-c7d0bca55d4f.png)
![my_secrets](https://user-images.githubusercontent.com/6702424/121828695-a5a87580-ccc0-11eb-9e86-295fdac6c497.png)


## Deploy onyxia on your infrastructure today 🚀

<p align="center">
	<img src="https://user-images.githubusercontent.com/6702424/137823160-40676450-36db-411d-a314-666d626d040f.png" />
</p>

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

| Module                                                 | Description                           | Status                 |
| ------------------------------------------------------ | --------------------------------------| ---------------------- |
| [Onyxia WEB](https://github.com/inseefrlab/onyxia-web) | Web UI (`React`)                      | :white_check_mark:     |
| [Onyxia API](https://github.com/inseefrlab/onyxia-api) | Kubernetes API (`Java / Spring-boot`) | :white_check_mark:     |
| [Onyxia-UI](https://github.com/InseeFrLab/onyxia-ui)   | Design system and React UI toolkit    | :white_check_mark:     |
| [Onyxia CLI](https://github.com/inseefrlab/onyxia-cli) | Command line application (`Go`)       | :large_orange_diamond: |

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

## Roadmap 🛣

The Onyxia project is actively developed. We are constantly working on new functionalities to meet our users needs at [Insee](https://github.com/InseeFr). Do not hesitate to [get in touch with us](https://github.com/InseeFrLab/onyxia/discussions/new) to ask questions or share your ideas!
### Recently released 🎁

- New services: Argo CD, Argo Workflow and Gravitee
- Step by step Onyxia deployment guide
- Customizable UI themes
- Pin & edit custom services
- Secrets management

### Coming soon ☄️

- Projects and collaboration

### WIP 🏗

- Onyxia installation documentation
- Project documentation (`CONTRIBUTING.md`...)

### Ideas 💡

- End user documentation
- Extend the catalog of data science services
- Data governance (data & metadata management, data cataloging, data lineage, data quality management)
- What data management features does a user need in Onyxia (objects explorer, PV manager...)?
- Billing, monitoring & housekeeping of services


- Onyxia deployment automation
- Instance administration (users & groups...)

## Media

[![EIG](https://user-images.githubusercontent.com/6702424/137893928-e341f3fe-13cf-44e6-9332-7ade8653c7f8.png)](https://youtu.be/ukMHBAXwzRg)
