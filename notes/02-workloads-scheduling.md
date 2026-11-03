# Workloads & Scheduling

Deployments, rollouts, autoscaling, resources, ConfigMaps/Secrets, taints, tolerations, affinity, probes, Jobs and sidecars.

### 1. Create a deployment web with image nginx:1.27 and 3 replicas.

```bash
kubectl create deployment web --image=nginx:1.27 --replicas=3
```

### 2. Change the image of container nginx in deployment web to nginx:1.28.

```bash
kubectl set image deployment/web nginx=nginx:1.28
```

### 3. Watch the rollout of deployment web until it finishes.

```bash
kubectl rollout status deployment/web
```

### 4. Roll back deployment web to the previous version.

```bash
kubectl rollout undo deployment/web
```

### 5. Scale deployment web to 5 replicas.

```bash
kubectl scale deployment web --replicas=5
```

### 6. Create an HPA for deployment web: min 2, max 6, target CPU 70%.

```bash
kubectl autoscale deployment web --min=2 --max=6 --cpu-percent=70
```

### 7. Set CPU request 100m and memory limit 256Mi on deployment web.

```bash
kubectl set resources deployment web --requests=cpu=100m --limits=memory=256Mi
```

### 8. Create a ConfigMap app-cfg with key MODE=prod.

```bash
kubectl create configmap app-cfg --from-literal=MODE=prod
```

### 9. Create a generic Secret db-pass with key password=s3cr3t.

```bash
kubectl create secret generic db-pass --from-literal=password=s3cr3t
```

### 10. In a pod spec, load ALL keys of ConfigMap app-cfg as environment variables.

```yaml
envFrom:
- configMapRef:
    name: app-cfg
```

### 11. Taint node01 so that only pods with toleration gpu=true can be scheduled.

```bash
kubectl taint nodes node01 gpu=true:NoSchedule
```

### 12. Write the toleration for taint gpu=true:NoSchedule.

```yaml
tolerations:
- key: gpu
  operator: Equal
  value: "true"
  effect: NoSchedule
```

### 13. Label node01 with disk=ssd, then schedule a pod only on that kind of node (simplest way).

```bash
kubectl label nodes node01 disk=ssd
# pod spec:
nodeSelector:
  disk: ssd
```

### 14. Run a pod on a specific node, bypassing the scheduler.

```yaml
spec:
  nodeName: node01
```

### 15. Which three effects can a taint have?

NoSchedule · PreferNoSchedule · NoExecute

### 16. Add a liveness probe that does HTTP GET /healthz on port 8080.

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
```

### 17. A pod runs a single command once and must NOT be restarted. Which restartPolicy?

```yaml
restartPolicy: Never
```

### 18. Create a CronJob cleanup that runs busybox every 5 minutes.

```bash
kubectl create cronjob cleanup --image=busybox --schedule="*/5 * * * *" -- echo done
```

### 19. Add a sidecar to a pod that shares the file /var/log/app.log with the main container. What do both containers need?

Same volume (e.g. emptyDir), mounted in both containers

### 20. Which object limits the total CPU/memory of a namespace, and which sets default limits per container?

ResourceQuota (namespace total) · LimitRange (per-container default/min/max)

### 21. What happens to a container that uses more memory than its limit?

It is killed: OOMKilled (exit code 137)
