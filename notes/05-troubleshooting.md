# Troubleshooting

Broken nodes, control plane failures, pod states (Pending, CrashLoopBackOff, ImagePullBackOff), logs, events and metrics.

### 1. Node node01 is NotReady. First 3 commands to run ON the node?

```bash
systemctl status kubelet
journalctl -u kubelet -f
systemctl restart kubelet
```

### 2. Kubelet was stopped and disabled. Start it and make it survive reboot.

```bash
systemctl enable --now kubelet
```

### 3. kubectl says 'connection refused' to the API server. Where do you look?

```bash
crictl ps -a | grep kube-apiserver
crictl logs <container-id>
/etc/kubernetes/manifests/kube-apiserver.yaml
```

### 4. Pods stay Pending and no pod gets a node. Which component is probably broken?

kube-scheduler

### 5. Deployment changed replicas but no new pods are created. Which component?

kube-controller-manager

### 6. Show logs of container sidecar in pod web-1.

```bash
kubectl logs web-1 -c sidecar
```

### 7. Show all events in namespace prod, sorted by time.

```bash
kubectl get events -n prod --sort-by=.metadata.creationTimestamp
```

### 8. Find the pod using the most CPU in all namespaces.

```bash
kubectl top pods -A --sort-by=cpu
```

### 9. Find the pod using the most memory with label app=api and write its name to /opt/top.txt.

```bash
kubectl top pods -l app=api --sort-by=memory --no-headers | head -1 | awk '{print $1}' > /opt/top.txt
```

### 10. Pod status: ImagePullBackOff. Most likely cause?

Wrong image name/tag, no access to the registry, or a missing imagePullSecret

### 11. Pod status: Pending, event says 'Insufficient cpu'. Fix options?

Lower the request, reduce replicas, or add a node

### 12. Pod status: CrashLoopBackOff. Commands to find the reason?

```bash
kubectl logs <pod> --previous
kubectl describe pod <pod>
```

### 13. Pod stuck in ContainerCreating. Two common causes?

A volume / PVC / ConfigMap / Secret cannot be mounted · the CNI plugin is not working

### 14. List containers directly through the container runtime on a node.

```bash
crictl ps   # include stopped containers: crictl ps -a
```

### 15. Check whether all control plane components are healthy.

```bash
kubectl get pods -n kube-system
kubectl get --raw='/readyz?verbose'
```

### 16. Find the expiration date of the control plane certificates.

```bash
kubeadm certs check-expiration
```

### 17. A pod writes logs only to /var/log/app.log, not stdout. How does the exam want you to expose them?

Add a sidecar container: tail -F /var/log/app.log, sharing an emptyDir volume
