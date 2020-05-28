#!/bin/bash

if [ ! -d ".ssh" ];
then
    sudo mkdir /home/centosuser/.ssh
    echo "created new .ssh directory"
else
    sudo rm -rf /home/centosuser/.ssh
    echo "removed existing .ssh directory"
    sudo mkdir /home/centosuser/.ssh
    echo "reinstalled .ssh directory"
fi

yes "y" | ssh-keygen -t rsa -N "" -f /home/centosuser/.ssh/id_rsa

yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.20
yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.21
yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.22
yes "yes" | ssh-copy-id -i ~/.ssh/id_rsa root@192.168.1.23

ansible mynodes -i ./hosts.ini -b -m raw -a "apk -U add python3"
ansible mynodes -i ./hosts.ini -m ping
ansible-playbook webserver.yaml -i ./hosts.ini

curl 192.168.1.20
curl 192.168.1.21
curl 192.168.1.22
curl 192.168.1.23
