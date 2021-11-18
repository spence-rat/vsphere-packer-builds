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
'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmuvt1lKtWmXIPcz9gEOuPv0g9XVdV5UO1SRVUQs8pV ssh keys for packer'
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
    __  __                     __          __       
   / / / /___  ____ ___  ___  / /   ____ _/ /_      
  / /_/ / __ \/ __ `__ \/ _ \/ /   / __ `/ __ \     
 / __  / /_/ / / / / / /  __/ /___/ /_/ / /_/ /     
/_/ /_/\____/_/ /_/ /_/\___/_____/\__,_/_.___/   
        
        $RELEASE ($BUILDDATE)
        $DOCS

ISSUE
sudo ln -sf /etc/issue /etc/issue.net

# Install smallstep
sudo curl -L -o step https://dl.step.sm/s3/cli/docs-ssh-host-step-by-step/step-linux-0.18.0 && sudo install -m 0755 -t /usr/bin step
sudo curl -LO "https://dl.step.sm/s3/ssh/docs-ssh-host-step-by-step/step-ssh_0.19.5_x86_64.rpm" && sudo yum -y install step-ssh_0.19.5_x86_64.rpm

# Initial smallstep bootstrap
step ca bootstrap --team="thebrynards"

## Final cleanup actions
echo ' - Executing final cleanup tasks ...'
sudo echo -n > /etc/machine-id
echo ' - Configuration complete'