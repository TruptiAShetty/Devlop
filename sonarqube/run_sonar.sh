#!/bin/bash -xe
sleep 120
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
su - sonaradmin bash -c "cd /opt/sonarqube-8.9.2.46101/bin/linux-x86-64 && ./sonar.sh start"
echo "run sonar server"
