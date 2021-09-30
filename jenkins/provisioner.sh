#!/bin/bash

function install_jenkins() {
    sudo apt update
    sudo apt install -y openjdk-8-jdk
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sudo apt install -y jenkins
    sudo ufw allow 8080
}

function install_ansible() {
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
}

function install_terraform() {
    export TERRAFORM_LATEST_VERSION=1.0.3
    sudo apt install -y unzip
    wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_LATEST_VERSION}/terraform_${TERRAFORM_LATEST_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_LATEST_VERSION}_linux_amd64.zip
    sudo mv terraform /usr/bin/terraform
    rm terraform_${TERRAFORM_LATEST_VERSION}_linux_amd64.zip
    sudo apt-get install -y default-mysql-client
}

function install_aws_cli() {
  export AWSCLI_VERSION=2.1.29
  cd /tmp
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWSCLI_VERSION.zip" -o "awscli.zip"
  unzip awscli.zip
  sudo ./aws/install
  cd /tmp
  rm -rf aws
}


function main() {
  install_jenkins
  install_ansible
  install_terraform
  install_aws_cli

}

main