#!/bin/bash

ansible-playbook deploy.yml -i inventory/hosts --ask-vault-pass
