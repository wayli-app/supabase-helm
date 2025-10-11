{{/*
Expand the name of the chart.
*/}}
{{- define "supabase.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "supabase.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
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
{{- define "supabase.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "supabase.labels" -}}
helm.sh/chart: {{ include "supabase.chart" . }}
{{ include "supabase.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "supabase.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "supabase.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "supabase.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the namespace to use
*/}}
{{- define "supabase.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Create a service template
*/}}
{{- define "supabase.service" -}}
{{- $component := .component -}}
{{- $service := .service -}}
{{- $ports := .ports -}}
{{- $extraAnnotations := .extraAnnotations -}}
{{- $Values := .Values -}}
{{- $Release := .Release -}}
{{- $Chart := .Chart -}}
{{- if (index $Values $component).enabled }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "supabase.fullname" (dict "Values" $Values "Release" $Release "Chart" $Chart) }}-{{ $component }}
  namespace: {{ include "supabase.namespace" (dict "Values" $Values "Release" $Release "Chart" $Chart) }}
  labels:
    {{- include "supabase.labels" (dict "Values" $Values "Release" $Release "Chart" $Chart) | nindent 4 }}
    app.kubernetes.io/component: {{ $component }}
  {{- if $extraAnnotations }}
  annotations:
    {{- toYaml $extraAnnotations | nindent 4 }}
  {{- end }}
spec:
  type: {{ $service.type }}
  ports:
    {{- range $ports }}
    - port: {{ .port }}
      targetPort: {{ .targetPort }}
      protocol: {{ .protocol }}
      {{- if .name }}
      name: {{ .name }}
      {{- end }}
    {{- end }}
  selector:
    {{- include "supabase.selectorLabels" (dict "Values" $Values "Release" $Release "Chart" $Chart) | nindent 4 }}
    app.kubernetes.io/component: {{ $component }}
{{- end }}
{{- end }}

{{/*
Create security context template for pods
*/}}
{{- define "supabase.podSecurityContext" -}}
{{- $component := .component -}}
{{- $Values := .Values -}}
{{- $securityContext := dict -}}
{{- $componentValues := index $Values $component -}}
{{- if and $componentValues (hasKey $componentValues "securityContext") $componentValues.securityContext.pod }}
  {{- $securityContext = $componentValues.securityContext.pod }}
{{- else if and $Values.global (hasKey $Values.global "securityContext") $Values.global.securityContext.pod }}
  {{- $securityContext = $Values.global.securityContext.pod }}
{{- end }}
{{- if $securityContext }}
{{- /* Filter out invalid pod security context fields */ -}}
{{- $validFields := dict -}}
{{- if hasKey $securityContext "runAsNonRoot" }}
  {{- $_ := set $validFields "runAsNonRoot" (get $securityContext "runAsNonRoot") }}
{{- end }}
{{- if hasKey $securityContext "runAsUser" }}
  {{- $_ := set $validFields "runAsUser" (get $securityContext "runAsUser") }}
{{- end }}
{{- if hasKey $securityContext "runAsGroup" }}
  {{- $_ := set $validFields "runAsGroup" (get $securityContext "runAsGroup") }}
{{- end }}
{{- if hasKey $securityContext "fsGroup" }}
  {{- $_ := set $validFields "fsGroup" (get $securityContext "fsGroup") }}
{{- end }}
{{- if hasKey $securityContext "fsGroupChangePolicy" }}
  {{- $_ := set $validFields "fsGroupChangePolicy" (get $securityContext "fsGroupChangePolicy") }}
{{- end }}
{{- /* supplementalGroups deprecated - replaced with fsGroupChangePolicy */ -}}
{{- if hasKey $securityContext "seccompProfile" }}
  {{- $_ := set $validFields "seccompProfile" (get $securityContext "seccompProfile") }}
{{- end }}
{{- /*
  Fields that belong in container security context, not pod:
  - allowPrivilegeEscalation
  - readOnlyRootFilesystem
*/ -}}
{{- toYaml $validFields | nindent 8 }}
{{- end }}
{{- end }}

{{/*
Create security context template for containers
*/}}
{{- define "supabase.containerSecurityContext" -}}
{{- $component := .component -}}
{{- $Values := .Values -}}
{{- $securityContext := dict -}}
{{- $componentValues := index $Values $component -}}
{{- if and $componentValues (hasKey $componentValues "securityContext") $componentValues.securityContext.container }}
  {{- $securityContext = $componentValues.securityContext.container }}
{{- else if and $Values.global (hasKey $Values.global "securityContext") $Values.global.securityContext.container }}
  {{- $securityContext = $Values.global.securityContext.container }}
{{- end }}
{{- if $securityContext }}
{{- /* Filter out invalid container security context fields */ -}}
{{- $validFields := dict -}}
{{- /*
  MODERN KUBERNETES: Most security context fields have been moved to pod level.
  Container level now only supports a very limited set of fields.
*/ -}}
{{- /*
  Fields intentionally excluded from container level (moved to pod level):
  - runAsNonRoot (pod level only)
  - runAsUser, runAsGroup (pod level only)
  - allowPrivilegeEscalation (pod level only)
  - readOnlyRootFilesystem (pod level only)
  - seccompProfile (pod level only)

  Container level now only supports:
  - privileged (if absolutely necessary)
  - capabilities (deprecated but still technically supported)
*/ -}}
{{- if hasKey $securityContext "privileged" }}
  {{- $_ := set $validFields "privileged" (get $securityContext "privileged") }}
{{- end }}
{{- /*
  Note: In modern Kubernetes, most security context configuration
  should be done at the pod level for better compatibility.
*/ -}}
{{- toYaml $validFields | nindent 10 }}
{{- end }}
{{- end }}

{{/*
Create an ingress template
*/}}
{{- define "supabase.ingress" -}}
{{- $component := .component -}}
{{- $ingress := .ingress -}}
{{- $Values := .Values -}}
{{- $Release := .Release -}}
{{- $Chart := .Chart -}}
{{- if and (index $Values $component).enabled $ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "supabase.fullname" (dict "Values" $Values "Release" $Release "Chart" $Chart) }}-{{ $component }}
  namespace: {{ include "supabase.namespace" (dict "Values" $Values "Release" $Release "Chart" $Chart) }}
  labels:
    {{- include "supabase.labels" (dict "Values" $Values "Release" $Release "Chart" $Chart) | nindent 4 }}
    app.kubernetes.io/component: {{ $component }}
    {{- with $ingress.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- if or $ingress.annotations (eq $component "kong") }}
  annotations:
    {{- if eq $component "kong" }}
    nginx.org/websocket-services: {{ include "supabase.fullname" (dict "Values" $Values "Release" $Release "Chart" $Chart) }}-kong
    {{- end }}
    {{- with $ingress.annotations }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
spec:
  {{- if $ingress.ingressClassName }}
  ingressClassName: {{ $ingress.ingressClassName }}
  {{- end }}
  rules:
    {{- if $ingress.hostname }}
    - host: {{ $ingress.hostname }}
      http:
        paths:
          - path: {{ $ingress.path }}
            pathType: {{ $ingress.pathType }}
            backend:
              service:
                name: {{ include "supabase.fullname" (dict "Values" $Values "Release" $Release "Chart" $Chart) }}-{{ $component }}
                port:
                  number: {{ (index $Values $component).service.port }}
    {{- end }}
    {{- with $ingress.extraRules }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- if or $ingress.tls $ingress.extraTls }}
  tls:
    {{- with $ingress.tls }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- with $ingress.extraTls }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Create image reference with optional global imageRegistry prefix
Usage: {{ include "supabase.image" (dict "imageRoot" .Values.component.image "global" .Values.global) }}
*/}}
{{- define "supabase.image" -}}
{{- $imageRoot := .imageRoot -}}
{{- $global := .global -}}
{{- $registry := "" -}}
{{- if $global.imageRegistry -}}
  {{- $registry = printf "%s/" $global.imageRegistry -}}
{{- end -}}
{{- printf "%s%s:%s" $registry $imageRoot.repository $imageRoot.tag -}}
{{- end -}}

{{/*
Return the database secret name with fallback to global secret
Usage: {{ include "supabase.dbSecretName" . }}
*/}}
{{- define "supabase.dbSecretName" -}}
{{- if .Values.db.postgres.existingSecret -}}
  {{- .Values.db.postgres.existingSecret -}}
{{- else if .Values.global.supabase.existingSecret -}}
  {{- .Values.global.supabase.existingSecret -}}
{{- else -}}
  {{- printf "%s-db-secret" (include "supabase.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper imagePullSecrets
Usage: {{ include "supabase.imagePullSecrets" (dict "component" .Values.component "global" .Values.global) }}
*/}}
{{- define "supabase.imagePullSecrets" -}}
{{- $component := .component -}}
{{- $global := .global -}}
{{- $pullSecrets := list -}}

{{- if $component.imagePullSecrets -}}
  {{- $pullSecrets = $component.imagePullSecrets -}}
{{- else if $global.imagePullSecrets -}}
  {{- $pullSecrets = $global.imagePullSecrets -}}
{{- end -}}

{{- if $pullSecrets -}}
imagePullSecrets:
  {{- toYaml $pullSecrets | nindent 2 -}}
{{- end -}}
{{- end -}}

{{/*
Return the database host to connect to (pgbouncer or postgres direct)
Usage: {{ include "supabase.databaseHost" . }}
*/}}
{{- define "supabase.databaseHost" -}}
{{- if .Values.db.pgbouncer.enabled -}}
  {{- .Values.db.pgbouncer.service.name | default (printf "%s-pgbouncer" (include "supabase.fullname" .)) -}}
  {{- if .Values.db.pgbouncer.service.namespace -}}.{{ .Values.db.pgbouncer.service.namespace }}{{- end -}}
{{- else -}}
  {{- .Values.db.postgres.service.name | default (printf "%s-db" (include "supabase.fullname" .)) -}}
  {{- if .Values.db.postgres.service.namespace -}}.{{ .Values.db.postgres.service.namespace }}{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the database port to connect to (pgbouncer or postgres direct)
Usage: {{ include "supabase.databasePort" . }}
*/}}
{{- define "supabase.databasePort" -}}
{{- if .Values.db.pgbouncer.enabled -}}
  {{- .Values.db.pgbouncer.service.port | default 5432 -}}
{{- else -}}
  {{- .Values.db.postgres.service.port | default 5432 -}}
{{- end -}}
{{- end -}}

{{/*
PgBouncer selector labels
*/}}
{{- define "supabase.selectorLabels.pgbouncer" -}}
app.kubernetes.io/name: {{ include "supabase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: pgbouncer
{{- end -}}

{{/*
Return the pgbouncer image
*/}}
{{- define "supabase.pgbouncer.image" -}}
{{- $registry := "" -}}
{{- if .Values.global.imageRegistry -}}
  {{- $registry = printf "%s/" .Values.global.imageRegistry -}}
{{- end -}}
{{- printf "%s%s:%s" $registry .Values.db.pgbouncer.image.repository .Values.db.pgbouncer.image.tag -}}
{{- end -}}

{{/*
Return the database host that pgbouncer should connect to
*/}}
{{- define "supabase.pgbouncer.dbHost" -}}
{{- .Values.db.pgbouncer.database.host | default (printf "%s-db" (include "supabase.fullname" .)) -}}
{{- end -}}

{{/*
Return the database port that pgbouncer should connect to
*/}}
{{- define "supabase.pgbouncer.dbPort" -}}
{{- .Values.db.pgbouncer.database.port | default (.Values.db.postgres.service.port | default 5432) -}}
{{- end -}}

{{/*
Return the database user that pgbouncer should use
*/}}
{{- define "supabase.pgbouncer.dbUser" -}}
{{- .Values.db.pgbouncer.database.user | default "postgres" -}}
{{- end -}}

{{/*
Return the Supabase secret name
*/}}
{{- define "supabase.supabaseSecretName" -}}
{{- .Values.global.supabase.existingSecret | default (printf "%s-secret" (include "supabase.fullname" .)) -}}
{{- end -}}
