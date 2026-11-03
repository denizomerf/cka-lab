#!/usr/bin/env bash
# Take a timestamped etcd snapshot on a kubeadm control plane node and keep the last N.
# Usage: sudo ./etcd-backup.sh [backup_dir] [keep]
set -euo pipefail

BACKUP_DIR="${1:-/var/backups/etcd}"
KEEP="${2:-7}"
PKI=/etc/kubernetes/pki/etcd
SNAPSHOT="${BACKUP_DIR}/etcd-$(date +%Y%m%d-%H%M%S).db"

mkdir -p "${BACKUP_DIR}"

ETCDCTL_API=3 etcdctl snapshot save "${SNAPSHOT}" \
  --endpoints=https://127.0.0.1:2379 \
  --cacert="${PKI}/ca.crt" \
  --cert="${PKI}/server.crt" \
  --key="${PKI}/server.key"

# Verify the snapshot is readable before trusting it
etcdutl snapshot status "${SNAPSHOT}" --write-out=table

# Rotate old snapshots
ls -1t "${BACKUP_DIR}"/etcd-*.db | tail -n +"$((KEEP + 1))" | xargs -r rm --

echo "Saved ${SNAPSHOT}"
