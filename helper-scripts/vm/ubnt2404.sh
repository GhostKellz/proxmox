#!/usr/bin/env bash
# Customized Proxmox Helper Script for Ubuntu Server VM
# Author: CK Testing...

APP="Ubuntu Server VM"
var_tags="ubuntu-vm"
var_cpu="2"
var_ram="4096"
var_disk="64"
var_os="ubuntu"
var_version="22.04"

read -p "Enter VM Name: " VM_NAME
read -p "Enter VM ID (e.g., 100, 200, 300): " VM_ID
read -p "Enter Disk Size (GB) [Default: 20]: " DISK_SIZE
read -p "Enter CPU Cores [Default: 4]: " CPU_CORES
read -p "Enter RAM (MB) [Default: 4096]: " RAM_SIZE
read -p "Enter Storage Target (e.g., local-zfs): " STORAGE_TARGET
read -p "Enter Network Interface (e.g., vmbr1): " NET_INTERFACE
read -p "Enter VLAN Tag (if any, otherwise press Enter): " VLAN_TAG
read -p "Enter IP Address (e.g., 192.168.x.x/24): " IP_ADDRESS
read -p "Enter Gateway IP (e.g., 192.168.x.1): " GATEWAY

# Set defaults if empty
DISK_SIZE=${DISK_SIZE:-20}
CPU_CORES=${CPU_CORES:-4}
RAM_SIZE=${RAM_SIZE:-4096}

if [ -z "$VM_NAME" ] || [ -z "$VM_ID" ] || [ -z "$STORAGE_TARGET" ] || [ -z "$NET_INTERFACE" ] || [ -z "$IP_ADDRESS" ] || [ -z "$GATEWAY" ]; then
  echo "All fields except VLAN Tag are required. Exiting."
  exit 1
fi

# Download Ubuntu 22.04 cloud image if it doesn't exist
if [ ! -f /var/lib/vz/template/iso/ubuntu-22.04-server-cloudimg-amd64.img ]; then
    echo "Downloading Ubuntu 22.04 cloud image..."
    wget -O /var/lib/vz/template/iso/ubuntu-22.04-server-cloudimg-amd64.img https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img
fi

# Create cloud-init config
CLOUDINIT_DIR="/var/lib/vz/snippets"
mkdir -p $CLOUDINIT_DIR
CLOUDINIT_FILE="$CLOUDINIT_DIR/$VM_NAME-cloudinit.yaml"

cat <<EOF > $CLOUDINIT_FILE
#cloud-config
hostname: $VM_NAME
manage_etc_hosts: true
users:
  - name: ubuntu
    passwd: $(openssl passwd -6 'changeme')
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    lock_passwd: false
    shell: /bin/bash
ssh_pwauth: true
EOF

# Create the VM
qm create $VM_ID \
    --name $VM_NAME \
    --memory $RAM_SIZE \
    --cores $CPU_CORES \
    --net0 virtio,bridge=$NET_INTERFACE${VLAN_TAG:+,tag=$VLAN_TAG} \
    --scsihw virtio-scsi-single \
    --ide2 $STORAGE_TARGET:cloudinit \
    --boot c \
    --bootdisk scsi0 \
    --serial0 socket \
    --vga serial0 \
    --tags $var_tags

# Import the disk
qm importdisk $VM_ID /var/lib/vz/template/iso/ubuntu-22.04-server-cloudimg-amd64.img $STORAGE_TARGET

# Attach the disk to the VM
qm set $VM_ID --scsi0 $STORAGE_TARGET:vm-$VM_ID-disk-0

# Attach the cloud-init config
qm set $VM_ID --cicustom "user=$CLOUDINIT_FILE"

# Set IP config via cloud-init
qm set $VM_ID --ipconfig0 ip=$IP_ADDRESS,gw=$GATEWAY

# Start the VM
qm start $VM_ID

echo "${APP} setup completed successfully!"
echo "You can now SSH into the server: ssh ubuntu@$IP_ADDRESS (password: changeme)"
