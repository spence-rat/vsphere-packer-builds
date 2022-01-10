# ----------------------------------------------------------------------------
# Name:         vsphere.pkrvars.hcl
# Description:  Common vSphere variables for Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/15/2021
# ----------------------------------------------------------------------------

# vCenter Settings
vcenter_username                = "packer.prod@thebrynards.com"
vcenter_password                = "NY*gFjK7Gg!VX#V5ecohgL4w^tPNrB$$QHWrX4amg9S@Q"

# vCenter Configuration
vcenter_server                  = "vcsa01.thebrynards.com"
vcenter_datacenter              = "dc01.ustx.home"
vcenter_cluster                 = "cluster01"
vcenter_datastore               = "esxi02-ds03"
vcenter_network                 = "staging vlan"
vcenter_iso_datastore           = "[] /vmimages/tools-isoimages/windows.iso"
vcenter_insecure                = true
vcenter_folder                  = "builds"
content_library_destination     = "packer_templates"
library_vm_destroy              = false
convert_to_ovf                  = true

# VM Settings
vm_cdrom_remove                 = true
vm_convert_template             = true
vm_ip_timeout                   = "20m"
vm_shutdown_timeout             = "15m"