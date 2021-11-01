{{/*
Expand the name of the chart.
*/}}
{{- define "global.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "global.fullname" -}}
{{- if .Values.global.fullnameOverride }}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.global.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "global.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified bpa name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "bpa.fullname" -}}
{{ template "global.fullname" . }}-core
{{- end -}}

{{/*
Create a default fully qualified acapy name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "acapy.fullname" -}}
{{ template "global.fullname" . }}-acapy
{{- end -}}

{{/*
Common bpa labels
*/}}
{{- define "bpa.labels" -}}
helm.sh/chart: {{ include "global.chart" . }}
{{ include "bpa.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector bpa labels
*/}}
{{- define "bpa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "global.fullname" . }}-core
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bpa.serviceAccountName" -}}
{{- if .Values.bpa.serviceAccount.create }}
{{- default (include "bpa.fullname" .) .Values.bpa.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.bpa.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
generate hosts if not overriden
*/}}
{{- define "bpa.host" -}}
{{- if .Values.bpa.ingress.hosts -}}
{{- (index .Values.bpa.ingress.hosts 0).host -}}
{{- else }}
{{- include "global.fullname" . }}{{ .Values.global.ingressSuffix -}}
{{- end -}}
{{- end }}

{{/*
generate ledger browser url
*/}}
{{- define "bpa.ledgerBrowser" -}}
{{- $ledgerBrowser := dict "bosch-test" "https://indy-test.bosch-digital.de" "idu" "https://explorer.idu.network" "bcovrin-test" "http://test.bcovrin.vonx.io" -}}
{{ .Values.bpa.config.ledger.browserUrlOverride | default ( get $ledgerBrowser .Values.global.ledger ) }}
{{- end }}

{{/*
generate genesisfileurl
*/}}
{{- define "bpa.genesisUrl" -}}
{{ default (printf "%s%s" (include "bpa.ledgerBrowser" .) "/genesis") .Values.bpa.config.ledger.genesisUrlOverride }}
{{- end }}


{{/*
Common acapy labels
*/}}
{{- define "acapy.labels" -}}
helm.sh/chart: {{ include "global.chart" . }}
{{ include "acapy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector acapy labels
*/}}
{{- define "acapy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "global.fullname" . }}-acapy
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
generate hosts if not overriden
*/}}
{{- define "acapy.host" -}}
{{- if .Values.acapy.ingress.hosts -}}
{{- (index .Values.acapy.ingress.hosts 0).host -}}
{{- else }}
{{- include "acapy.fullname" . }}{{ .Values.global.ingressSuffix -}}
{{- end -}}
{{- end }}

{{/*
Get the password secret.
*/}}
{{- define "acapy.secretName" -}}
{{- if .Values.acapy.existingSecret -}}
    {{- printf "%s" (tpl .Values.acapy.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "acapy.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if we should use an existingSecret.
*/}}
{{- define "acapy.useExistingSecret" -}}
{{- if .Values.existingSecret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "acapy.createSecret" -}}
{{- if not (include "acapy.useExistingSecret" .) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return seed
*/}}
{{- define "acapy.seed" -}}
{{- if .Values.acapy.agentSeed -}}
    {{- .Values.acapy.agentSeed -}}
{{- else -}}
    {{- randAlphaNum 32 -}}
{{- end -}}
{{- end -}}

{{/*
Return acapy initialization call
*/}}
{{- define "acapy.registerLedger" -}}
{{- if or (eq .Values.global.ledger "bosch-test") (eq .Values.global.ledger "bcovrin-test") -}}
curl -d '{\"seed\":\"$(WALLET_SEED)\", \"role\":\"TRUST_ANCHOR\", \"alias\":\"{{ include "bpa.fullname" . }}\"}' -X POST {{ include "bpa.ledgerBrowser" . }}/register;
{{- else if eq .Values.global.ledger "idu" -}}
identifier=`curl --header 'Content-Type: application/json' -d '{\"seed\":\"$(WALLET_SEED)\", \"role\":\"ENDORSER\", \"send\":true}' -X POST node-agent-registrar.md.svc.cluster.local/register | tr { '\n' | tr , '\n' | tr } '\n' | grep \"identifier\" | awk  -F'\"' '{print $4}'`;
{{- end -}}
{{- end -}}

{{/*
Return acapy label
*/}}
{{- define "acapy.label" -}}
{{- if .Values.acapy.labelOverride -}}
    {{- .Values.acapy.labelOverride }}
{{- else if eq .Values.global.ledger "idu" -}}
$identifier   
{{- else -}} 
    {{- .Release.Name }}     
{{- end -}}
{{- end -}}

{{/*
generate tails baseUrl
*/}}
{{- define "acapy.tails.baseUrl" -}}
{{- $tailsBaseUrl := dict "bosch-test" "https://tails-dev.vonx.io" "bcovrin-test" "https://tails-test.vonx.io" "idu" (printf "https://tails%s" .Values.global.ingressSuffix) -}}
{{ .Values.acapy.tails.baseUrlOverride| default ( get $tailsBaseUrl .Values.global.ledger ) }}
{{- end }}

{{/*
generate tails uploadUrl
*/}}
{{- define "acapy.tails.uploadUrl" -}}
{{- $tailsUploadUrl:= dict "bosch-test" "https://tails-dev.vonx.io" "bcovrin-test" "https://tails-test.vonx.io" "idu" "http://idu-tails:6543" -}}
{{ .Values.acapy.tails.uploadUrlOverride| default ( get $tailsUploadUrl .Values.global.ledger ) }}
{{- end }}

{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "global.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ template "postgresql.primary.fullname" $postgresContext }}
{{- end -}}

{{/*
Create the name for the database secret.
*/}}
{{- define "global.externalDbSecret" -}}
{{- if .Values.global.persistence.existingSecret -}}
  {{- .Values.global.persistence.existingSecret -}}
{{- else -}}
  {{- template "global.fullname" . -}}-db
{{- end -}}
{{- end -}}

{{/*
Create the name for the password secret key.
*/}}
{{- define "global.dbPasswordKey" -}}
{{- if .Values.global.persistence.existingSecret -}}
  {{- .Values.global.persistence.existingSecretKey -}}
{{- else -}}
  password
{{- end -}}
{{- end -}}

{{/*
Create environment variables for database configuration.
*/}}
{{- define "global.externalDbConfig" -}}
- name: DB_VENDOR
  value: {{ .Values.global.persistence.dbVendor | quote }}
{{- if eq .Values.global.persistence.dbVendor "POSTGRES" }}
- name: POSTGRES_PORT_5432_TCP_ADDR
  value: {{ .Values.global.persistence.dbHost | quote }}
- name: POSTGRES_PORT_5432_TCP_PORT
  value: {{ .Values.global.persistence.dbPort | quote }}
- name: POSTGRES_USER
  value: {{ .Values.global.persistence.dbUser | quote }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "global.externalDbSecret" . }}
      key: {{ include "global.dbPasswordKey" . | quote }}
- name: POSTGRES_DATABASE
  value: {{ .Values.global.persistence.dbName | quote }}
{{- else if eq .Values.global.persistence.dbVendor "MYSQL" }}
- name: MYSQL_PORT_3306_TCP_ADDR
  value: {{ .Values.global.persistence.dbHost | quote }}
- name: MYSQL_PORT_3306_TCP_PORT
  value: {{ .Values.global.persistence.dbPort | quote }}
- name: MYSQL_USER
  value: {{ .Values.global.persistence.dbUser | quote }}
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "global.externalDbSecret" . }}
      key: {{ include "global.dbPasswordKey" . | quote }}
- name: MYSQL_DATABASE
  value: {{ .Values.global.persistence.dbName | quote }}
{{- end }}
{{- end -}}


{{/*
Return JAVA_OPTS -Dmicronaut.config.files
Always return application.yml add in other files if they are enabled.
*/}}
{{- define "bpa.config.files" -}}
{{- $configFiles := list "classpath:application.yml"}}
{{- if .Values.schemas.enabled -}}
{{- $configFiles = append $configFiles "/home/indy/schemas.yml" -}}
{{- end -}}
{{- if eq (include "bpa.ux.override" .) "true" -}}
{{- $configFiles = append $configFiles "/home/indy/ux.yml" -}}
{{- end -}}
{{- if .Values.keycloak.enabled -}}
{{- $configFiles = append $configFiles "classpath:security-keycloak.yml" -}}
{{- end -}}
{{- join "," $configFiles -}}
{{- end -}}

{{/*
If Keycloak is enabled, add the client id and secret from the keycloak secret to bpa env
*/}}
{{- define "bpa.keycloak.secret.env.vars" -}}
{{- if (.Values.keycloak.enabled) -}}
- name: BPA_KEYCLOAK_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ template "global.fullname" . }}-keycloak
      key: clientSecret
{{- end -}}
{{- end -}}

{{/*
If Keycloak is enabled, mount the keycloak config map as env vars
We don't need envFrom because we always load application configmap...
*/}}
{{- define "bpa.keycloak.configmap.env.vars" -}}
{{- if (.Values.keycloak.enabled) -}}
- configMapRef:
    name: {{ template "bpa.fullname" . }}-keycloak
{{- end -}}
{{- end -}}

{{/*
Mount the application config map as env vars
*/}}
{{- define "bpa.application.configmap.env.vars" -}}
envFrom:
  - configMapRef:
      name: {{ template "bpa.fullname" . }}
{{- end -}}

{{/*
Are we overriding the UX?
*/}}
{{- define "bpa.ux.override" -}}
{{- if ne .Values.ux.preset "default" -}}
{{- printf "true" }}
{{- else -}}
{{- printf "false" }}
{{- end -}}
{{- end -}}

{{/*
If schemas or ux is enabled, create a volumes for the config maps
*/}}
{{- define "bpa.volumes" -}}
{{- if or (.Values.schemas.enabled) (eq (include "bpa.ux.override" .) "true") -}}
volumes:
{{- end -}}
{{- end -}}

{{/*
If schemas is enabled, create a volume for the config maps
*/}}
{{- define "bpa.volumes.schemas" -}}
{{- if (.Values.schemas.enabled) -}}
- name: config-schemas
  configMap:
    name: {{ template "bpa.fullname" . }}-schemas
    items:
    - key: "schemas.yml"
      path: "schemas.yml"
{{- end -}}
{{- end -}}

{{/*
If ux is enabled, create a volume for the config maps
*/}}
{{- define "bpa.volumes.ux" -}}
{{- if eq (include "bpa.ux.override" .) "true" -}}
- name: config-ux
  configMap:
    name: {{ template "bpa.fullname" . }}-ux
    items:
    - key: "ux.yml"
      path: "ux.yml"
{{- end -}}
{{- end -}}


{{/*
If schemas or ux is enabled, create a volume mounts for the config maps
*/}}
{{- define "bpa.volume.mounts" -}}
{{- if or (.Values.schemas.enabled) (eq (include "bpa.ux.override" .) "true") -}}
volumeMounts:
{{- end -}}
{{- end -}}

{{/*
If schemas is enabled, create a volume mount
*/}}
{{- define "bpa.volume.mounts.schemas" -}}
{{- if (.Values.schemas.enabled) -}}
- name: config-schemas
  mountPath: "/home/indy/schemas.yml"
  subPath: "schemas.yml"
  readOnly: true
{{- end -}}
{{- end -}}

{{/*
If ux is enabled, create a volume mount
*/}}
{{- define "bpa.volume.mounts.ux" -}}
{{- if eq (include "bpa.ux.override" .) "true" -}}
- name: config-ux
  mountPath: "/home/indy/ux.yml"
  subPath: "ux.yml"
  readOnly: true
{{- end -}}
{{- end -}}

{{- define "bpa.openshift.route.tls" -}}
{{- if (.Values.bpa.openshift.route.tls.enabled) -}}
tls:
  insecureEdgeTerminationPolicy: {{ .Values.bpa.openshift.route.tls.insecureEdgeTerminationPolicy }}
  termination: {{ .Values.bpa.openshift.route.tls.termination }}
{{- end -}}
{{- end -}}

{{- define "acapy.openshift.route.tls" -}}
{{- if (.Values.acapy.openshift.route.tls.enabled) -}}
tls:
  insecureEdgeTerminationPolicy: {{ .Values.acapy.openshift.route.tls.insecureEdgeTerminationPolicy }}
  termination: {{ .Values.acapy.openshift.route.tls.termination }}
{{- end -}}
{{- end -}}

{{/*
Set the Business Partner Agent name
*/}}
{{- define "business.partner.agent.name" -}}
{{- $name := camelcase .Release.Name }}
{{- if .Values.bpa.config.nameOverride -}}
{{- $name = (tpl .Values.bpa.config.nameOverride .) -}}
{{- end -}}
{{- $name -}}
{{- end -}}


{{/*
Set the Business Partner Agent Browser Title value.
*/}}
{{- define "business.partner.browser.title" -}}
{{- $title := camelcase .Release.Name }}
{{- if .Values.bpa.config.nameOverride -}}
{{- $title = (tpl .Values.bpa.config.nameOverride .) -}}
{{- end -}}
{{- if .Values.bpa.config.titleOverride -}}
{{- $title = (tpl .Values.bpa.config.titleOverride .) -}}
{{- end -}}
{{- $title -}}
{{- end -}}

