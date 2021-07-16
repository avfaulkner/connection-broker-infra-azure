#!/bin/bash
sudo yum update -y
sudo yum install yum-utils -y 

curl -O https://dl.teradici.com/jW2L91G4bZJW1jGd/pcoip-cmsg/raw/names/pcoip-cmsg-el8-zip/versions/21.03.2/pcoip-cmsg_21.03.2_el8.zip

unzip pcoip-cmsg_21.03.2_el8.zip

sudo sh ./cm_setup.sh