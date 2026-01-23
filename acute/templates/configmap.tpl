{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}


{{- if and .Values.configMap ( .Values.configMap.enabled | default false ) }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name:  {{ $fullName }}-config-file
  labels:
    {{- $labels | nindent 4 }}
  {{- with .Values.configMap.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
data:
{{- range $fileConfigs := .Values.configMap.fileConfigs }}
  {{ $fileConfigs.filename }}: |-
    {{- $fileConfigs.data | nindent 4 }}
{{- end }}
{{- end }}

{{- if and .Values.configEnv ( .Values.configEnv.enabled | default false ) }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name:  {{ $fullName }}-config-env
  labels:
    {{- $labels | nindent 4 }}
  {{- with .Values.configEnv.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
data:
  {{- .Values.configEnv.data | nindent 4 }}
{{- end }}
