#!/bin/bash

if [ -a /etc/coreos/bootstrap ]
then
  ansible-playbook deploy.yml -i inventory/hosts --ask-vault-pass
else
  ansible-playbook bootstrap.yml -i inventory/hosts
fi

