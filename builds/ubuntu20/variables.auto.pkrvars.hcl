# ----------------------------------------------------------------------------
# Name:         variables.auto.pkrvars.hcl
# Description:  Common vSphere variables for Ubuntu 20.04 Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/15/2021
# ----------------------------------------------------------------------------

# ISO Settings
#os_iso_file         = "ubuntu-20.04.2-live-server-amd64.iso"
#os_iso_path         = "os/ubuntu/20.04"
os_iso_url           = "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"
os_iso_checksum      = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"

# OS Meta Data
os_family           = "Linux"
os_version          = "Ubuntu Linux"

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
vm_os_type          = "ubuntu64Guest"
build_username      = "packer"
build_password      = "vagrant"

# Provisioner Settings
script_files        = [ "../scripts/ubuntu20-config.sh" ]
inline_cmds         = []

# Packer Settings
http_directory      = "config"
http_file           = "user-data"
ssh_timeout         = "2000s"