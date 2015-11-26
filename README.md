# Ansible in Docker

### Setup

You will need to ensure that this container is executed with any private keys
needed to deploy mounted inside /tmp on the docker host. This can be done by
creating a symlink to your private key and attaching the volume at container
runtime. See run.sh for details.

```
Kevins-MacBook-Pro-3:docker-ansible kjones$ ls -l .vagrant.d/
lrwxr-xr-x   1 kjones  staff   45 Nov 26 10:59 insecure_private.key@ -> /Users/kjones/.vagrant.d/insecure_private_key
```
