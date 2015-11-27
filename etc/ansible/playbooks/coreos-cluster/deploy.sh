#!/bin/bash

# ansible deployment

#ansible-playbook -i inventory/hosts bootstrap.yml
ansible-playbook -vvvv -i inventory/hosts deploy.yml --ask-vault-pass

#if [ -a /tmp/insecure_private.key ]
#then
#  shred -uvf -n 10 /tmp/insecure_private.key
#fi
