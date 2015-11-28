# CoreOS / Kubernetes / Vagrant Ansible Playbook

In this README I will give instructions to complete the following:
 - Setup an Ansible / CentOS Vagrant Box
 - Setup a CoreOS Vagrant Cluster (3+ nodes)
 - Deploy a Kubernetes Cluster across each CoreOS server

### Vagrant Setup

First you will need to setup both an Ansible server to deploy from 
along with a CoreOS cluster to setup and congigure Kuberenetes on.

#### Create CentOS / Ansible Vagrant VM

First provision a CentOS Vagrant server to install Ansible on.

```
$ cd /path/to/creat/vagrant/box
$ vagrant init centos/7; vagrant up --provider virtualbox
```

Install Ansible and dependencies

```
$ vagrant ssh
$ sudo yum clean all && \
    sudo yum -y install epel-release && \
    sudo yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip && \
    sudo pip install ansible && sudo ansible-galaxy install defunctzombie.coreos-bootstrap
```

You can test Ansible is properly installed by peforming the following...
```
$ ansible --version
$ ansible -m setup localhost
```

#### Create CoreOS Vagrant Cluster

For more detailed instructions please visit the docs on the CoreOS
site here: https://coreos.com/os/docs/latest/booting-on-vagrant.html

First checkout the CoreOS Vagrant git repository.

```
$ git clone https://github.com/coreos/coreos-vagrant.git
$ cd coreos-vagrant
```

Copy samples and edit with your configuration.

```
$ cp config.rb.sample config.rb
$ cp user-data.sample user-data
```

Grab a discovery token.

<sub> Note: if your cluster is larger then 3 change the size accordingly. </sub>
```
$ curl -w "\n" 'https://discovery.etcd.io/new?size=3'
https://discovery.etcd.io/0e72b94351a613bb8480ef02e2f19e87
```

Add the discovery token URL to the user-data file you copied.
```
# ./user-data
discovery: https://discovery.etcd.io/<token>
```

Edit config.rb to have the proper number of instances in your cluster.
```
# ./config.rb
# Size of the CoreOS cluster created by Vagrant
$num_instances=3
```

Load up your CoreOS Vagrant cluster.
```
$ vagrant up
```

Check the status of the Vagrant cluster.
```
$ vagrant status
Current machine states:

core-01                   running (virtualbox)
core-02                   running (virtualbox)
core-03                   running (virtualbox)
```

Check SSH access.
```
$ vagrant ssh core-01

Last login: Sat Nov 28 05:43:53 2015 from 172.17.8.1
CoreOS alpha (870.3.0)
core@core-01 ~ $ 
```

### SSL Keys

Below are the commands needed to generate SSL certificates for this deployment.
More details: https://coreos.com/kubernetes/docs/latest/openssl.html

Create a custom OpenSSL configuration.

<sub>Note: The values for IP.1 and IP.2 need to be added to the configuration before 
generating the certificate and keys, these values are explained below under "Variables" section. </sub>
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

Generate API certificate and key
```
$ openssl genrsa -out apiserver-key.pem 2048
$ openssl req -new -key apiserver-key.pem -out apiserver.csr -subj "/CN=kube-apiserver" -config openssl.cnf
$ openssl x509 -req -in apiserver.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out apiserver.pem -days 365 -extensions v3_req -extfile openssl.cnf
```

Generate Worker certificate and key
```
$ openssl genrsa -out worker-key.pem 2048
$ openssl req -new -key worker-key.pem -out worker.csr -subj "/CN=kube-worker"
$ openssl x509 -req -in worker.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out worker.pem -days 365
```

Generate Admin certificate and key
```
$ openssl genrsa -out admin-key.pem 2048
$ openssl req -new -key admin-key.pem -out admin.csr -subj "/CN=kube-admin"
$ openssl x509 -req -in admin.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out admin.pem -days 365
```

Be sure to encrypt these values into your Ansible variable configuration and/or store them in a secure location.

### Variables

Variables used for reference... Deployment will require a vars.yml in both the
kubernetes-master role and the kubernetes-slave role. It is reccomended to add the
values below and encrypt the file with ansible-vault.

Variable files examples will be placed in the following locations. Simply remove the .example
extension, add your variable values and encrytp the files with amsible-vault.
 - ../roles/kubernetes-master/vars/vars.yml.example
 - ../roles/kubernetes-slave/vars/vars.yml.example

```
* ../vars/vars.yml

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
    "<insert KEY DATA here>"
ca_pem: |
    "<insert KEY DATA here>"
worker_key_pem: |
    "<insert KEY DATA here>"
worker_csr: |
    "<insert KEY DATA here>"
worker_pem: |
    "<insert KEY DATA here>"
admin_key_pem: |
    "<insert KEY DATA here>"
admin_csr: |
    "<insert KEY DATA here>"
admin_pem: |
    "<insert KEY DATA here>"
apiserver_pem: |
    "<insert KEY DATA here>"
apiserver_key_pem: |
    "<insert KEY DATA here>"

# Ansible learned variables
ansible_eth1.ipv4.address
```

### Ansible Deployment

Clone the repository.
```
git clone git@github.com:kmjones1979/docker-ansible.git
```

Edit the Ansible hosts file to include inventory of your Vagrant CoreOS cluster.
```
vim etc/ansible/playbooks/coreos-cluster/inventory/hosts
```

Example hosts file...
```
# ./inventory/hosts

coreos-cluster]
172.17.8.101
172.17.8.102
172.17.8.103

[coreos-cluster:vars]
ansible_ssh_user=core
ansible_python_interpreter="PATH=/home/core/bin:$PATH python"

[kubernetes-master]
172.17.8.101

[kubernetes-master:vars]
ansible_ssh_user=core
ansible_python_interpreter="PATH=/home/core/bin:$PATH python"

[kubernetes-slave]
172.17.8.102
172.17.8.103

[kubernetes-slave:vars]
ansible_ssh_user=core
ansible_python_interpreter="PATH=/home/core/bin:$PATH python"
```

Deploy. 

<sub>Tip: Use the flag -vvvv to troubleshoot Ansible deployment issues</sub>
```
cd etc/ansible/playbooks/coreos-cluster/ 
ansible-playbook -i inventory/hosts deploy.yml --ask-vault-pass
```

Manually Deploy DNS Add-On (not working in Ansible playbook)
```
kubectl create -f /home/core/dns-addon.yml
```

### API Examples

Create Namespace
```
$ curl -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"kube-system"}}' "http://127.0.0.1:8080/api/v1/namespaces"
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
core@core-01 ~ $ systemctl status kubelet.service
● kubelet.service
   Loaded: loaded (/etc/systemd/system/kubelet.service; enabled; vendor preset: disabled)
   Active: active (running) since Sat 2015-11-28 02:28:58 UTC; 3h 39min ago
 Main PID: 609 (kubelet)
   Memory: 64.7M
      CPU: 5min 20.312s
...
```

### References
https://coreos.com/kubernetes/docs/latest/getting-started.html
https://coreos.com/os/docs/latest/booting-on-vagrant.htmll
https://coreos.com/os/docs/latest/getting-started-with-docker.html
https://coreos.com/etcd/docs/0.4.7/etcd-api/
