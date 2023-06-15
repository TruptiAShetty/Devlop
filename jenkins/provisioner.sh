#!/bin/bash


function install_java() {
        sudo apt update
        sudo apt install -y openjdk-8-jdk
}


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
function install_dotnet() {
        sudo apt update
        wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        dpkg -i packages-microsoft-prod.deb
        apt-get update
        apt-get install -y apt-transport-https
        apt-get update
        apt-get install -y dotnet-sdk-3.1
}

function install_node() {
       sudo apt update
       curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
       bash nodesource_setup.sh
       apt install nodejs -y
}

function install_sonarqube() {
    sudo apt update
    sudo su -
    cd  /opt
    wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip
    apt install unzip
    unzip sonarqube-8.9.2.46101.zip
    chmod -R 777 /opt/sonarqube-8.9.2.46101/
    useradd sonaradmin
    id sonaradmin
    ufw allow 9000
    chown -R sonaradmin:sonaradmin sonarqube-8.9.2.46101
    cd sonarqube-8.9.2.46101/extensions/plugins
    wget https://github.com/racodond/sonar-json-plugin/releases/download/2.3/sonar-json-plugin-2.3.jar
    cd ../../../
    sudo su - sonaradmin
    cd /opt/sonarqube-8.9.2.46101/bin/linux-x86-64
    sudo /sonar.sh start
}


function main() {
  install_java
  install_jenkins
  install_ansible
  install_terraform
  install_aws_cli
  install_dotnet
  install_node
  install_sonarqube
}

main
