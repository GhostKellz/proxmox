#!/usr/bin/env bash
# Customized Proxmox Helper Script for Technitium DNS
# Author: CK Customized, Original by tteck
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://technitium.com/dns/

APP="Technitium DNS"
var_tags="dns"
var_cpu="1"
var_ram="512"
var_disk="2"
var_os="debian"
var_version="12"
var_unprivileged="1"

read -p "Enter Container Name: " CT_NAME
read -p "Enter Container ID (e.g., 200-299 for this node): " CT_ID
read -p "Enter IP Address (e.g., 192.168.x.x/24): " IP_ADDRESS
read -p "Enter Gateway IP (e.g., 192.168.x.1): " GATEWAY
read -p "Enter Network Interface (e.g., vmbr1): " NET_INTERFACE
read -p "Enter VLAN Tag (if any, otherwise press Enter): " VLAN_TAG
read -p "Enter Storage Target (e.g., local-zfs): " STORAGE_TARGET

if [ -z "$CT_NAME" ] || [ -z "$CT_ID" ] || [ -z "$IP_ADDRESS" ] || [ -z "$GATEWAY" ] || [ -z "$NET_INTERFACE" ] || [ -z "$STORAGE_TARGET" ]; then
  echo "All fields except VLAN Tag are required. Exiting."
  exit 1
fi

source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -d /etc/dns ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Updating ${APP}"

  if ! dpkg -s aspnetcore-runtime-8.0 >/dev/null 2>&1; then
    wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb &>/dev/null
    apt-get update &>/dev/null
    apt-get install -y aspnetcore-runtime-8.0 &>/dev/null
    rm packages-microsoft-prod.deb
  fi
  bash <(curl -fsSL https://download.technitium.com/dns/install.sh) &>/dev/null
  msg_ok "Updated Successfully"
  exit
}

start

# Build Container with Custom Parameters
pct create $CT_ID $STORAGE_TARGET:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst \
    -hostname $CT_NAME \
    -storage $STORAGE_TARGET \
    -rootfs ${var_disk}G \
    -net0 name=eth0,bridge=$NET_INTERFACE,ip=$IP_ADDRESS,gw=$GATEWAY${VLAN_TAG:+,tag=$VLAN_TAG} \
    -unprivileged $var_unprivileged \
    -features nesting=1 \
    -cores $var_cpu \
    -memory $var_ram \
    -tags $var_tags

# Start the container
pct start $CT_ID
sleep 5

# Install Technitium DNS
pct exec $CT_ID -- bash -c "wget -qO- https://download.technitium.com/dns/install.sh | bash"

msg_ok "${APP} setup completed successfully!"
echo -e "${INFO} Access it using: http://${IP_ADDRESS%%/*}:5380"
