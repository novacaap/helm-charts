{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- if .Values.scaledObject.enabled  }}
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: {{ $fullName }}
spec:
  scaleTargetRef:
    name: {{ $fullName }}
    kind: {{ .Values.kind | default "Deployment" }}
    apiVersion: apps/v1
  {{- if .Values.scaledObject.pollingInterval }}
  pollingInterval: {{ .Values.scaledObject.pollingInterval }}
  {{- end }}
  {{- if .Values.scaledObject.cooldownPeriod }}
  cooldownPeriod: {{ .Values.scaledObject.cooldownPeriod }}
  {{- end }}
  {{- if .Values.scaledObject.idleReplicaCount }}
  idleReplicaCount: {{ .Values.scaledObject.idleReplicaCount }}
  {{- end }}
  minReplicaCount:  {{ .Values.scaledObject.minReplicaCount | default "1" }}
  maxReplicaCount:  {{ .Values.scaledObject.maxReplicaCount | default "10" }}
  {{- with .Values.scaledObject.fallback }}
  fallback:
  {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.scaledObject.triggers }}
  triggers:
  {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.scaledObject.advanced }}
  advanced:
  {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
