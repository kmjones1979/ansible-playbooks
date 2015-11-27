#!/bin/bash

#ansible-playbook -i inventory/hosts bootstrap.yml
ansible-playbook -vvvv -i inventory/hosts deploy.yml --ask-vault-pass
