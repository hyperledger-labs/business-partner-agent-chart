### Examples

Deploy BC Registries to Openshift Test

```
export INGRESS_SUFFIX=-test.apps.silver.devops.gov.bc.ca
export KEYCLOAK_CLIENT_ID=bbcm
export KEYCLOAK_CLIENT_SECRET=605c2782-e564-45f1-a69f-b0a6803524a8
export ISSUER_URL=https://test.oidc.gov.bc.ca/auth/realms/digitaltrust
export END_SESSION_URL=https://test.oidc.gov.bc.ca/auth/realms/digitaltrust/protocol/openid-connect/logout


helm upgrade gov bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Government" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientId=$KEYCLOAK_CLIENT_ID \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

helm upgrade producer bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Producer of Raw Materials" \
  --set ux.preset=custom \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientId=$KEYCLOAK_CLIENT_ID \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

helm upgrade external-verifier bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="External Verifier" \
  --set ux.preset=custom \
  --set ux.config.theme.themes.light.primary="#18D5E3" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientId=$KEYCLOAK_CLIENT_ID \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

helm upgrade purchaser bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Purchaser of Raw Materials" \
  --set ux.preset=custom \
  --set ux.config.theme.themes.light.primary="#549F43" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientId=$KEYCLOAK_CLIENT_ID \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

# BPA uses different client for VC Authn IDP

helm upgrade mdt-team bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="MDT Team" \
  --set ux.preset=custom \
  --set ux.config.theme.themes.light.primary="#549F43" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientId=bpa-mdt-team \
  --set keycloak.clientSecret=4498b8e1-1c8d-4c90-a89f-07f7873827c0 \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

```
