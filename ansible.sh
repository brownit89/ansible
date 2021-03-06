#!/bin/bash

if [ ! -d "~/.ssh" ];
then
    sudo mkdir ~/.ssh
    echo "created new .ssh directory"
else
    sudo rm -rf ~/.ssh
    echo "removed existing .ssh directory"
    sudo mkdir ~/.ssh
    echo "reinstalled .ssh directory"
fi

yes "y" | ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.20
yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.21
yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.22
yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.23

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
echo "installing epel-release"
sudo yum --disablerepo="epel" -y update ca-certificates install -y epel-release
sudo rm -rf /var/cache/yum
sudo yum install -y ansible
sudo ansible mynodes -i ./hosts.ini -b -m raw -a "apk -U add python3"
sudo ansible-playbook webserver.yaml -i ./hosts.ini

curl 192.168.1.20
curl 192.168.1.21
curl 192.168.1.22
curl 192.168.1.23
