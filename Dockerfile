# Latest version of centos

FROM centos:centos7

MAINTAINER Kevin Jones <kevin@nginx.com>

# install dependencies
RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip

# add Ansible directory
RUN mkdir -p /etc/ansible/
ADD etc/ansible /etc/ansible

# install Ansible
RUN pip install ansible

# install coreos bootstrap role
RUN ansible-galaxy install defunctzombie.coreos-bootstrap
