# kubectl Productivity

Imperative commands, jsonpath, editing immutable fields, drains and shell setup for speed.

### 1. Generate the YAML of a pod without creating it.

```bash
kubectl run web --image=nginx --dry-run=client -o yaml > pod.yaml
```

### 2. Delete a pod immediately without waiting (exam time saver).

```bash
kubectl delete pod web --force --grace-period=0
```

### 3. Edit a pod field that cannot be changed live (e.g. resources). Fastest way?

```bash
kubectl edit pod web   # save; it is rejected and a copy lands in /tmp/kubectl-edit-xxx.yaml
kubectl replace --force -f /tmp/kubectl-edit-xxx.yaml
```

### 4. Find which fields a pod spec supports for tolerations, without the browser.

```bash
kubectl explain pod.spec.tolerations
```

### 5. Get the IP of every pod with name, in two columns.

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,IP:.status.podIP
```

### 6. Print only the names of all nodes using jsonpath.

```bash
kubectl get nodes -o jsonpath='{.items[*].metadata.name}'
```

### 7. Show pods with their labels / filter pods with label app=web.

```bash
kubectl get pods --show-labels
kubectl get pods -l app=web
```

### 8. Run a command inside container web of pod web-1.

```bash
kubectl exec -it web-1 -c web -- sh
```

### 9. Create a pod with a custom command: busybox that sleeps 3600 seconds.

```bash
kubectl run sleeper --image=busybox --command -- sleep 3600
```

### 10. Which 3 lines go in ~/.vimrc at the start of the exam for YAML?

```bash
set expandtab
set tabstop=2
set shiftwidth=2
```

### 11. First alias to set at the start of the exam?

```bash
alias k=kubectl
export do='--dry-run=client -o yaml'
```

### 12. How do you SSH to a node in the exam and come back?

```bash
ssh node01   # do the work, then: exit
```

### 13. Save the list of all pods in all namespaces to /opt/pods.txt.

```bash
kubectl get pods -A > /opt/pods.txt
```

### 14. Find which pod in namespace prod uses ServiceAccount build-bot.

```bash
kubectl get pods -n prod -o custom-columns=NAME:.metadata.name,SA:.spec.serviceAccountName
```

### 15. Restart all pods of deployment web without changing the YAML.

```bash
kubectl rollout restart deployment web
```

### 16. Drain node01 when DaemonSet pods and emptyDir pods block it.

```bash
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data
```
