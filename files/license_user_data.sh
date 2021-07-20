#!/bin/bash
sudo yum update -y


yum install yum-utils pygpgme
rpm --import 'https://dl.teradici.com/Km54fEkDz4RD1kRR/pcoip-license-server/gpg.4581DD6ACC910D6F.key'
curl -1sLf 'https://dl.teradici.com/Km54fEkDz4RD1kRR/pcoip-license-server/config.rpm.txt?distro=el&codename=7' > /tmp/teradici-pcoip-license-server.repo
yum-config-manager --add-repo '/tmp/teradici-pcoip-license-server.repo'
yum -q makecache -y --disablerepo='*' --enablerepo='teradici-pcoip-license-server'

sudo yum install -y pcoip-license-server

sudo pcoip-set-password -p 1P@ssw0rd! -n ${admin_password}
