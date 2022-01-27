#!/bin/bash

function install_java() {
	sudo apt update
        sudo su -
        apt install -y openjdk-11-jre-headless
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
  install_sonarqube
  install_java

}

main
