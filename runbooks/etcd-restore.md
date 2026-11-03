# Runbook: Restore etcd from a snapshot (kubeadm)

1. **Restore into a new data directory** (never over the live one):

   ```bash
   etcdutl snapshot restore /var/backups/etcd/etcd-<timestamp>.db \
     --data-dir=/var/lib/etcd-restore
   ```

2. **Point the etcd static pod at it.** Edit `/etc/kubernetes/manifests/etcd.yaml` and change the `etcd-data` volume:

   ```yaml
   volumes:
     - hostPath:
         path: /var/lib/etcd-restore
         type: DirectoryOrCreate
       name: etcd-data
   ```

3. **Wait for the kubelet to recreate etcd and the API server** (1–2 minutes):

   ```bash
   watch crictl ps   # etcd and kube-apiserver come back up
   kubectl get pods -A
   ```

4. **Verify** that objects created after the snapshot are gone and objects from before it are back.

Notes
- The certificate paths for `etcdctl` are in `etcd.yaml` (`--cert-file`, `--key-file`, `--trusted-ca-file`).
- On a multi-member cluster, restore every member with the same snapshot and matching `--initial-cluster` flags.
