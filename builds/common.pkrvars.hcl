# ----------------------------------------------------------------------------
# Name:         common.pkrvars.hcl
# Description:  Common variables for Packer builds
# Author:       Ralph Brynard
# URL:          https://github.com/RalphBrynard/vsphere-packer-builds.git
# Date:         01/10/2022
# ----------------------------------------------------------------------------

# Boot Settings
vm_boot_wait            = "2s"
vm_boot_order           = "disk,cdrom"

# Build Settings
build_repo              = "https://github.com/RalphBrynard/homelab-automation.git"
build_branch            = "issue-#1"

# Packer Settings
http_port_min           = 8000
http_port_max           = 8010
http_ip                 = "192.168.254.3"
manifest_output_dir     = "./output/"