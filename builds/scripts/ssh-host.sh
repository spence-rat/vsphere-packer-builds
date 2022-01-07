#!/bin/bash

# TODO:
# - How can this fail. What does a user do when it fails? Can they just re-run?
# - Activate/deactivate (look at the `step-ssh` script and how it does this)
#   * If activate fails, deactivate.
# - Add cool spinners while slow stuff happens


# TODO: Dependencies:
# * bash
# * curl
# * sed
# * dpkg / yum / dnf

# Fail if this script is not run as root.
if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root"
   exit 1
fi

export STEPPATH=/root/.step

# Architecture detection
arch=$(uname -m)
case $arch in
    x86_64) arch="amd64" ;;
    x86) arch="386" ;;
    i686) arch="386" ;;
    i386) arch="386" ;;
    aarch64) arch="arm64" ;;
    armv5*) arch="armv5" ;;
    armv6*) arch="armv6" ;;
    armv7*) arch="armv7" ;;
esac

if ! [ "$arch" = "amd64" ]; then
    echo "This script only works on amd64 instances, for now"
    exit 1
fi

rpm_pkg="step-ssh_0.19.5_x86_64.rpm"
deb_pkg="step-ssh_0.19.5_amd64.deb"

# Main
while [ $# -gt 0 ]; do
    case "$1" in
        --team)
            team="$2"
            shift
            shift
            ;;
        --token)
            token="$2"
            shift
            shift
            ;;
        --hostname)
            hostname="$2"
            shift
            shift
            ;;
        --tag)
            # TODO: Check tag value ($2) and make sure it matches a tag regex (key=value)
            tags="$tags $1 $2"
            shift
            shift
            ;;
        --principal)
            principals="$principals $1 $2"
            shift
            shift
            ;;
        --is-bastion)
            is_bastion="true"
            shift
            ;;
        --bastion)
            bastion="$2"
            shift
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Prompt for required parameters
if [ -z "$team" ]; then
    read -p "Team: " team < /dev/tty
    team=$(echo "$team" | tr -d '"')
fi

if [ -z "$token" ]; then
    read -p "Enrollment token: " token < /dev/tty
    token=$(echo "$token" | tr -d '"')
fi

if [ -z "$hostname" ]; then
    read -p "Hostname: " hostname < /dev/tty
    hostname=$(echo "$hostname" | tr -d '"')
fi

if [ -z "$tags" ]; then
    read -p "Tag: " tags < /dev/tty
    # Take space-separated tags ("foo=bar baz=blort") and insert `--tag` flags
    # ("--tag foo=bar --tag baz=blort")`. This pipeline is too clever, so here's
    # what it does:
    #   1. Replaces multiple consecutive spaces with a single space using tr
    #   2. Trims trailing whitespace
    #   3. Replaces remaining space characters with " --tag "
    if ! [ -z "$tags"]; then
        tags="--tag $(echo $tags | tr -d '"' |  tr -s ' ' | sed -e 's/[[:space:]]*$//' | sed 's/[[:space:]]/ --tag /g')"
    fi
fi

echo -e "team:\t$team"
echo -e "token:\t$token"
echo -e "hostname:\t$hostname"
echo -e "tags:\t$tags"
echo -e "principals:\t$principals"
echo -e "is-bastion:\t$is_bastion"
echo -e "bastion:\t$bastion"

set -e

# Install `step` CLI
echo "Downloading and installing step CLI and step-ssh utilities..."
curl -s -L -o step "https://files.smallstep.com/step-linux-0.15.16" && install -m 0755 -t /usr/bin step
rm -f "step"

# Install `step-ssh` utilities
if hash dpkg 2>/dev/null; then
    curl -s -LO "https://files.smallstep.com/${deb_pkg}"
    dpkg -i "${deb_pkg}"

    rm -f ${deb_pkg}
else
    if grep -q '^\(CentOS\|Red Hat\)[^0-9]*8\..' /etc/redhat-release; then
        curl -s -LO "https://files.smallstep.com/${rpm_pkg}"
        dnf -y install "${rpm_pkg}"
        rm -f ${rpm_pkg}
    else
        curl -s -LO "https://files.smallstep.com/${rpm_pkg}"
        yum -y install "${rpm_pkg}"
        rm -f ${rpm_pkg}
    fi
fi

# Configure `step` to connect to your CA
echo "Configuring step-ssh..."
step ca bootstrap --team="$team"

# Get an SSH host certificate
if [[ -n "$principals" ]]; then
    step ssh certificate $hostname /etc/ssh/ssh_host_ecdsa_key.pub \
        --host --sign --provisioner "Service Account" --token $token --principal $hostname $principals
else
    step ssh certificate $hostname /etc/ssh/ssh_host_ecdsa_key.pub \
        --host --sign --provisioner "Service Account" --token $token
fi

# Configure sshd to use certificate authentication
step ssh config --host --set Certificate=ssh_host_ecdsa_key-cert.pub \
                       --set Key=ssh_host_ecdsa_key

# Activate PAM/NSS modules
echo "Activating step-ssh..."
step-ssh activate "$hostname"

# Register the host and add group(s)
echo "Registering host"
if [ "$is_bastion" = "true" ]; then
    if [[ -n $bastion ]]; then
        step-ssh-ctl register $tags --hostname "$hostname" --bastion "$bastion" --is-bastion
    else
        step-ssh-ctl register $tags --hostname "$hostname" --is-bastion
    fi
else
    if [[ -n $bastion ]]; then
        step-ssh-ctl register $tags --hostname "$hostname" --bastion "$bastion"
    else
        step-ssh-ctl register $tags --hostname "$hostname"
    fi
fi
