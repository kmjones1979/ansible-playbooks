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

First ensure SSH Agent is running on your Ansible server
```
ps aux | grep ssh-agent
```

Then add your Vagrant private key.
```
ssh-add /path/to/private.key
```
