### Examples


### Examples

Deploy BC Registries to Openshift DEV

```
export KEYCLOAK_CLIENT=bpa-mdt-team
export KEYCLOAK_CLIENT_SECRET=a1dcebce-ac3f-4a0c-9147-43845c58423b
#use INGRESS_SUFFIX, ISSUER_URL and END_SESSION_URL defaults from values-bcgov.yaml

helm upgrade bravo bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Bravo" \
  --set keycloak.clientId=$KEYCLOAK_CLIENT \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \


```


Deploy BC Registries to Openshift Test

```
export INGRESS_SUFFIX=-test.apps.silver.devops.gov.bc.ca
export KEYCLOAK_CLIENT_SECRET=<get from the keycloak realm and specific client>
export ISSUER_URL=https://test.oidc.gov.bc.ca/auth/realms/digitaltrust
export END_SESSION_URL=https://test.oidc.gov.bc.ca/auth/realms/digitaltrust/protocol/openid-connect/logout

helm upgrade bcregistries bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="BC Registries" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

helm upgrade emli bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Ministry of Energy\, Mines and Low Carbon Innovation" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

helm upgrade pwc bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Pricewaterhouse Coopers" \
  --set ux.preset=custom \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

helm upgrade coppermountain bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Copper Mountain Mining Corporation" \
  --set ux.preset=custom \
  --set ux.config.theme.themes.light.primary="#18D5E3" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

helm upgrade purchaser bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Purchaser of Materials" \
  --set ux.preset=custom \
  --set ux.config.theme.themes.light.primary="#549F43" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

```
