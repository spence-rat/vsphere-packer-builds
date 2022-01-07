# ----------------------------------------------------------------------------
# Name:         vsphere.pkrvars.hcl
# Description:  Common vSphere variables for Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/15/2021
# ----------------------------------------------------------------------------

# vCenter Settings
vcenter_username        = ""
vcenter_password        = ""

# vCenter Configuration
vcenter_server          = ""
vcenter_datacenter      = ""
vcenter_cluster         = ""
vcenter_datastore       = ""
vcenter_network         = ""
vcenter_iso_datastore   = ""
vcenter_insecure        = true
vcenter_content_library = ""

# VM Settings
vm_cdrom_remove         = true
vm_convert_template     = true
vm_ip_timeout           = "20m"
vm_shutdown_timeout     = "15m"