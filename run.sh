#!/bin/bash

docker run -i -t --net="host" --privileged=true --rm \
  --name docker-ansible docker-ansible \
  /bin/bash
  #ansible-playbook /$2 -i /$1 -s -k -u vagrant --ask-vault-pass
