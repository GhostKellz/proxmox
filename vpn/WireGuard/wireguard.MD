# WireGuard

This document covers using **WireGuard** in Proxmox environments for high-performance, low-overhead, and fully controlled peer-to-peer tunneling. WireGuard is ideal for interconnecting Proxmox nodes, bridging SDN networks, and creating long-term secure tunnels between sites.

---

## Overview

- **Protocol**: WireGuard (UDP-based VPN)
- **Coordination**: Manual key exchange or orchestrated via tools (e.g., Headscale, helper-scripts)
- **Usage Model**: Best for site-to-site links, SDN extension, or Proxmox infrastructure overlay

---

## Integration Notes for Proxmox

### Host-Level Setup
- Install `wireguard-tools` on Proxmox nodes:
  ```bash
  apt install wireguard wireguard-tools
  ```
- Use `wg-quick` or `systemd` units to bring up interfaces on boot.
- Ensure required kernel modules are loaded (`wireguard`, `iptable_nat`, etc.).

### LXC Container Considerations
- For containers acting as WireGuard peers:
  - Must be **privileged** OR have specific `capabilities` + TUN device access.
  - Example LXC config tweaks:
    ```
    lxc.cgroup2.devices.allow = c 10:200 rwm
    lxc.mount.entry = /dev/net/tun dev/net/tun none bind,create=file
    lxc.apparmor.profile = unconfined
    ```

### Proxmox Firewall
- If using Proxmox's datacenter/node firewall:
  - Allow **UDP traffic** on WireGuard port (usually `51820`):
    - Add rule under: `Datacenter > Firewall > Options` or `Node > Firewall`
  - Ensure inter-node access is explicitly allowed in **group policies** or interface rules.

---

## Usage Scenarios

✅ Ideal for:
- Proxmox node interconnection over public IPs or private links
- Backplane for Proxmox SDN (e.g. extending SDN overlays across regions)
- Secure remote Proxmox access via jumpbox or exposed peer

🚫 Less ideal for:
- Dynamic access unless paired with Headscale or manual automation
- Mobile use cases (Tailscale or OpenVPN may be more appropriate)

---

## Planned Subsections

To be documented in this folder:

### ⚙️ Basic Peer Setup
- Static WireGuard peer configuration (`wg0.conf`)
- Recommended MTU and routing tweaks for SDN bridging
- Auto-start using `systemd` or `wg-quick`

### 🔁 Proxmox Node-to-Node Tunnels
- Helper-script usage for rapid deployment
- NAT traversal and routing notes
- DNS config for intra-cluster resolution

### 🔐 Security & Hardening
- Key rotation practices
- Disabling IP forwarding selectively per interface
- Logs and diagnostics via `wg show`

### 🧪 Troubleshooting
- MTU mismatch debugging
- Peer handshake failures
- Firewall rule checks (Proxmox + iptables)

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)
