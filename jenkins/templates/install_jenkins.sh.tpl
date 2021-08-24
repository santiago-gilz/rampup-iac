#!/bin/bash

#Installing main dependencies
sudo dnf update -y
sudo dnf module enable nodejs:14 -y
sudo dnf install -y nodejs git java-1.8.0-openjdk-devel wget curl

#Install jenkins
sudo wget –O jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo mv jenkins.repo /etc/yum.repos.d/
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo dnf install -y jenkins

#Allows jenkins to execute sudo commands 
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo systemctl restart jenkins
sudo systemctl enable jenkins

#Install Docker
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce --nobest 
sudo systemctl restart docker
sudo systemctl enable docker
sudo usermod -aG docker centos
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

#Verify docker
docker --version
docker run hello-world

#Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Install and enable python3
sudo dnf install -y python3
sudo alternatives --set python /usr/bin/python3
sudo dnf install -y python3-pip unzip

#Install ansible
sudo dnf install -y epel-release
sudo dnf install -y ansible
sudo dnf install -y python3-boto3

# Firewalld options to access http through browser
sudo dnf install -y firewalld
sudo systemctl enable firewalld
sudo systemctl restart firewalld
sudo firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080
sudo firewall-cmd --runtime-to-permanent
sudo firewall-cmd --reload
