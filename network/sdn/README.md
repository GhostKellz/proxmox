# Proxmox SDN Overview

This section covers **Proxmox Software Defined Networking (SDN)**, a flexible, scalable system for building virtual networks across nodes in a Proxmox cluster. SDN integrates seamlessly with native Proxmox tools and provides a cleaner abstraction layer for complex or multi-tenant network environments.

For in-depth reference, see the [official Proxmox SDN documentation](https://pve.proxmox.com/pve-docs/chapter-pvesdn.html).

---

## ✨ Key Features
- **Centralized SDN management via GUI and CLI**
- **VXLAN support** for overlay L2 tunnels
- **EVPN and BGP** for dynamic route distribution
- **Zone isolation** with routed, NAT, or bridged modes
- **VNETs with IPv4/IPv6 subnets**, DHCP/NAT control
- **High scalability** across large Proxmox clusters

---

## 🔧 Core Components

### Zones
Zones define how a virtual network behaves. Each VNET is tied to a zone.
- `bridge`: Acts like a traditional L2 bridge
- `vlan`: Tagged VLAN access over physical interfaces
- `qinq`: Double VLAN tagging (VLAN stacking)
- `evpn`: Advanced routing, requires BGP config

### VNETs
Virtual networks that operate within a zone and span across multiple hosts.
- Can contain multiple subnets
- Assigned to VMs or containers via SDN interface type
- Routed or NAT'ed depending on zone type

### Subnets
IP address ranges (IPv4 or IPv6) assigned to VNETs.
- Used for tenant isolation or overlay routing
- Support for `dhcp`, `nat`, and `snat` options

### VXLAN
Encapsulation method to transport Layer 2 over Layer 3
- Configurable with unique VXLAN IDs
- Can span across any cluster node
- MTU of 9000+ recommended for best performance

---

## 🧠 Usage Scenarios
- **Multi-tenant segmentation** with VNET + routed subnets
- **Overlay tunnels** across cloud and on-prem nodes
- **Replace physical VLANs** with VXLAN overlays
- **Firewall + NAT within isolated zones**

---

## 📁 Directory Structure
```
/network/sdn
  ├── vnets/     # Virtual networks and their configs
  ├── zones/     # Bridge, VLAN, QinQ, EVPN zone examples
  ├── subnets/   # Allocated IP address pools, DHCP/NAT examples
  ├── vxlan/     # Overlay encapsulation strategies
  └── README.md
```

---

## 🔗 External References
- [Proxmox SDN Documentation (Wiki)](https://pve.proxmox.com/wiki/Proxmox_VE_SDN)
- [Proxmox SDN Chapter (Official Manual)](https://pve.proxmox.com/pve-docs/chapter-pvesdn.html)

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)

