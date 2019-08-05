#!/bin/bash
sudo apt install openjdk-8-jdk openjdk-8-jre -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install default-jre jenkins -y
sudo systemctl start jenkins
sudo ufw allow 8080