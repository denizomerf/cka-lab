# Runbook: Troubleshooting a Kubernetes cluster

Work from the outside in: **cluster → node → control plane → workload → network**.

## 1. Is the API server reachable?

| Symptom | Check |
|---|---|
| `connection refused` from kubectl | `crictl ps -a \| grep kube-apiserver`, then `crictl logs <id>`; look for typos in `/etc/kubernetes/manifests/kube-apiserver.yaml` |
| Wrong cluster / unauthorized | `kubectl config current-context`, `kubectl config view --minify` |
| Certificate errors | `kubeadm certs check-expiration` |

## 2. Node is `NotReady`

```bash
ssh node01
systemctl status kubelet
journalctl -u kubelet --no-pager | tail -50
systemctl status containerd
```

Common causes: kubelet stopped/disabled (`systemctl enable --now kubelet`), wrong path or typo in `/var/lib/kubelet/config.yaml`, container runtime down, CNI not installed.

## 3. Control plane components

| Symptom | Broken component |
|---|---|
| All new pods stay `Pending` with no node assigned | kube-scheduler |
| Deployment scaled but no new pods / ReplicaSets | kube-controller-manager |
| Nothing works, API times out | etcd or kube-apiserver |

All four are static pods in `/etc/kubernetes/manifests/`: fix the manifest and the kubelet restarts them.

## 4. Pod states

| Status | First commands | Usual cause |
|---|---|---|
| `Pending` | `kubectl describe pod <p>` → Events | Insufficient CPU/memory, taint without toleration, unbound PVC, nodeSelector matches nothing |
| `ImagePullBackOff` | `kubectl describe pod <p>` | Wrong image/tag, private registry without `imagePullSecrets` |
| `CrashLoopBackOff` | `kubectl logs <p> --previous`, `kubectl describe pod <p>` | App error, bad command/args, failing liveness probe, missing config |
| `ContainerCreating` (stuck) | `kubectl describe pod <p>` | Volume/ConfigMap/Secret cannot mount, CNI not working |
| `OOMKilled` | `kubectl describe pod <p>` → Last State | Memory limit too low |

## 5. Service / network

```bash
kubectl get endpoints <svc>                     # empty? the selector does not match pod labels
kubectl get pods --show-labels
kubectl run tmp --image=busybox:1.36 --rm -it --restart=Never -- wget -qO- <svc>:<port>
kubectl run tmp --image=busybox:1.36 --rm -it --restart=Never -- nslookup <svc>
kubectl -n kube-system get pods -l k8s-app=kube-dns   # CoreDNS healthy?
kubectl get netpol -A                              # a NetworkPolicy blocking traffic?
```

## 6. Useful one-liners

```bash
kubectl get events -A --sort-by=.metadata.creationTimestamp
kubectl top pods -A --sort-by=cpu
kubectl top pods -l app=api --sort-by=memory --no-headers | head -1 | awk '{print $1}'
```
