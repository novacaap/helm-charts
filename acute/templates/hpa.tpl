{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- if .Values.autoscaling.enabled  }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $fullName }}
  labels:
    {{- $labels | nindent 4 }}
spec:
  {{- if .Values.autoscaling.behavior }}
  behavior:
    {{- toYaml .Values.autoscaling.behavior | nindent 4 }}
  {{- end }}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ .Values.kind }}
    name: {{ $fullName }}
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
  {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
          type: Utilization
  {{- end }}
  {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
          type: Utilization
  {{- end }}
  {{- if .Values.autoscaling.customRules -}}
    {{- toYaml .Values.autoscaling.customRules | nindent 4}}
  {{- end -}}
{{- end }}