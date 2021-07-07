#!/bin/bash
sudo yum update -y
sudo yum install yum-utils -y 

if [ -e '/usr/bin/dpkg' ]; then
    curl -s https://45c8b52b37e25bfc3a5cec41ef7e6e6fcb2e3478bdaf591d:@packagecloud.io/install/repositories/leostream/9_0_prod/script.deb.sh | sudo bash
    sudo apt-get install -y leostream-broker
else 
    curl -s https://45c8b52b37e25bfc3a5cec41ef7e6e6fcb2e3478bdaf591d:@packagecloud.io/install/repositories/leostream/9_0_prod/script.rpm.sh | sudo bash
    if [ -e '/usr/bin/zypper' ]; then
        sudo zypper -n install leostream-broker
    else 
        sudo yum -y install leostream-broker
    fi
fi
echo "Please reboot to start the Leostream broker"

sudo reboot



# /opt/bin/psql  -t -U ${db_admin} -h ${db_endpoint} -p 5432 -d ${db_db_name}