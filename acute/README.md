# Acute Helm Chart

A flexible and comprehensive Helm chart for deploying applications on Kubernetes. This chart supports multiple workload types including Deployments, StatefulSets, Jobs, and CronJobs, with extensive configuration options for production-ready deployments.

## Description

This Helm chart provides a standardized way to deploy containerized applications to Kubernetes with support for:

- **Multiple workload types**: Deployment, StatefulSet, Job, and CronJob
- **Auto-scaling**: Horizontal Pod Autoscaler (HPA) and KEDA ScaledObject
- **Networking**: Service, Ingress, and NetworkPolicy
- **Configuration management**: ConfigMap and Secret support
- **High availability**: PodDisruptionBudget and health probes
- **Security**: ServiceAccount, security contexts, and network policies

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- kubectl configured to access your Kubernetes cluster

## Installation

### Add the Helm repository

```bash
helm repo add kalpeshbpatel https://kalpeshbpatel.github.io/helm-chart
helm repo update
```

### Install the chart

```bash
helm install acute kalpeshbpatel/acute
```

### Install with custom values

```bash
helm install my-app kalpeshbpatel/acute -f my-values.yaml
```

## Configuration

The following table lists the configurable parameters and their default values:

### General Parameters

| Parameter          | Description                                             | Default      |
| ------------------ | ------------------------------------------------------- | ------------ |
| `nameOverride`     | Override the name of the chart                          | `""`         |
| `fullnameOverride` | Override the full name of the chart                     | `""`         |
| `kind`             | Workload type: Deployment, StatefulSet, Job, or CronJob | `Deployment` |
| `replicaCount`     | Number of replicas                                      | `1`          |

### Image Configuration

| Parameter                       | Description                | Default                |
| ------------------------------- | -------------------------- | ---------------------- |
| `containers[].image.repository` | Container image repository | `nginx`                |
| `containers[].image.tag`        | Container image tag        | `""` (uses appVersion) |
| `containers[].image.pullPolicy` | Image pull policy          | `IfNotPresent`         |
| `imagePullSecrets`              | Image pull secrets         | `[]`                   |

### Workload-Specific Configuration

#### Deployment/StatefulSet

- `updateStrategy`: Update strategy configuration
- `podManagementPolicy`: Pod management policy for StatefulSet (OrderedReady/Parallel)

#### CronJob/Job

- `schedule`: Cron schedule expression (CronJob only)
- `restartPolicy`: Pod restart policy
- `backoffLimit`: Number of retries before marking Job as failed
- `successfulJobsHistoryLimit`: Number of successful job history to retain
- `failedJobsHistoryLimit`: Number of failed job history to retain
- `concurrencyPolicy`: Concurrency policy (Allow/Forbid/Replace)
- `suspend`: Suspend the CronJob
- `timeZone`: Timezone for the schedule

### Pod Configuration

| Parameter                       | Description                                | Default |
| ------------------------------- | ------------------------------------------ | ------- |
| `podAnnotations`                | Annotations to add to pods                 | `{}`    |
| `podLabels`                     | Labels to add to pods                      | `{}`    |
| `podSecurityContext`            | Security context for pods                  | `{}`    |
| `terminationGracePeriodSeconds` | Grace period for pod termination           | `30`    |
| `shareProcessNamespace`         | Share process namespace between containers | `false` |

### Container Configuration

| Parameter                      | Description                        | Default |
| ------------------------------ | ---------------------------------- | ------- |
| `containers[].securityContext` | Security context for container     | `{}`    |
| `containers[].resources`       | Resource requests and limits       | `{}`    |
| `containers[].env`             | Environment variables              | `[]`    |
| `containers[].envFrom`         | Environment variables from sources | `[]`    |
| `containers[].volumeMounts`    | Volume mounts                      | `[]`    |
| `containers[].livenessProbe`   | Liveness probe configuration       | `{}`    |
| `containers[].readinessProbe`  | Readiness probe configuration      | `{}`    |
| `containers[].startupProbe`    | Startup probe configuration        | `{}`    |
| `containers[].lifecycle`       | Lifecycle hooks                    | `{}`    |

### Service Configuration

| Parameter                          | Description         | Default     |
| ---------------------------------- | ------------------- | ----------- |
| `containers[].service.enabled`     | Enable Service      | `false`     |
| `containers[].service.type`        | Service type        | `ClusterIP` |
| `containers[].service.ports`       | Service ports       | `[]`        |
| `containers[].service.annotations` | Service annotations | `{}`        |

### Ingress Configuration

| Parameter                                      | Description                 | Default |
| ---------------------------------------------- | --------------------------- | ------- |
| `containers[].ingress.enabled`                 | Enable Ingress              | `false` |
| `containers[].ingress.className`               | Ingress class name          | `""`    |
| `containers[].ingress.hosts`                   | Ingress hosts configuration | `[]`    |
| `containers[].ingress.tls`                     | TLS configuration           | `[]`    |
| `containers[].ingress.ingressRedirect.enabled` | Enable redirect Ingress     | `false` |

### Configuration Management

| Parameter               | Description                               | Default |
| ----------------------- | ----------------------------------------- | ------- |
| `configMap.enabled`     | Enable ConfigMap                          | `false` |
| `configMap.fileConfigs` | ConfigMap file configurations             | `[]`    |
| `configEnv.enabled`     | Enable ConfigMap as environment variables | `false` |
| `secretEnv.enabled`     | Enable Secret as environment variables    | `false` |
| `secretEnv.data`        | Secret data                               | `""`    |

### Storage Configuration

| Parameter                  | Description              | Default         |
| -------------------------- | ------------------------ | --------------- |
| `persistence.enabled`      | Enable persistent volume | `false`         |
| `persistence.storageClass` | Storage class name       | `""`            |
| `persistence.accessMode`   | Access mode              | `ReadWriteOnce` |
| `persistence.size`         | Storage size             | `10Gi`          |
| `persistence.mountPath`    | Mount path               | `/data`         |
| `volumes`                  | Additional volumes       | `[]`            |

### Auto-scaling Configuration

#### Horizontal Pod Autoscaler (HPA)

| Parameter                                       | Description                    | Default |
| ----------------------------------------------- | ------------------------------ | ------- |
| `autoscaling.enabled`                           | Enable HPA                     | `false` |
| `autoscaling.minReplicas`                       | Minimum replicas               | `1`     |
| `autoscaling.maxReplicas`                       | Maximum replicas               | `100`   |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization         | `""`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization      | `""`    |
| `autoscaling.customRules`                       | Custom metric rules            | `[]`    |
| `autoscaling.behavior`                          | Scaling behavior configuration | `{}`    |

#### KEDA ScaledObject

| Parameter                       | Description                 | Default |
| ------------------------------- | --------------------------- | ------- |
| `scaledObject.enabled`          | Enable KEDA ScaledObject    | `false` |
| `scaledObject.minReplicaCount`  | Minimum replica count       | `1`     |
| `scaledObject.maxReplicaCount`  | Maximum replica count       | `10`    |
| `scaledObject.pollingInterval`  | Polling interval in seconds | `30`    |
| `scaledObject.cooldownPeriod`   | Cooldown period in seconds  | `300`   |
| `scaledObject.idleReplicaCount` | Idle replica count          | `0`     |
| `scaledObject.triggers`         | Scaling triggers            | `[]`    |

### Security Configuration

| Parameter                    | Description                | Default |
| ---------------------------- | -------------------------- | ------- |
| `serviceAccount.create`      | Create ServiceAccount      | `true`  |
| `serviceAccount.name`        | ServiceAccount name        | `""`    |
| `serviceAccount.annotations` | ServiceAccount annotations | `{}`    |
| `NetworkPolicy.enabled`      | Enable NetworkPolicy       | `false` |
| `NetworkPolicy.ingressRules` | Ingress rules              | `[]`    |
| `NetworkPolicy.egressRules`  | Egress rules               | `[]`    |

### High Availability

| Parameter                            | Description                | Default |
| ------------------------------------ | -------------------------- | ------- |
| `podDisruptionBudget.enabled`        | Enable PodDisruptionBudget | `false` |
| `podDisruptionBudget.minAvailable`   | Minimum available pods     | `""`    |
| `podDisruptionBudget.maxUnavailable` | Maximum unavailable pods   | `""`    |

### Scheduling Configuration

| Parameter      | Description    | Default |
| -------------- | -------------- | ------- |
| `nodeSelector` | Node selector  | `{}`    |
| `tolerations`  | Tolerations    | `[]`    |
| `affinity`     | Affinity rules | `{}`    |
| `hostAliases`  | Host aliases   | `[]`    |

## Examples

### Basic Deployment

```yaml
kind: Deployment
replicaCount: 2
containers:
  - name: nginx
    image:
      repository: nginx
      tag: "1.21"
    service:
      enabled: true
      type: ClusterIP
      ports:
        - name: http
          port: 80
          targetPort: 80
```

### StatefulSet with Persistent Storage

```yaml
kind: StatefulSet
replicaCount: 3
persistence:
  enabled: true
  size: 20Gi
  storageClass: fast-ssd
containers:
  - name: app
    image:
      repository: myapp
      tag: "v1.0.0"
```

### CronJob Example

```yaml
kind: CronJob
schedule: "0 2 * * *"
timeZone: "America/New_York"
containers:
  - name: backup
    image:
      repository: backup-tool
      tag: "latest"
```

### Deployment with HPA

```yaml
kind: Deployment
replicaCount: 2
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
containers:
  - name: app
    image:
      repository: myapp
      tag: "v1.0.0"
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 500m
        memory: 512Mi
```

### Deployment with Ingress

```yaml
kind: Deployment
containers:
  - name: web
    image:
      repository: nginx
      tag: "1.21"
    service:
      enabled: true
      ports:
        - name: http
          port: 80
          targetPort: 80
    ingress:
      enabled: true
      className: nginx
      hosts:
        - host: example.com
          paths:
            - path: /
              pathType: Prefix
              backend:
                port:
                  number: 80
      tls:
        - secretName: example-tls
          hosts:
            - example.com
```

## Upgrading

To upgrade the release:

```bash
helm upgrade <release-name> kalpeshbpatel/acute
```

Or with custom values:

```bash
helm upgrade <release-name> kalpeshbpatel/acute -f my-values.yaml
```

## Uninstalling

To uninstall/delete the release:

```bash
helm uninstall <release-name>
```

## Troubleshooting

### Check deployment status

```bash
kubectl get pods -l app.kubernetes.io/name=acute
```

### View logs

```bash
kubectl logs -l app.kubernetes.io/name=acute
```

### Describe resources

```bash
kubectl describe deployment <release-name>
```

## Support

For issues, questions, or contributions, please refer to the repository's issue tracker:

- **Repository**: [https://github.com/kalpeshbpatel/helm-chart](https://github.com/kalpeshbpatel/helm-chart)
- **Issues**: [https://github.com/kalpeshbpatel/helm-chart/issues](https://github.com/kalpeshbpatel/helm-chart/issues)

## License

See the repository for license information.
