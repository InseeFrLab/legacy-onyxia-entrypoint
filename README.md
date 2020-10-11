# The Onyxia Datalab

Welcome to the Onyxia Datalab !  

## Modules  

Onyxia is split into several modules :  

| Module | Purpose | Status |
|---|---|---|
| [Onyxia UI](https://github.com/inseefrlab/onyxia-ui)   | Web UI (`React`)  | :white_check_mark:  |
| [Onyxia API](https://github.com/inseefrlab/onyxia-api)  | Server part (`Java / Spring-boot`)  | :white_check_mark:  |  
| [Onyxia CLI](https://github.com/inseefrlab/onyxia-cli)  | Command line application (`Go`)  | :large_orange_diamond:  | 

## Quickstart (using Helm) 

The simplest way to install Onyxia is on `Kubernetes` using `Helm`.  
```
helm repo add inseefrlab https://inseefrlab.github.io/helm-charts
helm install --generate-name inseefrlab/onyxia
```  

See https://github.com/inseefrlab/helm-charts for more details

## Related repositories  

### Services catalogs  

Onyxia relies on catalogs to provide users with a selection of services they can install in one click.  
You can either create your own repositories or use the default ones :

| Repository | Purpose | Status |
|---|---|---|
| [Helm charts datascience](https://github.com/inseefrlab/helm-charts-datascience)   | Datascience catalog using `Helm` (for `Kubernetes`) format  | :white_check_mark:  |
| [Universe datascience](https://github.com/inseefrlab/universe-datascience)   | Datascience catalog using `Universe` (for `DC/OS` / `Marathon`)  | :white_check_mark:  |  

### Docker images for services  

`InseeFRLab` maintains various `Docker` images that extends standard images so that they work nicely inside the datalab.  
You can browse them here : [Repositories using `docker-image` tag on `InseeFRLab`](https://github.com/search?q=topic%3Adocker-image+org%3AInseeFrLab+fork%3Atrue)  

### Cloudshell  

Onyxia integrates a `cloudshell` that is based on a `WebSSH` docker image.  
The docker image used is codenamed `Shelly` and is available here : [Shelly](https://github.com/inseefrlab/shelly)

### Infrastructure scripts  

The `cloud-scripts` repository is a collection of scripts we used at some point at `Insee`. They are provided as is with minimal to no documentation and support. They are, currently at least, used as memo and not production grade code.  
The repository is available here : [cloud-scripts](https://github.com/inseefrlab/cloud-scripts)