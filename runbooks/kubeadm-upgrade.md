# Runbook: Upgrade a kubeadm cluster by one minor version

Kubernetes supports upgrading **one minor version at a time** (e.g. 1.33 → 1.34). Control plane first, then workers one by one.

## Control plane node

```bash
# 1. Point the package repo at the new minor version, then:
sudo apt-get update
sudo apt-cache madison kubeadm               # find the exact patch version

sudo apt-mark unhold kubeadm
sudo apt-get install -y kubeadm=1.34.1-1.1
sudo apt-mark hold kubeadm

sudo kubeadm upgrade plan
sudo kubeadm upgrade apply v1.34.1           # on additional control planes: kubeadm upgrade node

# 2. Upgrade kubelet and kubectl
kubectl drain controlplane --ignore-daemonsets
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=1.34.1-1.1 kubectl=1.34.1-1.1
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload && sudo systemctl restart kubelet
kubectl uncordon controlplane
```

## Each worker node

```bash
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data   # from the control plane

ssh node01
sudo apt-mark unhold kubeadm && sudo apt-get install -y kubeadm=1.34.1-1.1 && sudo apt-mark hold kubeadm
sudo kubeadm upgrade node
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=1.34.1-1.1 kubectl=1.34.1-1.1
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload && sudo systemctl restart kubelet
exit

kubectl uncordon node01
kubectl get nodes                                                   # VERSION column shows v1.34.1
```

## Before you start

- Take an etcd snapshot ([`scripts/etcd-backup.sh`](../scripts/etcd-backup.sh)).
- Check certificate expiry: `kubeadm certs check-expiration`.
- Make sure PodDisruptionBudgets allow the drain.
