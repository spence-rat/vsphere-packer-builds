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