# Apply updates and cleanup Apt cache
#
apt-get update; apt-get -y dist-upgrade
#apt-get -y autoremove
#apt-get -y cleanup
#apt-get -y install docker.io 

# Disable swap - generally recommended for K8s, but otherwise enable it for other workloads
#
echo "Disabling Swap"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Reset the machine-id value. This has known to cause issues with DHCP
#
echo "Reset Machine-ID"
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Modify startup for vmware tools per VMware (https://kb.vmware.com/s/article/59687)
#
sed -i '/^\[Unit]*/a After=dbus.service' /lib/systemd/system/open-vm-tools.service

# Reset any existing cloud-init state
#
echo "Reset Cloud-Init"
#disable cloud-init: touch /etc/cloud/cloud-init.disabled
cloud-init clean -s -l

# update MOTD
echo "
    __  __                     __          __       
   / / / /___  ____ ___  ___  / /   ____ _/ /_      
  / /_/ / __ \/ __ `__ \/ _ \/ /   / __ `/ __ \     
 / __  / /_/ / / / / / /  __/ /___/ /_/ / /_/ /     
/_/ /_/\____/_/ /_/ /_/\___/_____/\__,_/_.___/      
                                              
" >> /etc/motd
mkdir /home/packer/.ssh/ && touch /home/packer/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmuvt1lKtWmXIPcz9gEOuPv0g9XVdV5UO1SRVUQs8pV ssh keys for packer" >> /home/packer/.ssh/authorized_keys
  # install smallstep cli tools
  sudo curl -L -o step https://dl.step.sm/s3/cli/docs-ssh-host-step-by-step/step-linux-0.17.5 && sudo install -m 0755 -t /usr/bin step

  # install smallstep ssh utilities
  sudo curl -LO https://dl.step.sm/s3/ssh/docs-ssh-host-step-by-step/step-ssh_0.19.5_amd64.deb && sudo dpkg -i step-ssh_0.19.5_amd64.deb

  # configure step ca
  step ca bootstrap --team="thebrynards"


