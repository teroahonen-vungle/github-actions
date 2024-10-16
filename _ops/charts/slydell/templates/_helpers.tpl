{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "slydell.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "slydell.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "slydell.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "slydell.labels" -}}
chart: {{ include "slydell.chart" . }}
{{ include "slydell.selectorLabels" . }}
heritage: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "slydell.selectorLabels" -}}
app: {{ include "slydell.name" . }}
release: {{ .Release.Name }}
{{- end }}

{{/*
secret name
*/}}
{{- define "slydell.secret" -}}
{{- if eq .Values.secretEnabled "false" }}
{{- .Values.secretName }}
{{- else }}
{{ template "slydell.fullname" . }}
{{- end }}
{{- end }}
