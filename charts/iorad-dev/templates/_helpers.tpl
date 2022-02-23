{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "iorad-dev.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iorad-dev.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "iorad-dev.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create databaseHost
*/}}
{{- define "iorad-dev.databaseHost" -}}
{{- if $.Values.mysql.host -}}
  {{- $.Values.mysql.host -}}
{{ else }}
  {{- $.Release.Name -}}-{{- "mysql" -}}
{{ end }}
{{- end -}}


{{/*
Create databaseUrl from MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER and MYSQL_PASSWORD
*/}}
{{- define "iorad-dev.databaseUrl" -}}
  mysql://{{- $.Values.mysql.mysqlUser -}}:{{- $.Values.mysql.mysqlPassword -}}@{{- template "iorad-dev.databaseHost" . -}}:{{- $.Values.mysql.port -}}/{{- $.Values.mysql.mysqlDatabase -}}
{{- end -}}
