# ----------------------------------------------------------------------------
# Name:         variables.auto.pkrvars.hcl
# Description:  Common vSphere variables for Windows 2016 Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/17/2021
# ----------------------------------------------------------------------------

# ISO Settings
os_iso_url                  = "https://packer-iso-files.s3.us-west-2.amazonaws.com/os/microsoft/windows2016/windows2016_noprompt.iso"
os_iso_checksum             = "sha256:5efc60a4d6cbff2b6c0b9c1bf2b7f615492cca6704d117473ce5cdcc2409d769"

# OS Meta Data
os_family                   = "Windows"
os_version                  = "2016"

# VM Hardware Settings
vm_firmware                 = "efi-secure"
vm_cpu_sockets              = 2
vm_cpu_cores                = 1
vm_mem_size                 = 2048
vm_nic_type                 = "vmxnet3"
vm_disk_controller          = ["lsilogic-sas"]
vm_disk_size                = 51200
vm_disk_thin                = true
vm_cdrom_type               = "sata"
template_library_name       = "windows_server_2016"

# VM OS Settings
vm_os_type                  = "windows9Server64Guest"
vm_tools_update             = true
build_username              = "Administrator"
build_password              = "packer"

# Provisioner Settings
script_files                = [ "../scripts/win2016-config.ps1" ]
inline_cmds                 = [ "Get-EventLog -LogName * | ForEach { Clear-EventLog -LogName $_.Log }" ]