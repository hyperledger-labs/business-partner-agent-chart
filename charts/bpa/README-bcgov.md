### Examples

Deploy BC Registries to Openshift Test

```
export INGRESS_SUFFIX=-test.apps.silver.devops.gov.bc.ca
export KEYCLOAK_CLIENT_SECRET=9fc29bf5-1e50-4ae3-9b69-f4cf6ebd0c4a
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
