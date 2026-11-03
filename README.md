# Kubernetes Administration Lab

[![Validate manifests](https://github.com/denizomerf/cka-lab/actions/workflows/validate.yml/badge.svg)](https://github.com/denizomerf/cka-lab/actions/workflows/validate.yml)

Hands-on notes, manifests and runbooks from operating Kubernetes clusters: building and upgrading with kubeadm, securing workloads, wiring networking and storage, and troubleshooting broken nodes and control planes.

Every manifest is checked in CI against the Kubernetes API schemas (kubeconform), linted with yamllint, and scripts are checked with shellcheck.

## 📁 What's inside

| Path | Contents |
|---|---|
| [`manifests/workloads`](manifests/workloads) | Deployment with rolling updates, probes, resources, non-root security context and HPA · native sidecar logging · CronJob |
| [`manifests/scheduling`](manifests/scheduling) | Taints & tolerations, node affinity, topology spread, pod anti-affinity, static pods |
| [`manifests/networking`](manifests/networking) | Default-deny NetworkPolicies with DNS, app-to-db and ingress allow rules · Ingress with TLS · Gateway API canary (90/10) |
| [`manifests/storage`](manifests/storage) | Static PV/PVC binding · EBS CSI StorageClass with `WaitForFirstConsumer` and expansion |
| [`manifests/security`](manifests/security) | Least-privilege RBAC for users and CI ServiceAccounts · ResourceQuota and LimitRange |
| [`runbooks`](runbooks) | [Troubleshooting](runbooks/troubleshooting.md) · [kubeadm upgrade](runbooks/kubeadm-upgrade.md) · [etcd restore](runbooks/etcd-restore.md) |
| [`scripts`](scripts) | [`etcd-backup.sh`](scripts/etcd-backup.sh): timestamped, verified etcd snapshots with rotation |
| [`notes`](notes) | Task-style Q&A by domain: [architecture](notes/01-cluster-architecture.md), [workloads & scheduling](notes/02-workloads-scheduling.md), [networking](notes/03-services-networking.md), [storage](notes/04-storage.md), [troubleshooting](notes/05-troubleshooting.md), [kubectl speed](notes/06-kubectl-productivity.md) |

## 🧪 Try it

Any lab cluster works (kind, minikube, kubeadm, or a free [Killercoda](https://killercoda.com/playgrounds/scenario/kubernetes) playground):

```bash
kubectl apply -f manifests/workloads/web-deployment.yaml
kubectl rollout status deployment/web
kubectl get pods,svc,hpa -l app=web

kubectl create namespace prod
kubectl apply -f manifests/networking/network-policies.yaml
```

## ⚡ Shell setup

```bash
alias k=kubectl
export do='--dry-run=client -o yaml'      # k run tmp --image=nginx $do > pod.yaml
export now='--force --grace-period=0'     # k delete pod x $now
source <(kubectl completion bash) && complete -o default -F __start_kubectl k
```
