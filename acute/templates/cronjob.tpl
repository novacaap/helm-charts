{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- $selectorLabels := include "chart.selectorLabels" . -}}
{{- $shareVolume := .Values.shareVolume -}}
{{- if eq .Values.kind "CronJob" }}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ $fullName }}
  labels:
    {{- $labels | nindent 4 }}
    {{- with .Values.labels }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  schedule: "{{ .Values.schedule }}"
  successfulJobsHistoryLimit: {{ .Values.successfulJobsHistoryLimit }}
  failedJobsHistoryLimit: {{ .Values.failedJobsHistoryLimit }}
  concurrencyPolicy: {{ .Values.concurrencyPolicy }}
  suspend: {{ .Values.suspend }}
  timeZone: {{ .Values.timeZone }}
  jobTemplate:
    spec:
      backoffLimit: {{ .Values.backoffLimit }}
      template:
        spec:
          {{- with .Values.imagePullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          serviceAccountName: {{ include "chart.serviceAccountName" . }}
          automountServiceAccountToken: {{ .Values.serviceAccount.automount | default true }}
          {{- with .Values.podSecurityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.terminationGracePeriodSeconds }}
          terminationGracePeriodSeconds: {{ . }}
          {{- end }}
          {{- if ( .Values.initcontainers | default false ) }}
          initContainers:
            {{- range $init := .Values.initcontainers }}
            - name: {{ $init.name }}
              {{- with $init.securityContext }}
              securityContext:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              image: "{{ $init.image.repository }}:{{ $init.image.tag | default "latest" }}"
              imagePullPolicy: {{ $init.image.pullPolicy | default "IfNotPresent" }}
              {{- with $init.image.command }}
              command:
              {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- with $init.image.args }}
              args:
              {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- with $init.env }}
              env:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- if or $init.envFrom $init.configEnv }}
              envFrom:
              {{- if $init.envFrom }}
                {{- toYaml $init.envFrom | nindent 16 }}
              {{- end }}
              {{- if $init.configEnv }}
                - configMapRef:
                    name: {{ $fullName }}-config-env
              {{- end }}
              {{- end }}
              {{- with $init.resources }}
              resources:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              volumeMounts:
                - name: sharevolume
                  mountPath: {{ $shareVolume }}
              {{- with $init.volumeMounts }}
                {{- toYaml . | nindent 16 }}
              {{- end }}
            {{- end }}
          {{- end }}
          containers:
            {{- range $containers := .Values.containers }}
            - name: {{ $containers.name }}
              {{- with $containers.securityContext }}
              securityContext:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              image: "{{ $containers.image.repository }}:{{ $containers.image.tag | default "latest" }}"
              imagePullPolicy: {{ $containers.image.pullPolicy | default "IfNotPresent" }}
              {{- with $containers.image.command }}
              command:
              {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- with $containers.image.args }}
              args:
              {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- with $containers.env }}
              env:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- if or $containers.envFrom $containers.configEnv }}
              envFrom:
              {{- if $containers.envFrom }}
                {{- toYaml $containers.envFrom | nindent 16 }}
              {{- end }}
              {{- if $containers.configEnv }}
                - configMapRef:
                    name: {{ $fullName }}-config-env
              {{- end }}
              {{- end }}
              {{- with $containers.resources }}
              resources:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- if and $containers.service ( $containers.service.enabled | default false ) }}
              ports:
                {{- range $port := $containers.service.ports }}
                - name: {{ $port.name }}
                  containerPort: {{ $port.targetPort }}
                  protocol: {{ $port.protocol }}
                {{- end }}
              {{- end }}
              {{- with $containers.livenessProbe }}
              livenessProbe:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- with $containers.readinessProbe }}
              readinessProbe:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- with $containers.startupProbe }}
              startupProbe:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              {{- with $containers.lifecycle }}
              lifecycle:
                {{- toYaml . | nindent 16 }}
              {{- end }}
              volumeMounts:
                - name: sharevolume
                  mountPath: {{ $shareVolume }}
              {{- with $containers.volumeMounts }}
                {{- toYaml . | nindent 16 }}
              {{- end }}
            {{- end }}
          volumes:
            - name: sharevolume
              emptyDir: {}
          {{- with .Values.volumes }}
          {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- if .Values.configEnv.enabled }}
            - name: config-env
              configMap:
                name:  {{ $fullName }}-config-env
          {{- end }}
          {{- if .Values.configMap.enabled }}
            - name: config-map
              configMap:
                name:  {{ $fullName }}-config-file
          {{- end }}
          {{- with .Values.nodeSelector }}
          nodeSelector:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.affinity }}
          affinity:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.tolerations }}
          tolerations:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.hostAliases }}
          hostAliases:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          restartPolicy: {{ .Values.restartPolicy | default "OnFailure" }}
{{- end }}