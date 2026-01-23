{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- $selectorLabels := include "chart.selectorLabels" . -}}
{{- range $containers := .Values.containers }}
{{- if and $containers.ingress ( $containers.ingress.enabled | default false) }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ (list $fullName $containers.name  | join "-") }}
  labels:
    {{- $labels | nindent 4 }}
  {{- with $containers.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if $containers.ingress.className }}
  ingressClassName: {{ $containers.ingress.className }}
  {{- end }}
  {{- if $containers.ingress.tls }}
  tls:
    {{- range $containers.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range $containers.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            {{- if .pathType }}
            pathType: {{ .pathType }}
            {{- end }}
            backend:
              service:
                name: {{ (list $fullName $containers.name  | join "-") }}
                port:
                  number: {{ .backend.port.number }}
          {{- end }}
    {{- end }}
{{- end }}
{{- end }}