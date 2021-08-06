#!/bin/bash

# Install ansible

sudo dnf install -y epel-release git
sudo dnf install -y ansible
ansible-galaxy collection install community.general

# Clone ansible repo
if [ ! -d rampup-sysconfig ]; then
    git clone https://github.com/santiago-gilz/rampup-sysconfig.git
fi
cd rampup-sysconfig
ansible-playbook playbooks/${TARGET_APP}.yml --extra-vars '${extra_vars}' -vv

