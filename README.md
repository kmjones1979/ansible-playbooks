# Ansible in Docker

This contains an Dockerfile for Ansible inside of a docker container and also
serves as a static place to keep all Ansible playbooks.

### Setup

Build
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
