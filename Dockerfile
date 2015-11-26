# Latest version of centos

FROM centos:centos7

MAINTAINER Toshio Kuratomi <tkuratomi@ansible.com>

# install dependencies
RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip

# add Ansible directory
RUN mkdir -p /etc/ansible/
ADD etc/ansible /etc/ansible

# install Ansible
RUN pip install ansible
