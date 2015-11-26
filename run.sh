#!/bin/bash

docker run -i -t --rm \
  --name docker-ansible docker-ansible \
  ansible-playbook /$1 -s -k -u vagrant --ask-vault-pass
