{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- $selectorLabels := include "chart.selectorLabels" . -}}
{{- if .Values.NetworkPolicy.enabled  }}
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: {{ $fullName }}
  labels:
    {{- $labels | nindent 4 }}
  {{- with .Values.NetworkPolicy.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  podSelector:
    matchLabels:
      {{- $selectorLabels | nindent 6 }}
  {{- if or .Values.NetworkPolicy.ingressRules .Values.NetworkPolicy.egressRules }}
  policyTypes:
  {{- if .Values.NetworkPolicy.ingressRules }}
    - Ingress
  {{- end }}
  {{- if .Values.NetworkPolicy.egressRules }}
    - Egress
  {{- end }}
  {{- end }}

  {{- if .Values.NetworkPolicy.ingressRules }}
  ingress:
  {{-  range $rule := .Values.NetworkPolicy.ingressRules }}
    - from:
  {{- toYaml $rule.selectors | nindent 8 }}
      ports:
  {{- toYaml $rule.ports | nindent 8 }}  
  {{- end }}
  {{- end }}

  {{- if .Values.NetworkPolicy.egressRules }}
  egress:
  {{-  range $rule := .Values.NetworkPolicy.egressRules }}
    - to:
  {{- toYaml $rule.selectors | nindent 8 }}
      ports:
  {{- toYaml $rule.ports | nindent 8 }}  
  {{- end }}
  {{- end }}

{{- end }}