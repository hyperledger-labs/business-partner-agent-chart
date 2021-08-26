### Examples


### Examples

Deploy BC Registries to Openshift DEV

```
export KEYCLOAK_CLIENT=bpa-mdt-team
export KEYCLOAK_CLIENT_SECRET=a1dcebce-ac3f-4a0c-9147-43845c58423b
#use INGRESS_SUFFIX, ISSUER_URL and END_SESSION_URL defaults from values-bcgov.yaml

helm upgrade charlie bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Charlie" \
  --set keycloak.clientId=$KEYCLOAK_CLIENT \
  --set keycloak.clientSecret=$KEYCLOAK_CLIENT_SECRET \


```


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

helm upgrade mdt-team-test bpa -f values-bcgov.yaml --install \
  --set bpa.config.name="MDT Team" \
  --set ux.preset=custom \
  --set ux.config.theme.themes.light.primary="#549F43" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set keycloak.clientId=bpa-mdt-team \
  --set keycloak.clientSecret=4498b8e1-1c8d-4c90-a89f-07f7873827c0 \
  --set keycloak.config.issuer=$ISSUER_URL \
  --set keycloak.config.endsessionUrl=$END_SESSION_URL

```



export INGRESS_SUFFIX=-test.apps.silver.devops.gov.bc.ca


helm upgrade sovrin-staging-1 bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Sovrin-Staging 1" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set bpa.config.security.enabled=false\
  --set keycloak.enabled=false \
  --set bpa.ledger.browserUrlOverride="https://indyscan.io/home/SOVRIN_STAGINGNET/" \
  --set bpa.ledger.genesisUrlOverride="https://raw.githubusercontent.com/sovrin-foundation/sovrin/stable/sovrin/pool_transactions_sandbox_genesis" 


helm upgrade sovrin-staging-2 bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Sovrin-Staging 2" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set bpa.config.security.enabled=false\
  --set keycloak.enabled=false \
  --set bpa.ledger.browserUrlOverride="https://indyscan.io/home/SOVRIN_STAGINGNET/" \
  --set bpa.ledger.genesisUrlOverride="https://raw.githubusercontent.com/sovrin-foundation/sovrin/stable/sovrin/pool_transactions_sandbox_genesis" 


helm upgrade uat2 bpa -f bpa/values-bcgov.yaml --install \
  --set bpa.config.name="Uat2" \
  --set global.ingressSuffix=$INGRESS_SUFFIX \
  --set bpa.config.security.enabled=false\
  --set keycloak.enabled=false 

