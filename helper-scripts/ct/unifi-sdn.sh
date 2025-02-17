!/usr/bin/env bash
# Customized Proxmox Helper Script for Unifi Controller
# Author: GlennR Easy Unifi script used | CK
# License: MIT
# Source: https://get.glennr.nl/unifi/install/install_latest/unifi-latest.sh

APP="Unifi Controller"
var_tags="unifi"
var_cpu="2"
var_ram="2048"
var_disk="10"
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
  if [[ ! -d /usr/lib/unifi ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Updating ${APP}"

  bash <(curl -s https://get.glennr.nl/unifi/install/install_latest/unifi-latest.sh) &>/dev/null
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

# Install Unifi Controller
pct exec $CT_ID -- bash -c "curl -sO https://get.glennr.nl/unifi/install/install_latest/unifi-latest.sh && bash unifi-latest.sh"

msg_ok "${APP} setup completed successfully!"
echo -e "${INFO} Access it using: https://${IP_ADDRESS%%/*}:8443"