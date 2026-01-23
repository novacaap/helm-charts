# Helm package and Index acute

```
helm package acute
mv acute-* docs
helm repo index docs --url https://novacaap.github.io/helm-charts/
```

# Add Helm Repo

```
helm repo add acute https://novacaap.github.io/helm-charts/
helm search repo acute
```
