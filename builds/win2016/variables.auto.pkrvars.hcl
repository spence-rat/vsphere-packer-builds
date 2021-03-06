# ----------------------------------------------------------------------------
# Name:         variables.auto.pkrvars.hcl
# Description:  Common vSphere variables for Windows 2016 Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/17/2021
# ----------------------------------------------------------------------------

# ISO Settings
#os_iso_url          = "https://s3truenas.s3.us-east-2.amazonaws.com/os/microsoft/server/2016/windows2016_noprompt.iso"
#os_iso_checksum     = "sha256:3e72611e4c34a6ef37d992bdc6117f09fe25d61bcfebd8f446362dff888edc9d"
os_iso_file         = "windows2016_noprompt.iso"
os_iso_path         = "os/microsoft/server/2016"

# OS Meta Data
os_family           = "Windows"
os_version          = "2016"

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

# VM OS Settings
vm_os_type          = "windows9Server64Guest"
vm_tools_update     = true
build_username      = "Administrator"
build_password      = "packer"

# Provisioner Settings
script_files        = [ "../../scripts/win2016-config.ps1",
                        "../../scripts/win-install-vmtools.ps1" ]
inline_cmds         = [ "Get-EventLog -LogName * | ForEach { Clear-EventLog -LogName $_.Log }" ]