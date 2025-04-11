# Proxmox Remote Access Overview (VPN,
## VPN Solutions & Proxmox: WireGuard, Tailscale, Headscale

This section serves as a technical knowledgebase for remote access and overlay networking solutions in the context of Proxmox-based infrastructure. It includes general insights, behavior notes, and integration tips for VPN technologies like WireGuard, Tailscale, and Headscale — specifically when used alongside virtualized environments, SDN, and container workloads.

---

## Purpose

The objective is to document:

- Remote access strategies used to securely manage Proxmox clusters, VMs, and LXC containers.
- Transitioning away from third-party VPN control planes (like Tailscale) to self-hosted, auditable infrastructure.
- Networking behaviors and caveats specific to SDN bridges, overlay networks, and container constraints.

This is **not** a scripts repository. It is a **technical reference** for planning, configuring, and troubleshooting VPN tools in Proxmox-centered environments.

---

## Solution Overviews

### 🔹 Tailscale
- Easy to set up mesh VPN using WireGuard with auto-assigned IPs and NAT traversal.
- Proxmox Integration Notes:
  - Requires TUN support for LXC containers (must manually enable in `lxc.conf`).
  - MagicDNS may behave inconsistently inside containers or with multiple advertised subnets.
  - Useful for temporary access or remote admin but limited in route control.

### 🔸 Headscale
- Self-hosted coordination server for Tailscale clients with full control over identity, routing, and domains.
- Proxmox Integration Notes:
  - Provides central OIDC login, device policy management.
  - Eliminates reliance on upstream relays or control planes.
  - Recommended for long-term infrastructure use and production services.

### ⚙️ WireGuard
- Core transport protocol used under both Tailscale and Headscale.
- Can be used independently for direct tunnels between hosts.
- Proxmox Integration Notes:
  - Ideal for bridging Proxmox SDN networks across nodes and sites.
  - Minimal overhead, fast setup, and high performance.
  - Requires port forwarding if behind NAT/firewalls.

---

## Migration & Integration Goals

- Transition all core infrastructure to **Headscale + WireGuard**.
- Use WireGuard for direct site-to-site SDN bridging.
- Support legacy and mobile access via existing Tailscale clients as needed.
- Address common issues such as:
  - Overlapping subnets
  - Multi-subnet route conflicts
  - DNS propagation inside nested networks or container overlays

---

Each VPN-related tool has its own directory for knowledge and references:

```
vpn/
├── wireguard/   # Overview of point-to-point tunnels, SDN bridging
├── tailscale/   # Notes on setup, container support, MagicDNS issues
└── headscale/   # Self-hosted control plane config, OIDC, migration tips
```

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)

