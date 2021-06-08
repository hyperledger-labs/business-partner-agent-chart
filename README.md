# Business Partner Agent

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/business-partner-agent)](https://artifacthub.io/packages/search?repo=business-partner-agent)

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

See [Issues labled with `Infrastructure`](https://github.com/hyperledger-labs/business-partner-agent/issues?q=is%3Aissue+is%3Aopen+label%3Ainfrastructure) and [Publishing docu](https://github.com/hyperledger-labs/business-partner-agent/blob/master/PUBLISHING.md) in our [main repository](https://github.com/hyperledger-labs/business-partner-agent/).
