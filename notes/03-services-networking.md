# Services & Networking

Services, CoreDNS, NetworkPolicies, Ingress, Gateway API, kube-proxy and CNI.

### 1. Expose deployment web on port 80 as a ClusterIP Service.

```bash
kubectl expose deployment web --port=80 --target-port=8080
```

### 2. Expose deployment web as a NodePort Service.

```bash
kubectl expose deployment web --port=80 --type=NodePort
```

### 3. A Service does not work. What is the FIRST thing to check?

```bash
kubectl get endpoints <svc>   # empty = the selector does not match any pod labels
```

### 4. Test DNS for Service web in namespace default from a temporary pod.

```bash
kubectl run tmp --image=busybox:1.36 --rm -it --restart=Never -- nslookup web
```

### 5. What is the full DNS name of Service db in namespace data?

db.data.svc.cluster.local

### 6. Where is CoreDNS configured?

ConfigMap coredns in namespace kube-system (Corefile)

### 7. Write a NetworkPolicy that denies ALL ingress to every pod in namespace prod.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: {name: deny-all, namespace: prod}
spec:
  podSelector: {}
  policyTypes: [Ingress]
```

### 8. NetworkPolicy: allow ingress to pods app=db only from pods app=api on TCP 5432. Write the spec.

```yaml
spec:
  podSelector:
    matchLabels: {app: db}
  policyTypes: [Ingress]
  ingress:
  - from:
    - podSelector:
        matchLabels: {app: api}
    ports:
    - protocol: TCP
      port: 5432
```

### 9. In a NetworkPolicy, allow traffic from all pods in namespaces labeled team=blue.

```yaml
from:
- namespaceSelector:
    matchLabels: {team: blue}
```

### 10. TRICK: what is the difference between these two `from` blocks?

```yaml
# A
- namespaceSelector: {}
- podSelector: {}
# B
- namespaceSelector: {}
  podSelector: {}
```

A = **OR** (two separate rules) · B = **AND** (both conditions in the same rule)

### 11. Create an Ingress web-ing: host shop.example.com, path / → Service web port 80.

```bash
kubectl create ingress web-ing --rule="shop.example.com/=web:80"
```

### 12. Gateway API: which three objects are used, from infrastructure to route?

GatewayClass → Gateway → HTTPRoute

### 13. HTTPRoute: send 90% of traffic to web-v1 and 10% to web-v2. Which field?

```yaml
backendRefs:
- name: web-v1
  port: 80
  weight: 90
- name: web-v2
  port: 80
  weight: 10
```

### 14. Which component programs Service rules (iptables/IPVS) on each node?

kube-proxy (DaemonSet)

### 15. Where are CNI plugin configs stored on a node?

```bash
/etc/cni/net.d/   # plugin binaries: /opt/cni/bin/
```

### 16. Find the Pod CIDR range given to node01.

```bash
kubectl get node node01 -o jsonpath='{.spec.podCIDR}'
```
