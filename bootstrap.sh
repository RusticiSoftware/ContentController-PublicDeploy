#!/usr/bin/env bash
#
# Installs all of the necessary dependencies for running the Ansible playbooks.  You should run this script
# on your Ansible control server.
#
if [ "$(whoami)" != "root" ]; then
    echo "You must use sudo to run this script."
    exit -1
fi

# Get the original user for running commands that don't need sudo (such as pip)
ORIGINAL_USER=${SUDO_USER:-${USERNAME:-unknown}}

apt -y install python python-dev python-pip

sudo -u ${ORIGINAL_USER} pip install Jinja2==3.0.3 ansible==2.8.6
sudo -u ${ORIGINAL_USER} pip install boto boto3 botocore
