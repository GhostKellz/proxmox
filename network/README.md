# Proxmox Network Overview

This directory contains networking documentation and configuration strategies used across Proxmox hosts, clusters, and related virtual infrastructure. It includes foundational networking such as Linux bridges and VLANs, and expands into more advanced Proxmox Software Defined Networking (SDN) use cases.

The purpose of this directory is to serve as a centralized knowledge base for understanding, deploying, and maintaining network configurations within homelab and production Proxmox environments.

---

## 🔧 Networking Layers & Features

- **Bridges** (`/bridges/`):
  - Linux bridges used by Proxmox (e.g., `vmbr0`, `vmbr1`)
  - Uplinks to physical interfaces (`eth0`, `eno1`, etc.)
  - Integration with LXC, VMs, and nested virtual switches
  - `bridge_ports` specifies physical NICs or none (internal bridges)
  - `bridge_stp` and `bridge_fd` for loop avoidance and forwarding delays

- **VLANs** (`/vlans/`):
  - VLAN trunking and access port config
  - Tagged interface strategies (e.g., `vmbr0.10` for VLAN 10)
  - Allows LXC and VMs to operate on distinct VLANs
  - Integration with managed switches and firewalls

- **SDN** (`/sdn/`):
  - Proxmox Software Defined Networking configuration
  - Includes VNETs, VXLAN tunnels, Zones, and routed subnets
  - SDN is ideal for clustered environments and multi-tenant setups
  - Supports EVPN, BGP, and VXLAN underlay/overlay configurations

- **VXLAN** (`/sdn/vxlan/`):
  - Used as overlay transport for VNETs in SDN
  - Facilitates Layer 2 extension across nodes using UDP encapsulation

- **Subnets** (`/sdn/subnets/`):
  - Defined within VNETs for segmentation
  - Supports IPv4 and IPv6 configurations
  - Allows routed access or NAT configuration for tenant traffic

---

## ⚙️ Technical Concepts from Proxmox

- **MAC Address Management**:
  - Each VM/LXC gets a virtual MAC (e.g., `52:54:00:XX:XX:XX`)
  - Avoid MAC collisions by ensuring unique assignments

- **Bonding / NIC Aggregation**:
  - `bond0` interfaces allow active-backup or 802.3ad (LACP) load balancing
  - Useful for high availability and redundancy

- **MTU / Jumbo Frames**:
  - For VXLAN or SDN, raise MTU to 9000+ where supported
  - All interfaces in the path must support matching MTU size

- **Routing and Gateways**:
  - Proxmox relies on `/etc/network/interfaces` and `ip route` tables
  - Each bridge or interface can define its own gateway when used for routing

---

## 🔐 Related Topics

While not under this directory, the following subjects are tightly coupled with network behavior:

- **VPN / Mesh Access** (`/vpn/`)
  - Used for remote admin, site-to-site overlay, and multi-cloud access
  - Tailscale, Headscale, WireGuard

- **Firewalls** (`/firewall/`)
  - Datacenter and per-node Proxmox firewalls
  - Port filtering, cluster security, and external firewall handoff (e.g. OPNSense)

---

## 📚 Planned Structure

```
/network
  ├── bridges/
  ├── vlans/
  ├── sdn/
  │   ├── vnets/
  │   ├── zones/
  │   ├── subnets/
  │   └── vxlan/
  └── README.md
```

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)
