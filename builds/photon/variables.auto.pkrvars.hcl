# ----------------------------------------------------------------------------
# Name:         variables.auto.pkrvars.hcl
# Description:  Common vSphere variables for Photon 4 Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/16/2021
# ----------------------------------------------------------------------------

# ISO Settings
os_iso_url          = "https://packages.vmware.com/photon/4.0/GA/iso/photon-4.0-1526e30ba.iso"
os_iso_checksum     = "md5:e0c77e9495c7bfaea20cc17be3cb145b"

# OS Meta Data
os_family           = "Linux"
os_version          = "Photon4"

# VM Hardware Settings
vm_firmware         = "bios"
vm_cpu_sockets      = 1
vm_cpu_cores        = 1
vm_mem_size         = 2048
vm_nic_type         = "vmxnet3"
vm_disk_controller  = ["pvscsi"]
vm_disk_size        = 16384
vm_disk_thin        = true
vm_cdrom_type       = "sata"

# VM OS Settings
vm_os_type          = "vmwarePhoton64Guest"
build_username      = "photon"
build_password      = "photon"

# Provisioner Settings
script_files        = [ "../../scripts/photon4-config.sh" ]
inline_cmds         = []

# Packer Settings
http_directory      = "config"
http_file           = "photon4.json"