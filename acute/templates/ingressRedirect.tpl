{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- $selectorLabels := include "chart.selectorLabels" . -}}
{{- range $containers := .Values.containers }}
{{- if and $containers.ingressRedirect ( $containers.ingressRedirect.enabled | default false) }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ (list $fullName $containers.name "redirect"  | join "-") }}
  labels:
    {{- $labels | nindent 4 }}
  {{- with $containers.ingressRedirect.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if $containers.ingressRedirect.className }}
  ingressClassName: {{ $containers.ingressRedirect.className }}
  {{- end }}
  {{- if $containers.ingressRedirect.tls }}
  tls:
    {{- range $containers.ingressRedirect.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range $containers.ingressRedirect.hosts }}
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
                name: ssl-redirect
                port:
                  name: use-annotation
          {{- end }}
    {{- end }}
{{- end }}
{{- end }}