# Proxmox Firewall Overview

This section documents the use of the built-in Proxmox firewall system at multiple layers, including **Datacenter**, **Node**, and **VM/CT** levels. It includes rulesets, configuration examples, templates, and advanced considerations when designing secure, scalable Proxmox environments.

Proxmox's firewall integrates seamlessly into clusters, supports IPv4/IPv6, and includes fine-grained control through IP sets, alias groups, macros, and service-specific rules.

---

## 📁 Directory Layout
```
/firewall
  ├── datacenter/       # Global rules enforced cluster-wide
  ├── node/             # Node-specific rules (e.g., SSH, PBS, monitoring)
  ├── templates/        # Reusable firewall macros, groups, ACL patterns
  ├── integration/      # Syncing and bridging to external firewalls
  ├── rules/         # Reference rules for PBS, Docker, SDN, etc.
  └── vm-lxc/           # Optional examples for guest-level firewalling
```

---

## 🔍 Firewall Architecture

The Proxmox firewall system is **multi-layered**, meaning each level builds on top of the previous and provides scoped control:

### Datacenter-Level Firewall
- Applies **cluster-wide**, affecting all nodes and guests unless overridden
- Ideal for:
  - Blocking unused ports
  - Allow-listing subnets to access Proxmox GUI/API (8006)
  - Managing SDN ingress/egress or VPN tunnels
- Supports:
  - Macros (`SSH`, `HTTP`, `ICMP`), rate limiting
  - IP sets and groups for policy reuse

> **⚠️ DO NOT SIMPLY ENABLE DATACENTER FIREWALL BLINDLY**
> This will block access to your GUI/API/SSH if no allow rules exist. Configure rules first!

### Node-Level Firewall
- Applied per hypervisor node
- Used to protect services that run *on the node itself*:
  - SSH, Proxmox Backup Agent, Docker services, exporters
- Especially useful when nodes serve different roles (e.g., gateway vs storage)
- Can be paired with SDN zone or IP-based ACL rules

### VM / LXC-Level Firewall
- Rules applied directly to guest virtual NICs (vNICs)
- Enables tenant isolation in multi-tenant setups or zero-trust overlays
- Supports:
  - Stateful filtering (no need to explicitly allow response traffic)
  - Logging, MAC/IP filtering, port blocks, connection limits
- Managed via:
  - GUI > VM > Firewall
  - CLI with `pct` / `qm` + `firewall` subcommands

---

## 💡 Best Practices & Warnings

- **ALWAYS test rules in a non-production environment first**
- **DO NOT ENABLE datacenter firewall without explicit allow rules**, especially for ports like `8006`, `22`, or your VPN overlay ports
- Use **IP sets** and **alias groups** to simplify complex rule logic
- Apply **templates** for PBS, NGINX, DNS, and SDN containers where possible
- Monitor traffic before enabling hard drops—start with logs
- Prefer VM/CT firewall only in untrusted or exposed services
- SDN Zones may have **separate firewalls** that override node-level logic

---

## 🛡️ Common Use Cases

### Datacenter-Level Rules
- Whitelist GUI/API for office VPN subnets only
- Deny inbound traffic to all except specific SDN zone tunnels
- Allow only DNS, NTP, and syslog across node control plane

### Node-Level Rules
- Allow SSH from bastion or trusted admin subnet
- PBS replication ports opened for internal sync
- Open port 9000 for local MinIO or Docker registry
- Permit monitoring (SNMP, Prometheus exporter) from Grafana server only

### Guest-Level Rules (VM/CT)
- Isolate containers in a DMZ using `DROP`-by-default policies
- Allow HTTPS + SSH only to dev/test VMs
- Control egress from CI/CD runners

---

## 🔗 Related Topics
- SDN firewall: zone-level security and tenant separation
- Integration with FortiGate, OPNSense, UFW (via scripts in `integration/`)
- CLI and config parser automation using `pve-firewall` commands
- Proxmox logging (journalctl, `pve-firewall restart`, `iptables-save`)

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)

