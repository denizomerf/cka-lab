# Storage

PersistentVolumes, PersistentVolumeClaims, StorageClasses, access modes and volume expansion.

### 1. Write a PersistentVolume pv-log: 1Gi, ReadWriteOnce, hostPath /data/log.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata: {name: pv-log}
spec:
  capacity: {storage: 1Gi}
  accessModes: [ReadWriteOnce]
  hostPath: {path: /data/log}
```

### 2. Write a PVC data-pvc: 500Mi, ReadWriteOnce, StorageClass fast.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata: {name: data-pvc}
spec:
  storageClassName: fast
  accessModes: [ReadWriteOnce]
  resources:
    requests: {storage: 500Mi}
```

### 3. Mount PVC data-pvc into a pod at /usr/share/nginx/html.

```yaml
volumes:
- name: data
  persistentVolumeClaim:
    claimName: data-pvc
# container:
volumeMounts:
- name: data
  mountPath: /usr/share/nginx/html
```

### 4. A PVC is stuck in Pending. Name 3 common causes.

```bash
1) No PV matches the size / accessMode / storageClass
2) StorageClass name is wrong or missing
3) volumeBindingMode: WaitForFirstConsumer (binds only when a pod uses it)
```

### 5. Name the access modes and their short forms.

ReadWriteOnce (RWO) · ReadOnlyMany (ROX) · ReadWriteMany (RWX) · ReadWriteOncePod (RWOP)

### 6. Make StorageClass fast the default StorageClass.

```bash
kubectl patch storageclass fast -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

### 7. StorageClass field that delays PV creation until a pod uses the PVC?

```yaml
volumeBindingMode: WaitForFirstConsumer
```

### 8. Can you expand a PVC? What is required?

Yes, edit spec.resources.requests.storage; StorageClass must have allowVolumeExpansion: true

### 9. Which volume type is empty at pod start and deleted with the pod?

emptyDir
