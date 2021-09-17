#!/bin/bash
# Prepare Photon 4 template for vSphere cloning
# @author Michael Poore
# @website https://blog.v12n.io

## Apply updates
echo ' - Updating the guest operating system ...'
sudo tdnf upgrade tdnf -y --refresh 2>&-
sudo tdnf distro-sync -y 2>&-

## Configure SSH server
echo ' - Configuring SSH server daemon ...'
sudo sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
sudo sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

## Create Ansible user
echo ' - Creating local user for Ansible integration ...'
sudo groupadd ansible
sudo useradd -g ansible -G wheel -m -s /bin/bash ansible
echo ansible:$(openssl rand -base64 14) | sudo chpasswd
sudo mkdir /home/ansible/.ssh
sudo cat << EOF > /home/ansible/.ssh/authorized_keys
REPLACEWITHANSIBLEUSERKEY
EOF
sudo chown -R ansible:ansible /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
sudo chmod 600 /home/ansible/.ssh/authorized_keys

## Install trusted SSL CA certificates
#echo ' - Installing trusted SSL CA certificates ...'
#pkiServer="REPLACEWITHPKISERVER"
#pkiCerts=("rootca.cer" "issuingca.cer")
#cd /etc/pki/ca-trust/source/anchors
#for cert in ${pkiCerts[@]}; do
#    sudo wget -q $pkiServer/$cert
#done
#sudo update-ca-trust extract

## Setup MoTD
OS=$(head -n 1 /etc/photon-release)
BUILD=$(tail -n 1 /etc/photon-release | awk -F"=" '{print (NF>1)? $NF : ""}')
BUILDDATE=$(date +"%y%m")
RELEASE="$OS ($BUILD)"
DOCS="https://github.com/RalphBrynard/vsphere-packer-builds"
sudo cat << ISSUE > /etc/issue

      ___           ___           ___           ___                    ___       ___           ___     
     /\__\         /\  \         /\__\         /\  \                  /\__\     /\  \         /\  \    
    /:/  /        /::\  \       /::|  |       /::\  \                /:/  /    /::\  \       /::\  \   
   /:/__/        /:/\:\  \     /:|:|  |      /:/\:\  \              /:/  /    /:/\:\  \     /:/\:\  \  
  /::\  \ ___   /:/  \:\  \   /:/|:|__|__   /::\~\:\  \            /:/  /    /::\~\:\  \   /::\~\:\__\ 
 /:/\:\  /\__\ /:/__/ \:\__\ /:/ |::::\__\ /:/\:\ \:\__\          /:/__/    /:/\:\ \:\__\ /:/\:\ \:|__|
 \/__\:\/:/  / \:\  \ /:/  / \/__/~~/:/  / \:\~\:\ \/__/          \:\  \    \/__\:\/:/  / \:\~\:\/:/  /
      \::/  /   \:\  /:/  /        /:/  /   \:\ \:\__\             \:\  \        \::/  /   \:\ \::/  / 
      /:/  /     \:\/:/  /        /:/  /     \:\ \/__/              \:\  \       /:/  /     \:\/:/  /  
     /:/  /       \::/  /        /:/  /       \:\__\                 \:\__\     /:/  /       \::/__/   
     \/__/         \/__/         \/__/         \/__/                  \/__/     \/__/         ~~  
        
        $RELEASE ($BUILDDATE)
        $DOCS

ISSUE
sudo ln -sf /etc/issue /etc/issue.net

## Final cleanup actions
echo ' - Executing final cleanup tasks ...'
sudo echo -n > /etc/machine-id
echo ' - Configuration complete'