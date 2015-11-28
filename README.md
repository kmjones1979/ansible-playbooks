# Ansible in Docker or Vagrant 

This README contains instructions on setting up either a Docker container or
Vagrant server running CentOS 7 to deploy via Ansible.

This repository also contains a collection of useful playbooks.

### Setup

#### Vagrant / CentOS / Ansible Instructions

 - Requires [Vagrant] (https://www.vagrantup.com/downloads.html)

Setup/Build
```
cd /path/to/setup/centos/vm/
vagrant init centos/7; vagrant up --provider virtualbox
vagrant up
```

Run
```
vagrant ssh
```

Install Ansible and Dependencies

<sub>*Note: defunctzombie.coreos-bootstrap only needed for coreos ansible deployments - because coreos
does not ship with python libraries installed*</sub>
```
sudo yum clean all && \
    sudo yum -y install epel-release && \
    sudo yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip && \
    sudo pip install ansible && sudo ansible-galaxy install defunctzombie.coreos-bootstrap
```

Test Ansible
```
ansible --version
```

#### Docker / Ansible Instructions

 - Requires [Docker] (https://www.docker.com/)

Setup/Build
```
docker build --no-cache -t docker-ansible .
```

Run
```
docker run -i -t --rm \
  --name docker-ansible docker-ansible \
  /bin/bash
```

Test
```
ansible --version
```

### Encryption of Files with Ansible

You might want to encrypt/decrypt contents of variable files or other
secrets with Ansible Vault.

#### Vault encryption

To encrypt a file with Ansible vault use the following command. These 
should be added to .gitignore as well.
```
ansible-vault encrypt <file>
```

#### Vault decryption

If you need to decrypt a file to make changes you can do so with the
following command.
```
ansible-vault decrypt <file>
```

### Vagrant SSH keys

First ensure SSH Agent is running on your Ansible server, if not then start
it using eval.
```
eval $(ssh-agent)
```

Then add your Vagrant private key.
```
ssh-add /path/to/private.key
```

### Playbooks

Playbooks can be located in etc/ansible/playbooks. Below is a link
to each playbook along with a brief description of their use case. Each
playbook contains a seperate README to assist with deployment.

[CoreOS / Kubernetes] (https://github.com/kmjones1979/docker-ansible/tree/master/etc/ansible/playbooks/coreos-cluster)
This playbook will configure Kubernetes on a Vagrant CoreOS cluster


