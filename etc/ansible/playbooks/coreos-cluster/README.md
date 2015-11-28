# CoreOS / Kubernetes Ansible Playbook

In this playbook I will deploy a 3 server CoreOS / Vagrant / Kubernetes cluster.

### Variables

Variables used for reference...
```
# Kubernetes related variables
MASTER_HOST: "172.17.8.101"
ETCD_ENDPOINTS: "http://172.17.8.101:4001,http://172.17.8.102:4001,http://172.17.8.103:4001"
POD_NETWORK: "10.2.0.0/16"
SERVICE_IP_RANGE: "10.3.0.0/24"
K8S_SERVICE_IP: "10.3.0.1"
DNS_SERVICE_IP: "10.3.0.10"
ADVERTISE_IP: Null
MASTER_IP: "172.17.8.101"
CA_CERT: "/etc/kubernetes/ssl/ca.pem"
APISERVER_KEY: "/etc/kubernetes/ssl/apiserver-key.pem"
APISERVER_CERT: "/etc/kubernetes/ssl/apiserver-key.pem"
WORKER_KEY: "/etc/kubernetes/ssl/worker-key.pem"
WORKER_CERT: "/etc/kubernetes/ssl/worker.pem"
ADMIN_KEY: "/etc/kubernetes/ssl/admin-key.pem"
ADMIN_CERT: "/etc/kubernetes/ssl/admin.pem"

# SSL related variables
ca_srl: <secret - not sure if this is ever needed again>
ca_key_pem: |
    "<insert KEY here>"
ca_pem: |
    "<insert KEY here>"
worker_key_pem: |
    "<insert KEY here>"
worker_csr: |
    "<insert KEY here>"
worker_pem: |
    "<insert KEY here>"
admin_key_pem: |
    "<insert KEY here>"
admin_csr: |
    "<insert KEY here>"
admin_pem: |
    "<insert KEY here>"

# Ansible learned variables
ansible_eth1.ipv4.address
```

### SSL Keys

Below are the commands needed to generate SSL certificates for this deployment.
More details: https://coreos.com/kubernetes/docs/latest/openssl.html

Creare custom OpenSSL configuration
```
# ./openssl.cnf

[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
IP.1 = ${K8S_SERVICE_IP}
IP.2 = ${MASTER_HOST}
```

Generate CA certificate and key
```
$ openssl genrsa -out ca-key.pem 2048
$ openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
```

Generate API server certificate and keys
```
$ openssl genrsa -out apiserver-key.pem 2048
$ openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
$ openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf
```

```
$ openssl genrsa -out worker-key.pem 2048
$ openssl req -new -key worker-key.pem -out worker.csr -subj "/CN=kube-worker"
$ openssl x509 -req -in worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out worker.pem -days 365
```

```
$ openssl genrsa -out admin-key.pem 2048
$ openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
$ openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365
```

### API Examples

Create Namespace
```
curl -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"kube-system"}}' "http://127.0.0.1:8080/api/v1/namespaces"
```

### Troubleshooting and Debugging

For more details please read the following FAQ.
https://github.com/kubernetes/kubernetes/wiki/Debugging-FAQ

Test the Master node API is running

```
$ curl -w '\n' http://127.0.0.1:8080/version
{
  "major": "1",
  "minor": "0",
  "gitVersion": "v1.0.6",
  "gitCommit": "388061f00f0d9e4d641f9ed4971c775e1654579d",
  "gitTreeState": "clean"
}
```

Check kubelet service is running..
```
systemctl status kubelet.service
```

### References
https://coreos.com/kubernetes/docs/latest/getting-started.html
https://coreos.com/os/docs/latest/booting-on-vagrant.htmll
https://coreos.com/os/docs/latest/getting-started-with-docker.html
https://coreos.com/etcd/docs/0.4.7/etcd-api/
