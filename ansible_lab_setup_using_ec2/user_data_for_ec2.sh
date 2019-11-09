#!/bin/bash
sudo useradd devops --create-home --password "$(openssl passwd -1 "redhat")" --shell /bin/bash
sudo usermod -a -G wheel devops
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd.service




##!/bin/bash
#useradd devops --create-home --password "$(openssl passwd -1 "redhat")" --shell /bin/bash
#echo "devops   ALL=(ALL)   NOPASSWD: ALL" > /etc/sudoers.d/ansible
#sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
#systemctl restart sshd.service
