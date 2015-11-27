#!/bin/bash

ansible-playbook -i inventory/hosts bootstrap.yml
ansible-playbook -i inventory/hosts deploy.yml
