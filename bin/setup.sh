#!/bin/bash

sudo yum clean all && \
    sudo yum -y install epel-release && \
    sudo yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip \
    sudo pip install ansible && sudo ansible-galaxy install defunctzombie.coreos-bootstrap
