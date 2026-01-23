{{- $fullName := include "chart.fullname" . -}}
{{- $labels := include "chart.labels" . -}}
{{- $selectorLabels := include "chart.selectorLabels" . -}}
{{- $shareVolume := .Values.shareVolume -}}
{{- if eq .Values.kind "Deployment" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $fullName }}
  labels:
    {{- $labels | nindent 4 }}
    {{- with .Values.labels }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    reloader.stakater.com/auto: "true"
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- $selectorLabels | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- $selectorLabels | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "chart.serviceAccountName" . }}
      {{- with .Values.podSecurityContext }}
        securityContext:
          {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- with .Values.terminationGracePeriodSeconds }}
      terminationGracePeriodSeconds: {{ . }}
      {{- end }}
      shareProcessNamespace: {{ .Values.shareProcessNamespace }}
      {{- if ( .Values.initcontainers | default false ) }}
      initContainers:
        {{- range $init := .Values.initcontainers }}
        - name: {{ $init.name }}
          {{- with $init.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          image: "{{ $init.image.repository }}:{{ $init.image.tag | default "latest" }}"
          imagePullPolicy: {{ $init.image.pullPolicy | default "IfNotPresent" }}
          {{- with $init.image.command }}
          command:
          {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $init.image.args }}
          args:
          {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $init.env }}
          env:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- if or $init.envFrom $init.configEnv }}
          envFrom:
          {{- if $init.envFrom }}
            {{- toYaml $init.envFrom | nindent 12 }}
          {{- end }}
          {{- if $init.configEnv }}
            - configMapRef:
                name: {{ $fullName }}-config-env
          {{- end }}
          {{- end }}
          {{- with $init.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          volumeMounts:
            - name: sharevolume
              mountPath: {{ $shareVolume }}
          {{- with $init.volumeMounts }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
        {{- end }}
      {{- end }}
      containers:
        {{- range $containers := .Values.containers }}
        - name: {{ $containers.name }}
          {{- with $containers.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          image: "{{ $containers.image.repository }}:{{ $containers.image.tag | default "latest" }}"
          imagePullPolicy: {{ $containers.image.pullPolicy | default "IfNotPresent" }}
          {{- with $containers.image.command }}
          command:
          {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $containers.image.args }}
          args:
          {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $containers.env }}
          env:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- if or $containers.envFrom $containers.configEnv }}
          envFrom:
          {{- if $containers.envFrom }}
            {{- toYaml $containers.envFrom | nindent 12 }}
          {{- end }}
          {{- if $containers.configEnv }}
            - configMapRef:
                name: {{ $fullName }}-config-env
          {{- end }}
          {{- end }}
          {{- with $containers.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
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
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $containers.readinessProbe }}
          readinessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $containers.startupProbe }}
          startupProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $containers.lifecycle }}
          lifecycle:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          volumeMounts:
            - name: sharevolume
              mountPath: {{ $shareVolume }}
          {{- with $containers.volumeMounts }}
            {{- toYaml . | nindent 12 }}
          {{- end }}
        {{- end }}
      volumes:
        - name: sharevolume
          emptyDir: {}
      {{- with .Values.volumes }}
      {{- toYaml . | nindent 8 }}
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
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.hostAliases }}
      hostAliases:
        {{- toYaml . | nindent 8 }}
      {{- end }}    
{{- end }}