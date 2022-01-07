# ----------------------------------------------------------------------------
# Name:         common.pkrvars.hcl
# Description:  Common variables for Packer builds
# Author:       Ralph Brynard
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         09/15/2021
# ----------------------------------------------------------------------------

# Boot Settings
vm_boot_wait            = "2s"
vm_boot_order           = "disk,cdrom"

# Build Settings
build_repo              = "https://github.com/RalphBrynard/homelab-automation.git"
build_branch            = "main"

# Packer Settings
http_port_min           = 8000
http_port_max           = 8010
http_ip                 = "10.0.10.220"
manifest_output_dir     = "./output/"