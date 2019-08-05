#!/usr/bin/env bash
sudo mkdir -p /var/lib/jenkins/init.groovy.d/
sudo cp /tmp/init.groovy.d/* /var/lib/jenkins/init.groovy.d/
sudo cp /tmp/1_setup_users.groovy /var/lib/jenkins/init.groovy.d/1_setup_users.groovy
sudo cp /tmp/jenkins_configure.ec2.groovy /var/lib/jenkins/init.groovy.d/jenkins_configure.ec2.groovy
sudo cp /tmp/jenkins_configure_ssh.groovy /var/lib/jenkins/init.groovy.d/jenkins_configure_ssh.groovy
sudo cp /tmp/2_dockerhub_credentials.groovy /var/lib/jenkins/init.groovy.d/2_dockerhub_credentials.groovy
#sudo service jenkins restart