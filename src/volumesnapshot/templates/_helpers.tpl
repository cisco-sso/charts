{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "volumesnapshot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "volumesnapshot.fullname" -}}
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

{{- define "volumesnapshot.cloudConfig" -}}
{{- if eq .Values.cloud.provider "openstack" -}}
[Global]
auth-url={{ .Values.cloud.openstack.authURL | quote }}
username={{ .Values.cloud.openstack.username | quote }}
password={{ .Values.cloud.openstack.password | quote }}
region={{ .Values.cloud.openstack.region | quote }}
tenant-id={{ .Values.cloud.openstack.tenantID | quote }}
tenant-name={{ .Values.cloud.openstack.tenantName | quote }}
domain-name={{ .Values.cloud.openstack.domainName | quote }}
{{- end -}}
{{- end -}}

{{/*
Release tag the config name
*/}}
{{- define "volumesnapshot.secretname" -}}
{{- if .Values.cloud.secret.create -}}
{{- $defaultname := default "cloud-config" .Values.cloud.secret.name -}}
{{- printf "%s-%s" .Release.Name $defaultname  | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Values.cloud.secret.name | trunc 250 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "volumesnapshot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
