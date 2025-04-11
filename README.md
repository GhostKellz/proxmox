# Proxmox Repository

## 📁 Directory Structure
- `helper-scripts/ct/`: Scripts for container management.
- `helper-scripts/vm/`: Scripts for virtual machine management.
- `helper-scripts/network/`: Scripts for network-related tasks.
- `network/`: Core networking structure including bridges, VLANs, SDN.
- `vpn/`: Mesh VPN overlay solutions such as Tailscale, Headscale, and WireGuard.
- `firewall/`: Firewall strategies for Proxmox clusters.
  - `firewall/datacenter/`: Rules and policies at the datacenter level.
  - `firewall/node/`: Node-specific firewall configurations.
- `pbs/`: Proxmox Backup Server deployment notes.
- `zfs/`: Configuration and tuning for ZFS as a storage backend.
- `templates/`: Template files for container and VM configurations.

## 🛠️ Purpose
This repository is intended to simplify the deployment, configuration, and management of containers, virtual machines, backup strategies, and networking within Proxmox environments — both homelab and production.

---

## 🛠️ Proxmox Tweaks

### Disk Performance Optimization
- Enable **writeback caching** on the disks for better performance.
- Set up **ZFS compression** for storage optimization.

### Backup and Restore Tweaks
- Use **Proxmox Backup Server** for efficient backups of VMs/CTs.
- Automate backup schedules with **cron jobs** or **Proxmox GUI**.

### Resource Allocation
- Set **CPU and memory limits** for VMs and containers to prevent over-utilization.
- Adjust **IO limits** using the `io` option in the VM/CT config files.

### High Availability Setup
- Ensure **Corosync** is running for HA setup.
- Configure **Proxmox cluster** for automatic failover and load balancing.

---

## 🌐 Networking (See `network/`)
- Manage core networking: **bridges**, **VLANs**, **bonding**, and **MTU tuning**
- Proxmox SDN components:
  - **Zones**, **VNETs**, **VXLAN tunnels**, and **routed subnets**
  - Designed for scalable, multi-tenant environments with overlay support
- Includes guidance for:
  - Physical NIC setup, jumbo frames
  - MAC address assignment, NAT routing

---

## 🔐 Firewall Strategies (See `firewall/`)
- Maintain security with **node-level** and **datacenter-level** rules
- Include examples for service-specific ACLs:
  - PBS, SSH, Docker services, SDN zones
- Can be extended for **external firewall coordination** with FortiGate, OPNSense, etc.

---

## 🖥️ LXC / VM Configurations

### LXC Configurations
- Assign **CPU/memory resources** using config files or GUI
- Use **overlayfs** for faster storage performance
- Enable nested networking, mount options, and DNS overrides

### VM Configurations
- Use **QEMU/KVM with virtio** drivers for optimal disk and network I/O
- Set up **ZFS**, **LVM**, or **Ceph** storage backends
- Use **SSD caching**, **discard** options, and proper boot ordering
- Support nested virtualization, PCI passthrough, and TPM/UEFI booting

---

## 🛠️ Helper Scripts

### Container Management
- `helper-scripts/ct/`: Automate container creation, backup, and config tweaks

### Virtual Machine Management
- `helper-scripts/vm/`: Snapshots, migration, cloning helpers

### Network Tasks
- `helper-scripts/network/`: VLAN tagging, IP route rules, bridge configs

---

## 📁 Templates
- Includes basic pre-built **LXC** and **QEMU VM** templates with clean networking and ZFS presets

---

## 📡 VPN and Remote Access (See `vpn/`)
- Transitioning away from Tailscale to Headscale + WireGuard
- Configuration guides, SDN mesh planning, and service overlays

---

## 💾 Storage (See `zfs/`, `pbs/`, and future `ceph/`)
- **ZFS** ARC tuning, mirror vs RAIDZ2, SSD caching, compression
- **PBS** deployment notes across local and cloud nodes
- **Ceph** (planned): scalable, distributed storage backend ideal for clustered Proxmox environments. Useful for shared storage across nodes without relying on external NAS/SAN.

Feel free to expand on each section with your own experience or add specific configurations you’ve used in production or homelab Proxmox environments.

Maintained by [Christopher Kelley](https://github.com/ghostkellz)

