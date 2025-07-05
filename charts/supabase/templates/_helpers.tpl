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
