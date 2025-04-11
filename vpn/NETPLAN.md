# Netplan Overview

This readme outlines the evolving remote access and VPN mesh strategy for my infrastructure, with a focus on Proxmox environments, SDN overlays, and backup services. It reflects a transition from traditional VPN solutions to modern mesh-based networking for enhanced control, performance, and flexibility.

As hybrid environments grow in complexity, **SDN and VPN overlays have become essential** for secure and scalable network segmentation. Legacy VPNs like SSL/IPSec are increasingly replaced by mesh-based overlays using **WireGuard**, valued for their simplicity, performance, and modern security posture.

Today’s ecosystem offers a variety of mesh overlay solutions — including **Tailscale**, **Netbird**, **Zerotier**, **Twingate**, **Nebula**, and **Netmaker** — most of which build on WireGuard. These tools abstract Layer 3/4 networking to offer intuitive access control and connectivity, representing a shift from rigid Layer 2 paradigms to dynamic, policy-driven mesh topologies.

---

## 🌐 Current Infrastructure Overview

- **Proxmox Cloud Nodes**: 2 standalone Proxmox instances, each on separate bare metal cloud servers with 5 public IPs available per host.
- **Proxmox SDN**: One node currently configured with SDN and operating on the `10.10.10.0/24` overlay subnet for testing.
- **Home Cluster**: 3-node Proxmox cluster ("galaxy") integrated with a Synology NAS and local VLAN isolation.
- **Backup Services**:
  - **Veeam Backup & Replication** and **Proxmox Backup Server** running on isolated VLANs.
  - These are currently hosted locally, but may migrate to a third bare metal cloud-hosted Proxmox node with high storage capacity and redundancy (e.g. ZFS/RAID).
  - If introduced, the third cloud-hosted node would also take over **MinIO**, currently running on an existing node.
- **Other Routing Components**:
  - OPNsense firewall VM tied to one Proxmox node in the cloud.
  - Fortigate 90G at home providing SD-WAN with fiber primary and cable backup.
  - Tailscale clients deployed across Synology NAS, OPNsense, LXC containers, and more.

---

## 🔄 Migrating from Tailscale to Headscale + WireGuard

Tailscale has been a powerful and accessible tool for establishing a fast mesh overlay, but it increasingly showed limitations as infrastructure complexity grew. To regain full control and better tailor behavior to the Proxmox and SDN landscape, we're pivoting to a hybrid strategy based on **Headscale** and **direct WireGuard tunnels**.

### 🚧 Technical Shortcomings

- **Route Advertisement Chaos**:
  - As more devices joined the Tailscale network and began advertising subnet routes (e.g. Synology, OPNsense, containers), conflicts emerged.
  - There is no clean or scalable way to prioritize routes across multiple peers.
  - Even using route priority flags or tweaking exit node settings introduces complexity and brittleness across clients.
  - Attempts to enforce route priorities across devices often yield inconsistent results and increase administrative overhead.
  - Maintaining custom routing logic introduces risk of routing loops, broken connectivity, and network flapping.

- **Relay Dependency (DERP)**:
  - Traffic frequently traversed DERP relay nodes, introducing latency — unacceptable for replication, SDN traffic, or backup traffic.
  - There's no straightforward way to guarantee direct peering in all scenarios, especially in NAT-constrained environments.
  - While ACLs can limit access and influence routing behavior, they do not enforce direct peer paths or bypass relays reliably.

- **Limited Coordination Plane**:
  - Tailscale's proprietary coordination plane restricts visibility, policy enforcement, and fine-grained control.
  - Lack of access to logs, audit trails, or customizable ACL structures at scale.

- **MagicDNS Caveats**:
  - While convenient, MagicDNS occasionally causes resolution failures or stale records, especially when devices come online and offline frequently or when namespaces grow.
  - Lack of a centralized DNS management interface or cache purging options makes troubleshooting difficult.


