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
{{- $ledgerBrowser := dict "bosch-test" "https://indy-test.bosch-digital.de" "idu" "https://explorer.idu.network" -}}
{{ .Values.bpa.config.ledger.browserUrlOverride | default ( get $ledgerBrowser .Values.global.ledger ) }}
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
Return didPrefix
*/}}
{{- define "acapy.didPrefix" -}}
{{- get (dict "bosch-test" "did:sov:iil:" "idu" "did:sov:idu:") .Values.global.ledger -}}
{{- end -}}

{{/*
Return acapy initialization call
*/}}
{{- define "acapy.registerLedger" -}}
{{- if eq .Values.global.ledger "bosch-test" -}}
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
*/}}
{{- define "bpa.config.files" -}}
{{- if and .Values.keycloak.enabled .Values.schemas.enabled -}}
    classpath:application.yml,/home/indy/schemas.yml,classpath:security-keycloak.yml
{{- else if .Values.keycloak.enabled  -}}
    classpath:application.yml,classpath:security-keycloak.yml
{{- else if .Values.schemas.enabled -}}
    classpath:application.yml,/home/indy/schemas.yml
{{- else -}}
    classpath:application.yml    
{{- end -}}
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
If schemas is enabled, create a volume for the config map
*/}}
{{- define "bpa.schemas.volume" -}}
{{- if (.Values.schemas.enabled) -}}
volumes:
  - name: config
    configMap:
      name: {{ template "bpa.fullname" . }}-schemas
      items:
      - key: "schemas.yml"
        path: "schemas.yml"
{{- end -}}
{{- end -}}

{{/*
If schemas is enabled, create a volume mount for the config map
*/}}
{{- define "bpa.schemas.volume.mount" -}}
{{- if (.Values.schemas.enabled) -}}
volumeMounts:
- name: config
  mountPath: "/home/indy/schemas.yml"
  subPath: "schemas.yml"
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
