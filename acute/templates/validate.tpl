{{- $kind := required "values.kind is required and must be one of Deployment|StatefulSet|Job|CronJob" .Values.kind -}}
{{- if and .Values.autoscaling.enabled (ne $kind "Deployment") -}}
{{- fail "values.autoscaling.enabled=true is only supported when values.kind is Deployment" -}}
{{- end -}}
{{- if and .Values.scaledObject.enabled (ne $kind "Deployment") -}}
{{- fail "values.scaledObject.enabled=true is only supported when values.kind is Deployment" -}}
{{- end -}}
{{- if and (eq $kind "CronJob") (not .Values.schedule) -}}
{{- fail "values.schedule is required when values.kind is CronJob" -}}
{{- end -}}
{{- if and (eq $kind "StatefulSet") (not .Values.persistence.enabled) -}}
{{- if empty .Values.containers -}}
{{- fail "values.containers must include at least one container" -}}
{{- end -}}
{{- end -}}
{{- range $index, $container := .Values.containers -}}
{{- if not $container.name -}}
{{- fail (printf "values.containers[%d].name is required" $index) -}}
{{- end -}}
{{- if or (not $container.image) (not $container.image.repository) -}}
{{- fail (printf "values.containers[%d].image.repository is required" $index) -}}
{{- end -}}
{{- if and $container.service $container.service.enabled (empty $container.service.ports) -}}
{{- fail (printf "values.containers[%d].service.ports must be set when service.enabled=true" $index) -}}
{{- end -}}
{{- end -}}
