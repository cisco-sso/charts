# Default values for kubernetes-dashboard
# This is a YAML-formatted file.
# Declare name/value pairs to be passed into your templates.
# name: value

image: {{ (datasource "config").image }}
imageTag: "{{ (datasource "config").imageTag }}"
imagePullPolicy: "{{ (datasource "config").imagePullPolicy }}"

replicas: {{ (datasource "config").replicas }}
{{ if (datasource "config").nodeSelector }}
nodeSelector:
{{ (datasource "config").nodeSelector | data.ToYAML | indent 2 }}
{{ else }}
nodeSelector: {}
{{- end }}

httpPort: {{ (datasource "config").httpPort }}

serviceType: {{ (datasource "config").serviceType }}

resources:
  limits:
    cpu: {{ (datasource "config").resources.limits.cpu }}
    memory: {{ (datasource "config").resources.limits.memory }}
  requests:
    cpu: {{ (datasource "config").resources.requests.cpu }}
    memory: {{ (datasource "config").resources.requests.memory }}

ingress:
  ## If true, Kubernetes Dashboard Ingress will be created.
  ##
  enabled: {{ (datasource "config").ingress.enabled }}

  ## Kubernetes Dashboard Ingress annotations
  ##
  # annotations:
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: 'true'
  {{- if (datasource "config").ingress.enabled }}
  annotations:
    kubernetes.io/ingress.class: {{ (datasource "config").ingress.class }}
    {{- if (datasource "config").ingress.basicAuth.enabled }}
    ingress.kubernetes.io/auth-type: basic
    ingress.kubernetes.io/auth-realm: "Authentication Required"
    ingress.kubernetes.io/auth-secret: {{ (datasource "config").ingress.basicAuth.secretName }}
    {{- end }}
    {{- if (datasource "config").ingress.externalDns.enabled }}
    external-dns.alpha.kubernetes.io/hostname: "http://{{ (datasource "config").ingress.shortname }}.{{ (datasource "config").ingress.domain }}"
    {{- end }}
    {{- if (datasource "config").ingress.tls.enabled }}
    ingress.kubernetes.io/ssl-redirect: true
    {{- end }}
    {{- if (datasource "config").ingress.lego.enabled }}
      {{- if (has (datasource "config").ingress.lego "annotationSuffix") }}
    kubernetes.io/tls-acme{{ (datasource "config").ingress.lego.annotationSuffix }}: true
      {{ else }}
    kubernetes.io/tls-acme: true
      {{- end }}
    {{- end }}
  {{- end }}

  ## Kubernetes Dashboard Ingress hostnames
  ## Must be provided if Ingress is enabled
  ##
  # hosts:
  #   - kubernetes-dashboard.domain.com
  {{- if (datasource "config").ingress.enabled }}
  hosts:
    - {{ (datasource "config").ingress.shortname }}.{{ (datasource "config").ingress.domain }}
  {{- end }}

  ## Kubernetes Dashboard Ingress TLS configuration
  ## Secrets must be manually created in the namespace
  ##
  # tls:
  #   - secretName: kubernetes-dashboard-tls
  #     hosts:
  #       - kubernetes-dashboard.domain.com
  {{- if (datasource "config").ingress.tls.enabled }}
  tls:
    - secretName: {{ (datasource "config").ingress.tls.secretName }}
      hosts:
        - {{ (datasource "config").ingress.shortname }}.{{ (datasource "config").ingress.domain }}
  {{- end }}

rbac:
  ## If true, create & use RBAC resources
  #
  create: {{ (datasource "config").rbac.create }}

  ## Ignored if rbac.create is true
  #
serviceAccount:
  create: {{ (datasource "config").serviceAccount.create }}
  name: {{ (datasource "config").serviceAccount.name }}

# tolerations:
#   - key: taintKey
#     value: taintValue
#     operator: Equal
#     effect: NoSchedule
{{- if (datasource "config").tolerations }}
tolerations:
{{ (datasource "config").tolerations | data.ToYAML | indent 2 }}
{{ else }}
tolerations: {}
{{- end }}

{{- if (has (datasource "config") "antiAffinity") }}

antiAffinity:
  enabled: {{ (datasource "config").antiAffinity.enabled }}
  type: {{ (datasource "config").antiAffinity.type }}
{{- end }}
