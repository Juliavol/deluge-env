#!/usr/bin/env bash
set -x
sudo mkdir -p /etc/ansible
chmod 600 ~/.ssh/id_rsa
sudo cp ~/ansible_hosts /etc/ansible/hosts
IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo -n "${IP}" >> ~/ansible/vars.yml
echo -n '"' >> ~/ansible/vars.yml
sleep 30
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i ansible_hosts ~/ansible/configure_base_server.yml

#ansible-playbook -i ansible_hosts ~/ansible/install-docker.yml
ansible-playbook --limit 'all:!jenkins-master' ~/ansible/install-docker.yml
ansible-playbook -i ansible_hosts ~/ansible/k8s-common.yml
ansible-playbook -i ansible_hosts ~/ansible/k8s-master.yml
ansible-playbook -i ansible_hosts ~/ansible/jenkins.yml
ansible-playbook -i ansible_hosts ~/ansible/k8s-minion.yml
