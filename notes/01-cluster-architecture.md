# Cluster Architecture, Installation & Configuration

etcd backup/restore, kubeadm upgrades and joins, RBAC, Helm, Kustomize, CRDs, kubeconfig contexts.

### 1. Take an etcd snapshot to /opt/etcd-backup.db.

```bash
ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
 --endpoints=https://127.0.0.1:2379 \
 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
 --cert=/etc/kubernetes/pki/etcd/server.crt \
 --key=/etc/kubernetes/pki/etcd/server.key
```

### 2. Restore etcd from /opt/etcd-backup.db.

```bash
etcdutl snapshot restore /opt/etcd-backup.db --data-dir=/var/lib/etcd-restore
# then point the etcd volume hostPath in /etc/kubernetes/manifests/etcd.yaml to /var/lib/etcd-restore
```

### 3. Where are the static pod manifests on a kubeadm node?

```bash
/etc/kubernetes/manifests/
```

### 4. Show the upgrade plan for the control plane with kubeadm.

```bash
kubeadm upgrade plan
```

### 5. Upgrade the first control plane node to v1.34.1.

```bash
kubeadm upgrade apply v1.34.1
```

### 6. Full upgrade order for one worker node?

```bash
kubectl drain node01 --ignore-daemonsets
(ssh node01) apt install kubeadm → kubeadm upgrade node
apt install kubelet kubectl → systemctl daemon-reload; systemctl restart kubelet
kubectl uncordon node01
```

### 7. Print the command for joining a new worker node.

```bash
kubeadm token create --print-join-command
```

### 8. Create a Role pod-reader in namespace dev that can get, list and watch pods.

```bash
kubectl create role pod-reader -n dev --verb=get,list,watch --resource=pods
```

### 9. Bind Role pod-reader to user jane in namespace dev.

```bash
kubectl create rolebinding jane-read -n dev --role=pod-reader --user=jane
```

### 10. Create a ClusterRole that can create deployments, and bind it to ServiceAccount cicd in namespace app.

```bash
kubectl create clusterrole deploy-creator --verb=create --resource=deployments
kubectl create clusterrolebinding cicd-deploy --clusterrole=deploy-creator --serviceaccount=app:cicd
```

### 11. Check whether ServiceAccount cicd in namespace app can delete pods.

```bash
kubectl auth can-i delete pods -n app --as=system:serviceaccount:app:cicd
```

### 12. Create a ServiceAccount build-bot in namespace ci.

```bash
kubectl create serviceaccount build-bot -n ci
```

### 13. List all CRDs in the cluster.

```bash
kubectl get crd
```

### 14. Install the Helm chart bitnami/nginx as release web in namespace web, creating the namespace.

```bash
helm install web bitnami/nginx -n web --create-namespace
```

### 15. Show all Helm releases in all namespaces.

```bash
helm list -A
```

### 16. Show the default values of a Helm chart.

```bash
helm show values bitnami/nginx
```

### 17. Apply a Kustomize directory ./overlays/prod.

```bash
kubectl apply -k ./overlays/prod
```

### 18. Which interfaces let Kubernetes plug in networking, storage and the container runtime?

CNI (network) · CSI (storage) · CRI (runtime)

### 19. Switch kubectl to context k8s-prod.

```bash
kubectl config use-context k8s-prod
```

### 20. Set the default namespace for the current context to dev.

```bash
kubectl config set-context --current --namespace=dev
```

### 21. On a node, the kubelet must use containerd. Which file holds the kubelet's settings?

```bash
/var/lib/kubelet/config.yaml
```

### 22. Prepare a node for kubeadm: which kernel setting must be on for pod networking?

net.ipv4.ip_forward = 1
