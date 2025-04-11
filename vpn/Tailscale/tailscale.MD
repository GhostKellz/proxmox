# Tailscale + Proxmox Integration Notes

This document outlines integration specifics, known behaviors, and useful configuration details when using **Tailscale** in a Proxmox virtualized environment. Tailscale is often used for quick access and zero-config connectivity across nodes, containers, and remote endpoints — but it presents challenges in more complex or long-lived setups.

---

## Overview

- **Protocol**: WireGuard (used under the hood)
- **Coordination**: Tailscale-managed, third-party control plane
- **Usage Model**: Great for mobile devices, temporary access, or fast bootstrapping of remote access

---

## Common Proxmox-Specific Considerations

### LXC Containers
- Tailscale needs a working **TUN device** inside the container.
- Required LXC config options (add to the container’s `100.conf`, etc.):
  ```
  lxc.cgroup2.devices.allow = c 10:200 rwm
  lxc.mount.entry = /dev/net/tun dev/net/tun none bind,create=file
  ```
- May require disabling AppArmor if the container is too restricted.

### MagicDNS
- Can conflict with:
  - `systemd-resolved` in LXCs or VMs
  - Custom DNS setups (e.g. Unbound, Technitium)
- When used with advertised routes, MagicDNS can become unpredictable in containers or behind NAT.

### Route Advertisement
- You can advertise subnets using:
  ```
  sudo tailscale up --advertise-routes=10.10.10.0/24
  ```
- However, **advertising multiple SDN subnets** (or VLANs) often causes issues in Proxmox environments due to:
  - Route prioritization
  - Firewall rules
  - MTU size mismatches

### Port Forwarding
- Tailscale does not support **incoming connections** unless another node relays the request.
- Use `tailscale serve` or `funnel` in limited cases, but this is not ideal for production infrastructure.

---

## When to Use

✅ Great for:
- Admin access to nodes
- Mobile clients, quick bootstrap
- Temporary tunnels while migrating to Headscale

🚫 Less suited for:
- Proxmox SDN/subnet routing
- Services that require direct inbound access
- Fully air-gapped or auditable environments

---

## Planned Subsections

To be documented in this folder:

### 🔧 Configuration & Tweaks
- Example `tailscale up` command usage for subnet routing
- Tailscale node tagging for ACL policies
- Recommended DNS mode (split vs MagicDNS fallback)

### 🔐 ACLs and Security
- Recommended ACL policy examples to allow Proxmox nodes to:
  - Access each other over Tailscale
  - Restrict or allow inbound from mobile/admin devices

### 📂 Example Files
- Sample `/etc/pve/lxc/100.conf` LXC file enabling TUN
- Example `tailscale.json` ACL config from admin panel
- Optional systemd service overrides for container auto-start

### 📘 Troubleshooting
- Debugging route conflicts
- Diagnosing DNS resolution issues inside LXCs
- Checking MTU problems and flow disruption

---

## Alternatives

If full control, auditing, and long-term performance are required:
- Use **Headscale** (self-hosted Tailscale-compatible coordination)
- Use **WireGuard** directly for performance and static site-to-site links

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)

