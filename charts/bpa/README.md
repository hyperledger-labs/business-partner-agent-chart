# bpa

![Version: 0.6.0-alpha02](https://img.shields.io/badge/Version-0.6.0--alpha02-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: sha-86b02ee6](https://img.shields.io/badge/AppVersion-sha--86b02ee6-informational?style=flat-square)

The Business Partner Agent allows to manage and exchange master data between organizations.

**Homepage:** <https://github.com/hyperledger-labs/business-partner-agent-chart>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| frank-bee | Frank.Bernhardt@bosch.com | https://github.com/frank-bee |
| parc-jason | jsherman@parcsystems.ca | https://github.com/parc-jason |
| Jsyro | jason.syrotuck@nttdata.com | https://github.com/Jsyro |

## Source Code

* <https://github.com/hyperledger-labs/business-partner-agent-chart>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami/ | postgresql | 10.3.13 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| acapy.adminURLApiKey | string | `"2f9729eef0be49608c1cffd49ee3cc4a"` |  |
| acapy.affinity | object | `{}` |  |
| acapy.agentSeed | string | `""` |  |
| acapy.fullnameOverride | string | `""` |  |
| acapy.image.pullPolicy | string | `"IfNotPresent"` |  |
| acapy.image.repository | string | `"bcgovimages/aries-cloudagent"` |  |
| acapy.image.tag | string | `"py36-1.16-0_0.6.0"` | Overrides the image tag whose default is the chart appVersion. |
| acapy.imagePullSecrets | list | `[]` |  |
| acapy.ingress.annotations | object | `{}` |  |
| acapy.ingress.enabled | bool | `true` |  |
| acapy.ingress.tls | list | `[]` |  |
| acapy.labelOverride | string | `""` |  |
| acapy.nameOverride | string | `""` |  |
| acapy.nodeSelector | object | `{}` |  |
| acapy.openshift.route.enabled | bool | `false` |  |
| acapy.openshift.route.path | string | `"/"` |  |
| acapy.openshift.route.targetPort | string | `"http"` |  |
| acapy.openshift.route.timeout | string | `"30s"` |  |
| acapy.openshift.route.tls.enabled | bool | `true` |  |
| acapy.openshift.route.tls.insecureEdgeTerminationPolicy | string | `"None"` |  |
| acapy.openshift.route.tls.termination | string | `"edge"` |  |
| acapy.openshift.route.wildcardPolicy | string | `"None"` |  |
| acapy.podAnnotations | object | `{}` |  |
| acapy.podSecurityContext | object | `{}` |  |
| acapy.readOnlyMode | bool | `false` |  |
| acapy.resources.requests.cpu | string | `"100m"` |  |
| acapy.resources.requests.memory | string | `"256Mi"` |  |
| acapy.securityContext.runAsUser | int | `1001` |  |
| acapy.service.adminPort | int | `8031` |  |
| acapy.service.httpPort | int | `8030` |  |
| acapy.service.type | string | `"ClusterIP"` |  |
| acapy.staticArgs.autoAcceptInvites | bool | `true` |  |
| acapy.staticArgs.autoAcceptRequests | bool | `true` |  |
| acapy.staticArgs.autoPingConnection | bool | `true` |  |
| acapy.staticArgs.autoProvision | bool | `true` |  |
| acapy.staticArgs.autoRespondCredentialOffer | bool | `true` |  |
| acapy.staticArgs.autoRespondCredentialProposal | bool | `true` |  |
| acapy.staticArgs.autoRespondCredentialRequest | bool | `true` |  |
| acapy.staticArgs.autoRespondMessages | bool | `true` |  |
| acapy.staticArgs.autoRespondPresentationProposal | bool | `true` |  |
| acapy.staticArgs.autoRespondPresentationRequest | bool | `true` |  |
| acapy.staticArgs.autoStoreCredential | bool | `true` |  |
| acapy.staticArgs.autoVerifyPresentation | bool | `true` |  |
| acapy.staticArgs.logLevel | string | `"info"` |  |
| acapy.staticArgs.monitorPing | bool | `true` |  |
| acapy.staticArgs.publicInvites | bool | `true` |  |
| acapy.tolerations | list | `[]` |  |
| bpa.affinity | object | `{}` |  |
| bpa.config.bootstrap.password | string | `"changeme"` |  |
| bpa.config.bootstrap.username | string | `"admin"` |  |
| bpa.config.creddef.revocationRegistrySize | int | `3000` |  |
| bpa.config.did.prefixOverride | string | `""` | Will be otherwise calculated based on global.ledger config |
| bpa.config.did.value | string | `""` |  |
| bpa.config.imprint.enabled | bool | `false` |  |
| bpa.config.imprint.url | string | `"{{ printf \"https://bpa%s/\" .Values.global.ingressSuffix }}"` |  |
| bpa.config.ledger.browserUrlOverride | string | `""` |  |
| bpa.config.name | string | `"{{ .Release.Name }}"` |  |
| bpa.config.privacyPolicy.enabled | bool | `false` |  |
| bpa.config.privacyPolicy.url | string | `"{{ printf \"https://bpa%s/privacyPolicy\" .Values.global.ingressSuffix }}"` |  |
| bpa.config.resolver.url | string | `"{{ printf \"https://resolver%s\" .Values.global.ingressSuffix }}"` |  |
| bpa.config.scheme | string | `"https"` |  |
| bpa.config.security.enabled | bool | `true` |  |
| bpa.config.web.only | bool | `false` |  |
| bpa.image.pullPolicy | string | `"IfNotPresent"` |  |
| bpa.image.repository | string | `"ghcr.io/hyperledger-labs/business-partner-agent"` |  |
| bpa.image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| bpa.imagePullSecrets | list | `[]` |  |
| bpa.ingress.annotations | object | `{}` |  |
| bpa.ingress.enabled | bool | `true` |  |
| bpa.ingress.tls | list | `[]` |  |
| bpa.nodeSelector | object | `{}` |  |
| bpa.openshift.route.enabled | bool | `false` |  |
| bpa.openshift.route.path | string | `"/"` |  |
| bpa.openshift.route.targetPort | string | `"http"` |  |
| bpa.openshift.route.timeout | string | `"30s"` |  |
| bpa.openshift.route.tls.enabled | bool | `true` |  |
| bpa.openshift.route.tls.insecureEdgeTerminationPolicy | string | `"None"` |  |
| bpa.openshift.route.tls.termination | string | `"edge"` |  |
| bpa.openshift.route.wildcardPolicy | string | `"None"` |  |
| bpa.podAnnotations | object | `{}` |  |
| bpa.podSecurityContext | object | `{}` |  |
| bpa.resources.requests.cpu | string | `"100m"` |  |
| bpa.resources.requests.memory | string | `"256Mi"` |  |
| bpa.securityContext | object | `{}` |  |
| bpa.service.port | int | `80` |  |
| bpa.service.type | string | `"ClusterIP"` |  |
| bpa.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| bpa.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| bpa.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| bpa.tolerations | list | `[]` |  |
| global.fullnameOverride | string | `""` |  |
| global.ingressSuffix | string | `".stage.economyofthings.io"` | Domain suffix to be used for default hostpaths in ingress |
| global.ledger | string | `"bosch-test"` | The used ledger. Will be used for default values. Any of: bosch-test, idu. |
| global.nameOverride | string | `""` |  |
| global.persistence.deployPostgres | bool | `true` | If true, the Postgres chart is deployed |
| keycloak.clientId | string | `"<your keycloak client id>"` |  |
| keycloak.clientSecret | string | `"<your keycloak client secret>"` |  |
| keycloak.config.endsessionUrl | string | `"<your keycloak realm end session url>"` |  |
| keycloak.config.issuer | string | `"<your keycloak realm issuer url>"` |  |
| keycloak.config.nameKey | string | `"preferred_username"` |  |
| keycloak.config.redirectUri | string | `"${bpa.scheme}://${bpa.host}/logout"` |  |
| keycloak.config.rolesName | string | `"roles"` |  |
| keycloak.config.scopes | string | `"openid"` |  |
| keycloak.enabled | bool | `false` |  |
| postgresql.containerSecurityContext.enabled | bool | `true` |  |
| postgresql.image.tag | int | `12` |  |
| postgresql.persistence | object | `{"enabled":false,"size":"1Gi","storageClass":"default"}` | Persistent Volume Storage configuration. ref: https://kubernetes.io/docs/user-guide/persistent-volumes |
| postgresql.persistence.enabled | bool | `false` | Enable PostgreSQL persistence using Persistent Volume Claims. |
| postgresql.postgresqlDatabase | string | `"bpa"` | PostgreSQL Database to create. |
| postgresql.postgresqlPassword | string | `"change-me"` | PostgreSQL Password for the new user. If not set, a random 10 characters password will be used. |
| postgresql.postgresqlUsername | string | `"postgres"` | PostgreSQL User to create. Do not change - otherwise non-admin user is created! |
| postgresql.resources.requests.cpu | string | `"100m"` |  |
| postgresql.resources.requests.memory | string | `"256Mi"` |  |
| postgresql.securityContext | object | `{"enabled":true}` | add securityContext (fsGroup, runAsUser). These need to be false for Openshift 4 |
| postgresql.service | object | `{"port":5432}` | PostgreSQL service configuration |
| schemas.config | object | `{}` |  |
| schemas.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)
