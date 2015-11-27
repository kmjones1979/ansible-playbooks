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

# DNS hack to get hosts file inside the container
RUN cp /etc/hosts /tmp/hosts
RUN mkdir -p -- /lib-override && cp /lib/x86_64-linux-gnu/libnss_files.so.2 /lib-override
RUN perl -pi -e 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2
ENV LD_LIBRARY_PATH /lib-override
