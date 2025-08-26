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
{{- if (index $Values $component).securityContext.pod }}
  {{- $securityContext = (index $Values $component).securityContext.pod }}
{{- else if $Values.global.securityContext.pod }}
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
{{- if hasKey $securityContext "allowPrivilegeEscalation" }}
  {{- $_ := set $validFields "allowPrivilegeEscalation" (get $securityContext "allowPrivilegeEscalation") }}
{{- end }}
{{- if hasKey $securityContext "readOnlyRootFilesystem" }}
  {{- $_ := set $validFields "readOnlyRootFilesystem" (get $securityContext "readOnlyRootFilesystem") }}
{{- end }}
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
{{- if (index $Values $component).securityContext.container }}
  {{- $securityContext = (index $Values $component).securityContext.container }}
{{- else if $Values.global.securityContext.container }}
  {{- $securityContext = $Values.global.securityContext.container }}
{{- end }}
{{- if $securityContext }}
{{- /* Filter out invalid container security context fields */ -}}
{{- $validFields := dict -}}
{{- /*
  Fields removed from container security context in modern Kubernetes:
  - allowPrivilegeEscalation (moved to pod level)
  - readOnlyRootFilesystem (moved to pod level)
  - capabilities (deprecated and removed)
*/ -}}
{{- if hasKey $securityContext "runAsNonRoot" }}
  {{- $_ := set $validFields "runAsNonRoot" (get $securityContext "runAsNonRoot") }}
{{- end }}
{{- if hasKey $securityContext "runAsUser" }}
  {{- $_ := set $validFields "runAsUser" (get $securityContext "runAsUser") }}
{{- end }}
{{- if hasKey $securityContext "runAsGroup" }}
  {{- $_ := set $validFields "runAsGroup" (get $securityContext "runAsGroup") }}
{{- end }}
{{- if hasKey $securityContext "privileged" }}
  {{- $_ := set $validFields "privileged" (get $securityContext "privileged") }}
{{- end }}
{{- /* seccompProfile is a pod-level field, not container-level */ -}}
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
  {{- with $ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
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
