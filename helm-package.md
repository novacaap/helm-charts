# Helm package and Index acute

```
helm package acute
mv acute-* docs
helm repo index docs --url https://kalpeshbpatel.github.io/helm-chart
```

# Add Helm Repo

```
helm repo add acute https://kalpeshbpatel.github.io/helm-chart/
helm search repo acute
```
