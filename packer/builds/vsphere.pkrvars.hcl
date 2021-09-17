# ----------------------------------------------------------------------------
# Name:         vsphere.pkrvars.hcl
# Description:  Common vSphere variables for Packer builds
# Author:       Ralph Brynard (@DevopsPleb)
# URL:          https://github.com/RalphBrynard/homelab-automation.git
# Date:         09/15/2021
# ----------------------------------------------------------------------------

# vCenter Settings
vcenter_username        = "VCENTER_USER"
vcenter_password        = "VCENTER_PASS"

# vCenter Configuration
vcenter_server          = "VCENTER_SERVER"
vcenter_datacenter      = "VCENTER_DC"
vcenter_cluster         = "VCENTER_CLUSTER"
vcenter_datastore       = "VCENTER_DS"
vcenter_network         = "VCENTER_NETWORK"
vcenter_iso_datastore   = "VCENTER_ISO_DS"
vcenter_insecure        = true
vcenter_content_library = "vsphere-content-library"

# VM Settings
vm_cdrom_remove         = true
vm_convert_template     = true
vm_ip_timeout           = "20m"
vm_shutdown_timeout     = "15m"