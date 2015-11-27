# Ansible in Docker

This contains an Dockerfile for Ansible inside of a docker container and also
serves as a static place to keep all Ansible playbooks.

### Setup

#### For CentOS setup please follow the following steps.

Setup/Build
```
sudo yum clean all && \
    sudo yum -y install epel-release && \
    sudo yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip && \
    sudo pip install ansible
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

### Playbooks

Playbooks are located in /etc/ansible/playbooks.
