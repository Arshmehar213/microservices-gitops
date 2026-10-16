{{/*
Expand the name of the chart.
*/}}
{{- define "microservices.fullname" -}}
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
Common labels.
*/}}
{{- define "microservices.labels" -}}
helm.sh/chart: {{ include "microservices.chart" . }}
{{ include "microservices.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Values.global.partOf | default "microservices" }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "microservices.selectorLabels" -}}
app.kubernetes.io/name: {{ include "microservices.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Chart name and version.
*/}}
{{- define "microservices.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate the full name for an individual microservice.
Expected context:
  root   -> Helm root context
  name   -> microservice name
*/}}
{{- define "microservices.serviceFullname" -}}
{{- $root := .root -}}
{{- $name := .name -}}
{{- printf "%s-%s" (include "microservices.fullname" $root) $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Labels for an individual microservice.
Expected context:
  root -> Helm root context
  name -> microservice name
*/}}
{{- define "microservices.serviceLabels" -}}
{{- $root := .root -}}
{{- $name := .name -}}

app.kubernetes.io/name: {{ $name }}
app.kubernetes.io/instance: {{ $root.Release.Name }}
app.kubernetes.io/component: {{ $name }}
app.kubernetes.io/part-of: {{ $root.Values.global.partOf | default "microservices" }}
app.kubernetes.io/managed-by: {{ $root.Release.Service }}
{{- end }}

{{/*
Generate a NetworkPolicy selector for a microservice.
*/}}
{{- define "microservices.networkPolicyPodSelector" -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "microservices.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}