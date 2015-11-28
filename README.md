# Ansible in Docker

This contains an Dockerfile for Ansible inside of a docker container as well
as instructions on how to setup Ansible inside Vagrant.

### Setup

#### For setup inside a Vagrant CentOS box please follow the following steps.

Setup/Build
```
git clone git@github.com:kmjones1979/vagrant-centos7.git && ./init.sh
vagrant ssh 
```

Inside your CentOS 7 Vagrant box

<sub>*Note: defunctzombie.coreos-bootstrap only needed for coreos ansible deployments - because coreos
does not ship with python libraries installed*</sub>
```
sudo yum clean all && \
    sudo yum -y install epel-release && \
    sudo yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip && \
    sudo pip install ansible && sudo ansible-galaxy install defunctzombie.coreos-bootstrap
```

Run
```
ansible-playbook --help
```

#### For Docker setup please follow the following steps.

Setup/Build
```
docker build --no-cache -t docker-ansible .
```

Run
```
docker run -i -t --rm \
  --name docker-ansible docker-ansible \
```

### SSH Keys

#### Vault encryption

To encrypt a file with Ansible vault use the following command. These 
should be added to .gitignore as well.
```
ansible-vault encrypt file
```

#### Vault decryption

If you need to decrypt a file to make changes you can do so with the
following command.
```
ansible-vault decrypt file
```

#### Vagrant SSH keys

As of right now Vagrant SSH keys will have to be manually added to your
SSH agent after they are decrypted to your Ansible server.

First ensure SSH Agent is running on your Ansible server, if not then start
it using eval.
```
ps aux | grep ssh-agent
eval $(ssh-agent)
```

Then add your Vagrant private key.
```
ssh-add /path/to/private.key
```

### Playbooks

[CoreOS / Kubernetes] (https://github.com/kmjones1979/docker-ansible/tree/master/etc/ansible/playbooks/coreos-cluster)
This playbook will configure Kubernetes on a Vagrant CoreOS cluster


