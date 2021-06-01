# Business Partner Agent Chart

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/business-partner-agent)](https://artifacthub.io/packages/search?repo=business-partner-agent)

The Business Partner Agent allows to manage and exchange master data between organizations.

This chart will install a business partner agent (bpa-core & bpa-acapy) and Postgres.

It will also create the default ingress routes.

## TL;DR

```sh
helm repo add bpa https://labs.hyperledger.org/business-partner-agent-chart/
helm repo update
helm upgrade \
	--set global.ingressSuffix=.example.com \
   	mybpa bpa/bpa -i -n mynamespace --devel
```

## The Chart

Find the chart source and further documentation in [./charts/bpa](./charts/bpa).

## Chart development

### Release a chart

Create a PR with your changes including an updated version and appVersion number in charts/bpa/Chart.yaml.

`appVersion` must be equal to the docker image tag used for the bpa image.

`version` is typically the same.

Both incremented version numbers should adhere to the Semantic Versioning Specification based on the changes since the last published release.

A new tag and GitHub release will be created automatically by a github workflow. Charts in the charts folder will be automatically deployed to a repository hosted on github pages.

The workflow also includes a `helm lint` step and will do a `helm test` in the future (already prepared).

### See also 

[Example project](https://github.com/helm/charts-repo-actions-demo) to demo testing and hosting a chart repository with GitHub Pages and Actions.
