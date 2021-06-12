# Business Partner Agent

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/business-partner-agent)](https://artifacthub.io/packages/search?repo=business-partner-agent)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/hyperledger-labs/business-partner-agent-chart)

The [Business Partner Agent](https://github.com/hyperledger-labs/business-partner-agent/) allows to manage and exchange master data between organizations.

This chart will install a business partner agent (bpa-core & bpa-acapy) and Postgres.

## TL;DR

```sh
helm repo add bpa https://labs.hyperledger.org/business-partner-agent-chart/
helm repo update
helm upgrade \
	--set global.ingressSuffix=.example.com \
   	mybpa bpa/bpa -i -n mynamespace
```

## The Chart

Find the chart source and further documentation in subfolder [./charts/bpa](./charts/bpa).

## Chart development

See [Issues labled with `helm`](https://github.com/hyperledger-labs/business-partner-agent/labels/helm) and [Publishing docu](https://github.com/hyperledger-labs/business-partner-agent/blob/master/PUBLISHING.md) in our [main repository](https://github.com/hyperledger-labs/business-partner-agent/).

### Generate chart docu

The tool helm-docs parses metadata from charts and generates a number of sub-templates that can be referenced in a template file `README.md.gotmpl`.

If you work in a our gitpod workspace, helm-docs runs automatically if the templates have changed via pre-commit-hook.
On your local machine run
```
docker run --rm --volume "$(pwd):/helm-docs" -u $(id -u) jnorwood/helm-docs:latest
```

### Linting

On your local machine run
```
docker run -it --rm --name ct --volume $(pwd):/data quay.io/helmpack/chart-testing sh -c "cd /data; ct lint --config ct.yaml"
```

### Testing

Install ct locally and configure your cluster with kubectl.
The following call will create an ephemeral namespace, install the chart with default values and run the helm tests.
`ct install --config ct.yaml --all`
