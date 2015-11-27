#!/bin/bash

cat /etc/hosts etc/hosts

docker build --no-cache -t docker-ansible .
