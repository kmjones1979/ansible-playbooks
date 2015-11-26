# Latest version of centos

FROM centos:centos7

MAINTAINER Toshio Kuratomi <tkuratomi@ansible.com>

RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools git python-pip

RUN mkdir -p /etc/ansible/playbooks/
ADD etc/ansible/playbooks /etc/ansible/playbooks

RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts

RUN pip install ansible
