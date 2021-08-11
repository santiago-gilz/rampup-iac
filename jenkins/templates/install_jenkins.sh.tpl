#!/bin/bash

#Install jenkins
sudo dnf update -y
sudo dnf install -y java-1.8.0-openjdk-devel wget
sudo wget –O jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo mv jenkins.repo /etc/yum.repos.d/
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo dnf install -y jenkins
sudo systemctl restart jenkins
sudo systemctl enable jenkins

#Allows jenkins to execute sudo commands 
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sudo systemctl restart jenkins

#Install Docker
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce --nobest -y
sudo systemctl restart docker
sudo systemctl enable docker
sudo usermod -aG docker centos
sudo usermod -aG docker jenkins

#Verify docker
docker --version
docker run hello-world

#Install docker compose
sudo dnf install curl -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Install and enable python3
sudo dnf install -y python3
sudo alternatives --set python /usr/bin/python3
sudo dnf install -y python3-pip unzip
