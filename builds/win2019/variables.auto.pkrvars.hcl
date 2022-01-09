# ----------------------------------------------------------------------------
# Name:         variables.auto.pkrvars.hcl
# Description:  Common vSphere variables for Windows 2019 Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/23/2021
# ----------------------------------------------------------------------------

# ISO Settings
os_iso_url         = "https://d3kp7h9g268qlg.cloudfront.net/packer-iso-files/os/microsoft/windows2019_noprompt.iso"
os_iso_checksum    = "sha256:EED5622504A975F6839D8F1CA9E6EC66A1EF2E1100626A5A41C195B5A271B575"

# OS Meta Data
os_family           = "Windows"
os_version          = "2019"

# VM Hardware Settings
vm_firmware         = "efi-secure"
vm_cpu_sockets      = 2
vm_cpu_cores        = 1
vm_mem_size         = 2048
vm_nic_type         = "vmxnet3"
vm_disk_controller  = ["pvscsi"]
vm_disk_size        = 51200
vm_disk_thin        = true
vm_cdrom_type       = "sata"

# Build Settings
vm_cdrom_remove         = false
vm_convert_template     = true

# VM OS Settings
vm_os_type          = "windows2019srv_64Guest"
vm_tools_update     = true
build_username      = "Administrator"
build_password      = "packer"

# Provisioner Settings
script_files        = [ "../../scripts/win2019-config.ps1" ]
inline_cmds         = [ "Get-EventLog -LogName * | ForEach { Clear-EventLog -LogName $_.Log }" ]