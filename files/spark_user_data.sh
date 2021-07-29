#!/bin/bash
sudo yum update -y
sudo yum install yum-utils -y 

# Download JDK

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.rpm

# Install
rpm -ivh jdk-8u102-linux-x64.rpm

# Download Spark Gateay:

cd /usr/local/bin
wget http://remotespark.com/view/SparkGateway.zip
unzip SparkGateway.zip

# Download SUSE scripts:
cd ./SparkGateway
wget http://remotespark.com/view/SparkGateway_SUSE.sh
wget http://remotespark.com/view/SparkGateway_SUSE.service
sudo chmod a+x SparkGateway_SUSE.sh

# Confirm SparkGateay is working
#java -jar SparkGateway.jar


# Install as a service

cp SparkGateway_SUSE.service /etc/systemd/system/SparkGateway.service
sudo touch /etc/systemd/system/SparkGateway.service
sudo chmod 664 /etc/systemd/system/SparkGateway.service

sudo systemctl daemon-reload
sudo systemctl enable SparkGateway
sudo systemctl start SparkGateway


# 9. Check service status
# systemctl status SparkGateway


# A. Open port 80 on firewall
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# B. Enable SSL on gateway
# cd /usr/local/bin/SparkGateway

# vi gateway.conf
# Press I entering insert mode, and add the following 2 lines:
# keyStore=keystore.jks
# keyStorePassword=password

